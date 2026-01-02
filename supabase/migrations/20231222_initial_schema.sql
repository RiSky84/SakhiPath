
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TYPE user_gender AS ENUM ('female', 'male', 'other', 'prefer_not_to_say');
CREATE TYPE sos_trigger_source AS ENUM ('manual', 'voice', 'biometric_hr', 'shake', 'fall', 'gesture', 'volume_button', 'stealth');
CREATE TYPE sos_status AS ENUM ('active', 'resolved', 'false_alarm', 'cancelled');
CREATE TYPE safe_spot_category AS ENUM ('hospital', 'police_station', 'petrol_pump', 'cafe_24x7', 'hotel', 'temple', 'mosque', 'gurudwara', 'church', 'pharmacy');
CREATE TYPE ride_status AS ENUM ('active', 'completed', 'cancelled');
CREATE TYPE escort_status AS ENUM ('active', 'completed', 'cancelled');

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    phone_number VARCHAR(15) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255),
    gender user_gender,
    date_of_birth DATE,
    profile_photo_url TEXT,
    
    
    language_preference VARCHAR(10) DEFAULT 'hi',
    route_preference VARCHAR(20) DEFAULT 'safest',
    sos_audio_recording BOOLEAN DEFAULT true,
    sos_photo_capture BOOLEAN DEFAULT true,
    biometric_monitoring_enabled BOOLEAN DEFAULT false,
    voice_commands_enabled BOOLEAN DEFAULT true,
    
    
    baseline_heart_rate INTEGER,
    baseline_hrv FLOAT,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_users_phone ON users(phone_number);

CREATE TABLE trusted_contacts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    phone_number VARCHAR(15) NOT NULL,
    email VARCHAR(255),
    relation VARCHAR(50),
    priority INTEGER DEFAULT 5,
    is_emergency_contact BOOLEAN DEFAULT true,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_trusted_contacts_user ON trusted_contacts(user_id);

CREATE TABLE road_segments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    
    start_point GEOGRAPHY(POINT, 4326) NOT NULL,
    end_point GEOGRAPHY(POINT, 4326) NOT NULL,
    path GEOGRAPHY(LINESTRING, 4326) NOT NULL,
    
    
    name VARCHAR(255),
    road_type VARCHAR(50),
    length_meters FLOAT,
    
    
    streetlights_count INTEGER DEFAULT 0,
    streetlights_per_km FLOAT GENERATED ALWAYS AS (streetlights_count / NULLIF(length_meters / 1000.0, 0)) STORED,
    open_businesses_count INTEGER DEFAULT 0,
    avg_crowd_density FLOAT DEFAULT 0,
    cctv_cameras_count INTEGER DEFAULT 0,
    has_footpath BOOLEAN DEFAULT false,
    road_width_meters FLOAT,
    
    
    safety_reports_positive INTEGER DEFAULT 0,
    safety_reports_negative INTEGER DEFAULT 0,
    last_incident_reported_at TIMESTAMP WITH TIME ZONE,
    
    
    crowd_density_by_hour JSONB,
    businesses_open_by_hour JSONB,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_road_segments_start ON road_segments USING GIST(start_point);
CREATE INDEX idx_road_segments_end ON road_segments USING GIST(end_point);
CREATE INDEX idx_road_segments_path ON road_segments USING GIST(path);

