import 'package:freezed_annotation/freezed_annotation.dart';

part 'announcement_model.freezed.dart';
part 'announcement_model.g.dart';

@freezed
class Announcement with _$Announcement {
  const factory Announcement({
    required String id,
    required String title,
    required String body,
    required DateTime timestamp,
    required AnnouncementType type,
    String? attachmentUrl,
    String? attachmentType,
    String? location,
    double? latitude,
    double? longitude,
    String? teacherId,
    String? teacherName,
    @Default(false) bool isImportant,
    @Default(false) bool isRead,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Announcement;

  factory Announcement.fromJson(Map<String, dynamic> json) => _$AnnouncementFromJson(json);
}

// Announcement Types
enum AnnouncementType {
  general('general', 'عام', 'General'),
  important('important', 'مهم', 'Important'),
  exam('exam', 'امتحان', 'Exam'),
  assignment('assignment', 'واجب', 'Assignment'),
  schedule('schedule', 'جدول', 'Schedule'),
  event('event', 'فعالية', 'Event');

  const AnnouncementType(this.value, this.arabicName, this.englishName);
  
  final String value;
  final String arabicName;
  final String englishName;

  static AnnouncementType fromString(String value) {
    return AnnouncementType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => AnnouncementType.general,
    );
  }
}

// Attachment Types
enum AttachmentType {
  image('image', 'صورة', 'Image'),
  pdf('pdf', 'ملف PDF', 'PDF'),
  document('document', 'مستند', 'Document'),
  video('video', 'فيديو', 'Video'),
  audio('audio', 'صوت', 'Audio');

  const AttachmentType(this.value, this.arabicName, this.englishName);
  
  final String value;
  final String arabicName;
  final String englishName;

  static AttachmentType fromString(String value) {
    return AttachmentType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => AttachmentType.image,
    );
  }
}

