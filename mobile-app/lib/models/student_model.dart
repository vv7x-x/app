import 'package:freezed_annotation/freezed_annotation.dart';

part 'student_model.freezed.dart';
part 'student_model.g.dart';

@freezed
class Student with _$Student {
  const factory Student({
    required String id,
    required String fullName,
    required String username,
    required String nationalId,
    required String studentPhone,
    required String parentPhone,
    required String stage,
    required int age,
    required String center,
    @Default('pending') String status,
    @Default('') String email,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Student;

  factory Student.fromJson(Map<String, dynamic> json) => _$StudentFromJson(json);
}

@freezed
class StudentPending with _$StudentPending {
  const factory StudentPending({
    required String id,
    required String fullName,
    required String username,
    required String nationalId,
    required String studentPhone,
    required String parentPhone,
    required String stage,
    required int age,
    required String center,
    @Default('pending') String status,
    @Default('') String email,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _StudentPending;

  factory StudentPending.fromJson(Map<String, dynamic> json) => _$StudentPendingFromJson(json);
}

// Education Stages
enum EducationStage {
  elementary('elementary', 'ابتدائي', 'Elementary'),
  middle('middle', 'إعدادي', 'Middle School'),
  high('high', 'ثانوي', 'High School'),
  university('university', 'جامعي', 'University');

  const EducationStage(this.value, this.arabicName, this.englishName);
  
  final String value;
  final String arabicName;
  final String englishName;

  static EducationStage fromString(String value) {
    return EducationStage.values.firstWhere(
      (stage) => stage.value == value,
      orElse: () => EducationStage.middle,
    );
  }
}

// Learning Centers
enum LearningCenter {
  main('main', 'المركز الرئيسي', 'Main Center'),
  university('university', 'مركز الجامعة', 'University Center'),
  residential('residential', 'مركز الأحياء السكنية', 'Residential Center'),
  downtown('downtown', 'مركز وسط البلد', 'Downtown Center'),
  suburbs('suburbs', 'مركز الضواحي', 'Suburbs Center');

  const LearningCenter(this.value, this.arabicName, this.englishName);
  
  final String value;
  final String arabicName;
  final String englishName;

  static LearningCenter fromString(String value) {
    return LearningCenter.values.firstWhere(
      (center) => center.value == value,
      orElse: () => LearningCenter.main,
    );
  }
}

// Student Status
enum StudentStatus {
  pending('pending', 'بانتظار الموافقة', 'Pending Approval'),
  approved('approved', 'موافق عليه', 'Approved'),
  rejected('rejected', 'مرفوض', 'Rejected'),
  active('active', 'نشط', 'Active'),
  inactive('inactive', 'غير نشط', 'Inactive');

  const StudentStatus(this.value, this.arabicName, this.englishName);
  
  final String value;
  final String arabicName;
  final String englishName;

  static StudentStatus fromString(String value) {
    return StudentStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => StudentStatus.pending,
    );
  }
}