CREATE TABLE safe_spots (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    
    location GEOGRAPHY(POINT, 4326) NOT NULL,
    address TEXT NOT NULL,
    
    
    name VARCHAR(255) NOT NULL,
    category safe_spot_category NOT NULL,
    phone_number VARCHAR(15),
    is_24x7 BOOLEAN DEFAULT false,
    opening_hours JSONB,
    
    
    is_verified BOOLEAN DEFAULT false,
    verified_at TIMESTAMP WITH TIME ZONE,
    verified_by UUID REFERENCES users(id),
    
    
    rating FLOAT CHECK (rating >= 0 AND rating <= 5),
    total_ratings INTEGER DEFAULT 0,
    
    
    description TEXT,
    amenities JSONB,
    photos JSONB,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_safe_spots_location ON safe_spots USING GIST(location);
CREATE INDEX idx_safe_spots_category ON safe_spots(category);
CREATE INDEX idx_safe_spots_24x7 ON safe_spots(is_24x7) WHERE is_24x7 = true;

CREATE TABLE sos_events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id),
    
    
    trigger_source sos_trigger_source NOT NULL,
    trigger_data JSONB,
    
    
    location GEOGRAPHY(POINT, 4326) NOT NULL,
    location_accuracy FLOAT,
    address TEXT,
    
    
    status sos_status DEFAULT 'active',
    severity VARCHAR(20) NOT NULL,
    
    
    audio_recording_url TEXT,
    photos JSONB,
    video_url TEXT,
    
    
    heart_rate INTEGER,
    detected_emotion VARCHAR(50),
    stress_level FLOAT,
    
    
    contacts_notified JSONB,
    police_notified BOOLEAN DEFAULT false,
    police_notified_at TIMESTAMP WITH TIME ZONE,
    safe_spot_id UUID REFERENCES safe_spots(id),
    
    
    triggered_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    resolved_at TIMESTAMP WITH TIME ZONE,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_sos_events_user ON sos_events(user_id);
CREATE INDEX idx_sos_events_status ON sos_events(status) WHERE status = 'active';
CREATE INDEX idx_sos_events_location ON sos_events USING GIST(location);
CREATE INDEX idx_sos_events_triggered ON sos_events(triggered_at DESC);

CREATE TABLE ride_sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id),
    
    
    vehicle_number VARCHAR(20) NOT NULL,
    vehicle_type VARCHAR(50),
    driver_name VARCHAR(100),
    driver_phone VARCHAR(15),
    driver_photo_url TEXT,
    
    
    start_location GEOGRAPHY(POINT, 4326) NOT NULL,
    end_location GEOGRAPHY(POINT, 4326),
    planned_route GEOGRAPHY(LINESTRING, 4326),
    actual_route GEOGRAPHY(LINESTRING, 4326),
    
    
    status ride_status DEFAULT 'active',
    started_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    completed_at TIMESTAMP WITH TIME ZONE,
    
    
    route_deviation_alerts INTEGER DEFAULT 0,
    max_deviation_meters FLOAT,
    
    
    driver_rating INTEGER CHECK (driver_rating >= 1 AND driver_rating <= 5),
    user_feedback TEXT,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_ride_sessions_user ON ride_sessions(user_id);
CREATE INDEX idx_ride_sessions_status ON ride_sessions(status);
CREATE INDEX idx_ride_sessions_vehicle ON ride_sessions(vehicle_number);

CREATE TABLE virtual_escort_sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id),
    
    
    start_location GEOGRAPHY(POINT, 4326) NOT NULL,
    destination GEOGRAPHY(POINT, 4326) NOT NULL,
    planned_route GEOGRAPHY(LINESTRING, 4326),
    checkpoints JSONB,
    
    
    escort_contacts JSONB NOT NULL,
    
    
    status escort_status DEFAULT 'active',
    started_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    completed_at TIMESTAMP WITH TIME ZONE,
    reached_safely BOOLEAN DEFAULT false,
    
    
    current_location GEOGRAPHY(POINT, 4326),
    last_update_at TIMESTAMP WITH TIME ZONE,
    checkpoints_crossed JSONB,
    
    
    deviation_alerts INTEGER DEFAULT 0,
    sos_triggered BOOLEAN DEFAULT false,
    sos_event_id UUID REFERENCES sos_events(id),
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_escort_sessions_user ON virtual_escort_sessions(user_id);
CREATE INDEX idx_escort_sessions_status ON virtual_escort_sessions(status);

CREATE TABLE safety_reports (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id),
    
    
    location GEOGRAPHY(POINT, 4326) NOT NULL,
    address TEXT,
    
    
    report_type VARCHAR(50) NOT NULL, 
    description TEXT,
    severity INTEGER CHECK (severity >= 1 AND severity <= 5),
    
    
    photos JSONB,
    timestamp_of_incident TIMESTAMP WITH TIME ZONE,
    
    
    is_verified BOOLEAN DEFAULT false,
    verified_by UUID REFERENCES users(id),
    upvotes INTEGER DEFAULT 0,
    downvotes INTEGER DEFAULT 0,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_safety_reports_location ON safety_reports USING GIST(location);
