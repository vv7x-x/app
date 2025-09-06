import 'package:freezed_annotation/freezed_annotation.dart';

part 'lesson_model.freezed.dart';
part 'lesson_model.g.dart';

@freezed
class Lesson with _$Lesson {
  const factory Lesson({
    required String id,
    required String subject,
    required DateTime date,
    required String time,
    required String center,
    String? description,
    String? teacherId,
    String? teacherName,
    int? maxStudents,
    int? currentStudents,
    @Default(false) bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Lesson;

  factory Lesson.fromJson(Map<String, dynamic> json) => _$LessonFromJson(json);
}

@freezed
class Attendance with _$Attendance {
  const factory Attendance({
    required String id,
    required String studentId,
    required String lessonId,
    required DateTime date,
    required AttendanceStatus status,
    String? notes,
    DateTime? recordedAt,
    String? recordedBy,
  }) = _Attendance;

  factory Attendance.fromJson(Map<String, dynamic> json) => _$AttendanceFromJson(json);
}

// Attendance Status
enum AttendanceStatus {
  present('present', 'حاضر', 'Present'),
  absent('absent', 'غائب', 'Absent'),
  late('late', 'متأخر', 'Late'),
  excused('excused', 'معذور', 'Excused');

  const AttendanceStatus(this.value, this.arabicName, this.englishName);
  
  final String value;
  final String arabicName;
  final String englishName;

  static AttendanceStatus fromString(String value) {
    return AttendanceStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => AttendanceStatus.absent,
    );
  }
}

// Subjects
enum Subject {
  mathematics('mathematics', 'رياضيات', 'Mathematics'),
  physics('physics', 'فيزياء', 'Physics'),
  chemistry('chemistry', 'كيمياء', 'Chemistry'),
  biology('biology', 'أحياء', 'Biology'),
  english('english', 'إنجليزي', 'English'),
  arabic('arabic', 'عربي', 'Arabic');

  const Subject(this.value, this.arabicName, this.englishName);
  
  final String value;
  final String arabicName;
  final String englishName;

  static Subject fromString(String value) {
    return Subject.values.firstWhere(
      (subject) => subject.value == value,
      orElse: () => Subject.mathematics,
    );
  }
}

