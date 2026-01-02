
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE profiles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    full_name TEXT,
    phone TEXT,
    role TEXT CHECK (role IN ('student', 'parent', 'guardian', 'teacher')),
    avatar_url TEXT,
    date_of_birth DATE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id)
);

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own profile" ON profiles
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can update own profile" ON profiles
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own profile" ON profiles
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE TABLE study_sessions (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    session_id TEXT NOT NULL,
    session_type TEXT NOT NULL,
    subject TEXT,
    start_time TIMESTAMP WITH TIME ZONE NOT NULL,
    end_time TIMESTAMP WITH TIME ZONE,
    duration_minutes NUMERIC,
    breaks_taken INTEGER DEFAULT 0,
    productivity_score NUMERIC,
    notes TEXT,
    goal_achieved BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, session_id)
);

CREATE INDEX idx_study_sessions_user_time ON study_sessions(user_id, start_time DESC);

ALTER TABLE study_sessions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own sessions" ON study_sessions
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own sessions" ON study_sessions
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE TABLE reminders (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    reminder_id TEXT NOT NULL,
    title TEXT NOT NULL,
    message TEXT,
    reminder_type TEXT NOT NULL,
    priority TEXT NOT NULL,
    scheduled_time TIMESTAMP WITH TIME ZONE NOT NULL,
    frequency TEXT NOT NULL,
    enabled BOOLEAN DEFAULT TRUE,
    custom_days JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, reminder_id)
);

CREATE INDEX idx_reminders_user_time ON reminders(user_id, scheduled_time);

ALTER TABLE reminders ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage own reminders" ON reminders
    FOR ALL USING (auth.uid() = user_id);

CREATE TABLE screen_time_sessions (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    app_name TEXT NOT NULL,
    category TEXT NOT NULL,
    start_time TIMESTAMP WITH TIME ZONE NOT NULL,
    end_time TIMESTAMP WITH TIME ZONE,
    duration_seconds INTEGER,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_screen_time_user_time ON screen_time_sessions(user_id, start_time DESC);

ALTER TABLE screen_time_sessions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage own screen time" ON screen_time_sessions
    FOR ALL USING (auth.uid() = user_id);

CREATE TABLE emergency_contacts (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    phone TEXT NOT NULL,
    email TEXT,
    relationship TEXT,
    priority INTEGER DEFAULT 1,
    notify_on_emergency BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_emergency_contacts_user ON emergency_contacts(user_id, priority);

ALTER TABLE emergency_contacts ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage own emergency contacts" ON emergency_contacts
    FOR ALL USING (auth.uid() = user_id);

CREATE TABLE emergency_alerts (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    alert_type TEXT NOT NULL,
    alert_level TEXT NOT NULL,
    heart_rate INTEGER,
    movement_pattern TEXT,
    confidence NUMERIC,
    location_lat NUMERIC,
    location_lng NUMERIC,
    details JSONB,
    resolved BOOLEAN DEFAULT FALSE,
    resolved_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_emergency_alerts_user_time ON emergency_alerts(user_id, created_at DESC);
CREATE INDEX idx_emergency_alerts_unresolved ON emergency_alerts(user_id, resolved) WHERE resolved = FALSE;

ALTER TABLE emergency_alerts ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own alerts" ON emergency_alerts
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own alerts" ON emergency_alerts
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own alerts" ON emergency_alerts
    FOR UPDATE USING (auth.uid() = user_id);

CREATE TABLE emergency_notifications (
    id BIGSERIAL PRIMARY KEY,
    alert_id BIGINT REFERENCES emergency_alerts(id) ON DELETE CASCADE,
    contact_id BIGINT REFERENCES emergency_contacts(id) ON DELETE CASCADE,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    message TEXT,
    sent_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    delivered BOOLEAN DEFAULT FALSE,
    delivered_at TIMESTAMP WITH TIME ZONE
);

CREATE INDEX idx_emergency_notifications_alert ON emergency_notifications(alert_id);

ALTER TABLE emergency_notifications ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view notifications for their alerts" ON emergency_notifications
    FOR SELECT USING (auth.uid() = user_id);

CREATE TABLE user_settings (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    settings JSONB NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id)
);

ALTER TABLE user_settings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage own settings" ON user_settings
    FOR ALL USING (auth.uid() = user_id);

CREATE TABLE biometric_baselines (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    baseline_hr INTEGER,
    baseline_hrv NUMERIC,
    calibrated_at TIMESTAMP WITH TIME ZONE,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id)
);

ALTER TABLE biometric_baselines ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage own biometric data" ON biometric_baselines
    FOR ALL USING (auth.uid() = user_id);

CREATE TABLE focus_sessions (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    session_id TEXT NOT NULL,
    start_time TIMESTAMP WITH TIME ZONE NOT NULL,
    planned_duration INTEGER,
    actual_duration INTEGER,
    focus_level TEXT NOT NULL,
    distractions_blocked INTEGER DEFAULT 0,
    interruptions INTEGER DEFAULT 0,
    completed BOOLEAN DEFAULT FALSE,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, session_id)
);

CREATE INDEX idx_focus_sessions_user_time ON focus_sessions(user_id, start_time DESC);

ALTER TABLE focus_sessions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage own focus sessions" ON focus_sessions
    FOR ALL USING (auth.uid() = user_id);

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON profiles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_reminders_updated_at BEFORE UPDATE ON reminders
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_emergency_contacts_updated_at BEFORE UPDATE ON emergency_contacts
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_settings_updated_at BEFORE UPDATE ON user_settings
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_biometric_baselines_updated_at BEFORE UPDATE ON biometric_baselines
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

ALTER PUBLICATION supabase_realtime ADD TABLE emergency_alerts;
ALTER PUBLICATION supabase_realtime ADD TABLE emergency_notifications;