CREATE INDEX idx_safety_reports_type ON safety_reports(report_type);
CREATE INDEX idx_safety_reports_user ON safety_reports(user_id);

CREATE TABLE routes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id),
    
    
    name VARCHAR(255),
    start_location GEOGRAPHY(POINT, 4326) NOT NULL,
    start_address TEXT,
    end_location GEOGRAPHY(POINT, 4326) NOT NULL,
    end_address TEXT,
    
    
    route_path GEOGRAPHY(LINESTRING, 4326) NOT NULL,
    route_type VARCHAR(20), 
    distance_meters FLOAT,
    duration_seconds INTEGER,
    safety_score FLOAT,
    
    
    is_favorite BOOLEAN DEFAULT false,
    times_used INTEGER DEFAULT 1,
    last_used_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_routes_user ON routes(user_id);
CREATE INDEX idx_routes_favorite ON routes(user_id, is_favorite) WHERE is_favorite = true;

CREATE TABLE driver_ratings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    vehicle_number VARCHAR(20) NOT NULL,
    driver_name VARCHAR(100),
    
    
    avg_rating FLOAT CHECK (avg_rating >= 0 AND avg_rating <= 5),
    total_ratings INTEGER DEFAULT 0,
    total_rides INTEGER DEFAULT 0,
    
    
    incidents_reported INTEGER DEFAULT 0,
    route_deviations INTEGER DEFAULT 0,
    
    
    last_ride_at TIMESTAMP WITH TIME ZONE,
    last_location GEOGRAPHY(POINT, 4326),
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    UNIQUE(vehicle_number)
);

CREATE INDEX idx_driver_ratings_vehicle ON driver_ratings(vehicle_number);

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_trusted_contacts_updated_at BEFORE UPDATE ON trusted_contacts FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_road_segments_updated_at BEFORE UPDATE ON road_segments FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_safe_spots_updated_at BEFORE UPDATE ON safe_spots FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_sos_events_updated_at BEFORE UPDATE ON sos_events FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_ride_sessions_updated_at BEFORE UPDATE ON ride_sessions FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_virtual_escort_sessions_updated_at BEFORE UPDATE ON virtual_escort_sessions FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_safety_reports_updated_at BEFORE UPDATE ON safety_reports FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_routes_updated_at BEFORE UPDATE ON routes FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_driver_ratings_updated_at BEFORE UPDATE ON driver_ratings FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE trusted_contacts ENABLE ROW LEVEL SECURITY;
ALTER TABLE sos_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE ride_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE virtual_escort_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE safety_reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE routes ENABLE ROW LEVEL SECURITY;

CREATE POLICY users_select_own ON users FOR SELECT USING (auth.uid()::uuid = id);
CREATE POLICY users_update_own ON users FOR UPDATE USING (auth.uid()::uuid = id);

CREATE POLICY contacts_select_own ON trusted_contacts FOR SELECT USING (auth.uid()::uuid = user_id);
CREATE POLICY contacts_insert_own ON trusted_contacts FOR INSERT WITH CHECK (auth.uid()::uuid = user_id);
CREATE POLICY contacts_update_own ON trusted_contacts FOR UPDATE USING (auth.uid()::uuid = user_id);
CREATE POLICY contacts_delete_own ON trusted_contacts FOR DELETE USING (auth.uid()::uuid = user_id);

CREATE POLICY sos_select_own ON sos_events FOR SELECT USING (auth.uid()::uuid = user_id);
CREATE POLICY sos_insert_own ON sos_events FOR INSERT WITH CHECK (auth.uid()::uuid = user_id);
CREATE POLICY sos_update_own ON sos_events FOR UPDATE USING (auth.uid()::uuid = user_id);

CREATE POLICY safe_spots_select_all ON safe_spots FOR SELECT USING (true);

CREATE POLICY road_segments_select_all ON road_segments FOR SELECT USING (true);
