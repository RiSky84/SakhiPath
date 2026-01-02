
INSERT INTO safe_spots (location, address, name, category, phone_number, is_24x7, is_verified) VALUES

(ST_GeogFromText('POINT(77.2090 28.6139)'), 'Connaught Place, New Delhi', 'AIIMS', 'hospital', '+911126588500', true, true),
(ST_GeogFromText('POINT(77.1025 28.5355)'), 'Saket, New Delhi', 'Max Hospital Saket', 'hospital', '+911126515050', true, true),

(ST_GeogFromText('POINT(77.2167 28.6333)'), 'Connaught Place', 'Connaught Place Police Station', 'police_station', '+911123417321', true, true),
(ST_GeogFromText('POINT(77.0688 28.4595)'), 'Cyber City, Gurgaon', 'DLF Cyber City Police Post', 'police_station', '+911244335100', true, true),

(ST_GeogFromText('POINT(77.2285 28.6358)'), 'India Gate Circle', 'Indian Oil Petrol Pump', 'petrol_pump', '+911123386745', true, true),
(ST_GeogFromText('POINT(77.0833 28.5244)'), 'NH-8, Gurgaon', 'HP Petrol Pump', 'petrol_pump', '+911244567890', true, true),

(ST_GeogFromText('POINT(77.2167 28.6127)'), 'Khan Market, Delhi', 'CCD Khan Market', 'cafe_24x7', '+911124622345', true, true),

(ST_GeogFromText('POINT(77.2500 28.6562)'), 'Kashmere Gate, Delhi', 'Jama Masjid', 'mosque', '+911123277784', true, true),
(ST_GeogFromText('POINT(77.2075 28.6562)'), 'Gurdwara Bangla Sahib', 'Gurdwara Bangla Sahib', 'gurudwara', '+911123364009', true, true),
(ST_GeogFromText('POINT(77.2245 28.6692)'), 'Chandni Chowk', 'Gauri Shankar Temple', 'temple', NULL, true, true);

INSERT INTO road_segments (
    start_point, end_point, path, name, road_type, length_meters,
    streetlights_count, open_businesses_count, avg_crowd_density,
    cctv_cameras_count, has_footpath, road_width_meters,
    safety_reports_positive, safety_reports_negative
) VALUES

(
    ST_GeogFromText('POINT(77.2167 28.6333)'),
    ST_GeogFromText('POINT(77.2190 28.6320)'),
    ST_GeogFromText('LINESTRING(77.2167 28.6333, 77.2190 28.6320)'),
    'Connaught Place Inner Circle', 'arterial', 300,
    60, 45, 0.8, 12, true, 12.0,
    125, 5
),

(
    ST_GeogFromText('POINT(77.0688 28.4595)'),
    ST_GeogFromText('POINT(77.0750 28.4620)'),
    ST_GeogFromText('LINESTRING(77.0688 28.4595, 77.0750 28.4620)'),
    'DLF Cyber City Road', 'arterial', 400,
    80, 35, 0.7, 18, true, 15.0,
    98, 2
),

(
    ST_GeogFromText('POINT(77.0833 28.5244)'),
    ST_GeogFromText('POINT(77.0500 28.4800)'),
    ST_GeogFromText('LINESTRING(77.0833 28.5244, 77.0500 28.4800)'),
    'NH-48 Delhi-Gurgaon Expressway', 'highway', 5000,
    150, 5, 0.3, 25, false, 25.0,
    45, 15
),

(
    ST_GeogFromText('POINT(77.2100 28.6200)'),
    ST_GeogFromText('POINT(77.2120 28.6180)'),
    ST_GeogFromText('LINESTRING(77.2100 28.6200, 77.2120 28.6180)'),
    'Local Street, Defence Colony', 'residential', 250,
    15, 3, 0.2, 2, true, 6.0,
    8, 12
);

INSERT INTO users (id, phone_number, name, email, gender, language_preference, baseline_heart_rate, baseline_hrv) VALUES
('00000000-0000-0000-0000-000000000001', '+919876543210', 'Priya Sharma', 'priya@example.com', 'female', 'hi', 72, 55),
('00000000-0000-0000-0000-000000000002', '+919876543211', 'Anjali Verma', 'anjali@example.com', 'female', 'en', 75, 52);

INSERT INTO trusted_contacts (user_id, name, phone_number, relation, priority) VALUES
('00000000-0000-0000-0000-000000000001', 'Papa', '+919876543220', 'father', 1),
('00000000-0000-0000-0000-000000000001', 'Mummy', '+919876543221', 'mother', 1),
('00000000-0000-0000-0000-000000000001', 'Bhaiya', '+919876543222', 'brother', 2),
('00000000-0000-0000-0000-000000000001', 'Best Friend', '+919876543223', 'friend', 3);

INSERT INTO safety_reports (user_id, location, address, report_type, description, severity, is_verified) VALUES
('00000000-0000-0000-0000-000000000001', 
 ST_GeogFromText('POINT(77.2167 28.6333)'), 
 'Connaught Place', 
 'safe', 
 'Well lit area with many people around even at night. Feels very safe.', 
 1, 
 true),

('00000000-0000-0000-0000-000000000002', 
 ST_GeogFromText('POINT(77.2100 28.6200)'), 
 'Defence Colony back lane', 
 'unsafe', 
 'Dark street with no lights. Very isolated at night.', 
 4, 
 true);

COMMIT;
