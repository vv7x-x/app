-- Database Schema for Special One Student App
-- Run this SQL in your Supabase SQL Editor

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create custom types
CREATE TYPE student_status AS ENUM ('pending', 'approved', 'rejected', 'active', 'inactive');
CREATE TYPE education_stage AS ENUM ('elementary', 'middle', 'high', 'university');
CREATE TYPE attendance_status AS ENUM ('present', 'absent', 'late', 'excused');
CREATE TYPE announcement_type AS ENUM ('general', 'important', 'exam', 'assignment', 'schedule', 'event');
CREATE TYPE attachment_type AS ENUM ('image', 'pdf', 'document', 'video', 'audio');

-- Students table (approved students)
CREATE TABLE students (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    full_name VARCHAR(255) NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    national_id VARCHAR(20) UNIQUE NOT NULL,
    student_phone VARCHAR(20) NOT NULL,
    parent_phone VARCHAR(20) NOT NULL,
    stage education_stage NOT NULL,
    age INTEGER NOT NULL CHECK (age >= 10 AND age <= 50),
    center VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    status student_status DEFAULT 'pending',
    national_id_image_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Students pending table (waiting for approval)
CREATE TABLE students_pending (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    full_name VARCHAR(255) NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    national_id VARCHAR(20) UNIQUE NOT NULL,
    student_phone VARCHAR(20) NOT NULL,
    parent_phone VARCHAR(20) NOT NULL,
    stage education_stage NOT NULL,
    age INTEGER NOT NULL CHECK (age >= 10 AND age <= 50),
    center VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    status student_status DEFAULT 'pending',
    national_id_image_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Lessons table
CREATE TABLE lessons (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    subject VARCHAR(100) NOT NULL,
    lesson_date DATE NOT NULL,
    lesson_time TIME NOT NULL,
    center VARCHAR(100) NOT NULL,
    description TEXT,
    teacher_id UUID,
    teacher_name VARCHAR(255),
    max_students INTEGER DEFAULT 30,
    current_students INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Attendance table
CREATE TABLE attendance (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    student_id UUID NOT NULL REFERENCES students(id) ON DELETE CASCADE,
    lesson_id UUID NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
    attendance_date DATE NOT NULL,
    status attendance_status NOT NULL,
    notes TEXT,
    recorded_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    recorded_by UUID
);

-- Announcements table
CREATE TABLE announcements (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(255) NOT NULL,
    body TEXT NOT NULL,
    announcement_type announcement_type DEFAULT 'general',
    attachment_url TEXT,
    attachment_type attachment_type,
    location VARCHAR(255),
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    teacher_id UUID,
    teacher_name VARCHAR(255),
    is_important BOOLEAN DEFAULT false,
    is_read BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX idx_students_username ON students(username);
CREATE INDEX idx_students_national_id ON students(national_id);
CREATE INDEX idx_students_email ON students(email);
CREATE INDEX idx_students_status ON students(status);
CREATE INDEX idx_students_center ON students(center);

CREATE INDEX idx_students_pending_username ON students_pending(username);
CREATE INDEX idx_students_pending_national_id ON students_pending(national_id);
CREATE INDEX idx_students_pending_email ON students_pending(email);
CREATE INDEX idx_students_pending_status ON students_pending(status);

CREATE INDEX idx_lessons_date ON lessons(lesson_date);
CREATE INDEX idx_lessons_center ON lessons(center);
CREATE INDEX idx_lessons_subject ON lessons(subject);
CREATE INDEX idx_lessons_teacher ON lessons(teacher_id);

CREATE INDEX idx_attendance_student ON attendance(student_id);
CREATE INDEX idx_attendance_lesson ON attendance(lesson_id);
CREATE INDEX idx_attendance_date ON attendance(attendance_date);
CREATE INDEX idx_attendance_status ON attendance(status);

CREATE INDEX idx_announcements_type ON announcements(announcement_type);
CREATE INDEX idx_announcements_teacher ON announcements(teacher_id);
CREATE INDEX idx_announcements_important ON announcements(is_important);
CREATE INDEX idx_announcements_created_at ON announcements(created_at);

-- Create updated_at trigger function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for updated_at
CREATE TRIGGER update_students_updated_at BEFORE UPDATE ON students
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_students_pending_updated_at BEFORE UPDATE ON students_pending
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_lessons_updated_at BEFORE UPDATE ON lessons
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_announcements_updated_at BEFORE UPDATE ON announcements
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Row Level Security (RLS) policies
ALTER TABLE students ENABLE ROW LEVEL SECURITY;
ALTER TABLE students_pending ENABLE ROW LEVEL SECURITY;
ALTER TABLE lessons ENABLE ROW LEVEL SECURITY;
ALTER TABLE attendance ENABLE ROW LEVEL SECURITY;
ALTER TABLE announcements ENABLE ROW LEVEL SECURITY;

-- Students can only see their own data
CREATE POLICY "Students can view own data" ON students
    FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Students can update own data" ON students
    FOR UPDATE USING (auth.uid() = id);

-- Students pending policies
CREATE POLICY "Anyone can insert pending students" ON students_pending
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Students can view own pending data" ON students_pending
    FOR SELECT USING (auth.uid() = id);

-- Lessons policies - students can view all lessons
CREATE POLICY "Students can view lessons" ON lessons
    FOR SELECT USING (true);

-- Attendance policies - students can view their own attendance
CREATE POLICY "Students can view own attendance" ON attendance
    FOR SELECT USING (auth.uid() = student_id);

-- Announcements policies - students can view all announcements
CREATE POLICY "Students can view announcements" ON announcements
    FOR SELECT USING (true);

-- Insert sample data
INSERT INTO students_pending (
    id, full_name, username, national_id, student_phone, parent_phone, 
    stage, age, center, email, status
) VALUES (
    '00000000-0000-0000-0000-000000000001',
    'أحمد محمد علي',
    'ahmed_mohamed',
    '12345678901234',
    '01234567890',
    '01234567891',
    'high',
    17,
    'سنتر النجاح',
    'ahmed@example.com',
    'pending'
);

INSERT INTO lessons (
    subject, lesson_date, lesson_time, center, description, 
    teacher_name, max_students, is_active
) VALUES 
('رياضيات', '2024-01-15', '10:00:00', 'سنتر النجاح', 'درس الجبر والهندسة', 'أستاذ محمد', 30, true),
('فيزياء', '2024-01-15', '12:00:00', 'سنتر النجاح', 'درس الميكانيكا', 'أستاذ أحمد', 25, true),
('كيمياء', '2024-01-16', '09:00:00', 'سنتر النجاح', 'درس التفاعلات الكيميائية', 'أستاذ فاطمة', 20, true);

INSERT INTO announcements (
    title, body, announcement_type, teacher_name, is_important
) VALUES 
('مرحباً بالطلاب الجدد', 'نرحب بجميع الطلاب الجدد في مركز النجاح. نتمنى لكم عاماً دراسياً موفقاً.', 'general', 'إدارة المركز', true),
('جدول الامتحانات', 'سيتم إعلان جدول الامتحانات الشهرية خلال الأسبوع القادم.', 'exam', 'إدارة المركز', false),
('فعالية علمية', 'سيتم تنظيم فعالية علمية يوم الجمعة القادم في المركز الرئيسي.', 'event', 'إدارة المركز', false);
