
CREATE OR REPLACE FUNCTION get_nearby_road_segments(
    route_points TEXT[],
    radius_meters FLOAT DEFAULT 50
)
RETURNS TABLE (
    id UUID,
    length_meters FLOAT,
    streetlights_per_km FLOAT,
    open_businesses_count INTEGER,
    avg_crowd_density FLOAT,
    cctv_cameras_count INTEGER,
    has_footpath BOOLEAN,
    road_width_meters FLOAT,
    safety_reports_positive INTEGER,
    safety_reports_negative INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT DISTINCT
        rs.id,
        rs.length_meters,
        rs.streetlights_per_km,
        rs.open_businesses_count,
        rs.avg_crowd_density,
        rs.cctv_cameras_count,
        rs.has_footpath,
        rs.road_width_meters,
        rs.safety_reports_positive,
        rs.safety_reports_negative
    FROM road_segments rs
    WHERE EXISTS (
        SELECT 1
        FROM unnest(route_points) AS point
        WHERE ST_DWithin(
            rs.path::geography,
            ST_GeogFromText(point),
            radius_meters
        )
    );
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION find_nearest_safe_spot(
    user_location TEXT,
    categories safe_spot_category[] DEFAULT ARRAY['hospital', 'police_station', 'petrol_pump']::safe_spot_category[],
    max_distance_meters FLOAT DEFAULT 5000,
    limit_count INTEGER DEFAULT 5
)
RETURNS TABLE (
    id UUID,
    name VARCHAR,
    category safe_spot_category,
    address TEXT,
    phone_number VARCHAR,
    is_24x7 BOOLEAN,
    distance_meters FLOAT,
    location_lat FLOAT,
    location_lng FLOAT
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        ss.id,
        ss.name,
        ss.category,
        ss.address,
        ss.phone_number,
        ss.is_24x7,
        ST_Distance(
            ss.location::geography,
            ST_GeogFromText(user_location)
        ) AS distance_meters,
        ST_Y(ss.location::geometry) AS location_lat,
        ST_X(ss.location::geometry) AS location_lng
    FROM safe_spots ss
    WHERE ss.category = ANY(categories)
        AND ST_DWithin(
            ss.location::geography,
            ST_GeogFromText(user_location),
            max_distance_meters
        )
    ORDER BY distance_meters ASC
    LIMIT limit_count;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_area_safety_score(
    center_location TEXT,
    radius_meters FLOAT DEFAULT 500
)
RETURNS TABLE (
    overall_score FLOAT,
    lighting_score FLOAT,
    business_score FLOAT,
    crowd_score FLOAT,
    reports_score FLOAT
) AS $$
DECLARE
    avg_lighting FLOAT;
    avg_business FLOAT;
    avg_crowd FLOAT;
    positive_reports INTEGER;
    negative_reports INTEGER;
    report_score FLOAT;
BEGIN
    
    SELECT
        AVG(COALESCE(streetlights_per_km * 2, 5)),
        AVG(COALESCE(open_businesses_count, 0)),
        AVG(COALESCE(avg_crowd_density * 10, 5))
    INTO avg_lighting, avg_business, avg_crowd
    FROM road_segments
    WHERE ST_DWithin(
        path::geography,
        ST_GeogFromText(center_location),
        radius_meters
    );

    
    SELECT
        SUM(CASE WHEN report_type IN ('safe') THEN 1 ELSE 0 END),
        SUM(CASE WHEN report_type IN ('unsafe', 'incident', 'harassment') THEN 1 ELSE 0 END)
    INTO positive_reports, negative_reports
    FROM safety_reports
    WHERE ST_DWithin(
        location::geography,
        ST_GeogFromText(center_location),
        radius_meters
    )
    AND created_at > NOW() - INTERVAL '30 days';

    
    IF (positive_reports + negative_reports) > 0 THEN
        report_score := (positive_reports::FLOAT / (positive_reports + negative_reports)) * 10;
    ELSE
        report_score := 5.0;
    END IF;

    
    RETURN QUERY SELECT
        (COALESCE(LEAST(avg_lighting, 10), 5) * 0.35 +
         COALESCE(LEAST(avg_business, 10), 5) * 0.25 +
         COALESCE(LEAST(avg_crowd, 10), 5) * 0.25 +
         report_score * 0.15)::FLOAT,
        COALESCE(LEAST(avg_lighting, 10), 5)::FLOAT,
        COALESCE(LEAST(avg_business, 10), 5)::FLOAT,
        COALESCE(LEAST(avg_crowd, 10), 5)::FLOAT,
        report_score::FLOAT;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION check_route_deviation(
    planned_route_geom TEXT,
    current_location TEXT,
    threshold_meters FLOAT DEFAULT 200
)
RETURNS BOOLEAN AS $$
DECLARE
    distance FLOAT;
BEGIN
    SELECT ST_Distance(
        ST_GeomFromText(planned_route_geom)::geography,
        ST_GeogFromText(current_location)
    ) INTO distance;

    RETURN distance > threshold_meters;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_safety_heatmap(
    bbox_min_lat FLOAT,
    bbox_min_lng FLOAT,
    bbox_max_lat FLOAT,
    bbox_max_lng FLOAT,
    grid_size INTEGER DEFAULT 50
)
RETURNS TABLE (
    lat FLOAT,
    lng FLOAT,
    safety_score FLOAT
) AS $$
DECLARE
    lat_step FLOAT;
    lng_step FLOAT;
    current_lat FLOAT;
    current_lng FLOAT;
BEGIN
    lat_step := (bbox_max_lat - bbox_min_lat) / grid_size;
    lng_step := (bbox_max_lng - bbox_min_lng) / grid_size;

    FOR i IN 0..grid_size LOOP
        FOR j IN 0..grid_size LOOP
            current_lat := bbox_min_lat + (i * lat_step);
            current_lng := bbox_min_lng + (j * lng_step);

            RETURN QUERY
            SELECT
                current_lat,
                current_lng,
                (SELECT overall_score FROM get_area_safety_score(
                    'POINT(' || current_lng || ' ' || current_lat || ')',
                    500
                ));
        END LOOP;
    END LOOP;
END;
$$ LANGUAGE plpgsql;
