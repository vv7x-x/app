import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../models/announcement_model.dart';
import '../config/app_colors.dart';

class AnnouncementCard extends StatelessWidget {
  final Announcement announcement;
  final VoidCallback? onTap;
  final bool showFullContent;

  const AnnouncementCard({
    super.key,
    required this.announcement,
    this.onTap,
    this.showFullContent = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: _getBorderColor(),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                // Type Badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: _getTypeColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    _getTypeText(),
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: _getTypeColor(),
                    ),
                  ),
                ),
                
                if (announcement.isImportant) ...[
                  SizedBox(width: 8.w),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.priority_high,
                          color: AppColors.error,
                          size: 12.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'مهم',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                
                const Spacer(),
                
                // Date
                Text(
                  _formatDate(announcement.timestamp),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.grey500,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 12.h),
            
            // Title
            Text(
              announcement.title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimaryLight,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            
            SizedBox(height: 8.h),
            
            // Content
            Text(
              announcement.body,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.grey600,
                height: 1.4,
              ),
              maxLines: showFullContent ? null : 3,
              overflow: showFullContent ? null : TextOverflow.ellipsis,
            ),
            
            if (announcement.attachmentUrl != null) ...[
              SizedBox(height: 12.h),
              _buildAttachment(),
            ],
            
            if (announcement.location != null) ...[
              SizedBox(height: 12.h),
              _buildLocation(),
            ],
            
            SizedBox(height: 12.h),
            
            // Footer
            Row(
              children: [
                if (announcement.teacherName != null) ...[
                  Icon(
                    Icons.person,
                    size: 16.sp,
                    color: AppColors.grey500,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    announcement.teacherName!,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.grey500,
                    ),
                  ),
                  SizedBox(width: 16.w),
                ],
                
                if (!announcement.isRead) ...[
                  Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachment() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Icon(
            _getAttachmentIcon(),
            size: 20.sp,
            color: AppColors.primary,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              'مرفق: ${_getAttachmentName()}',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.grey600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Icon(
            Icons.download,
            size: 16.sp,
            color: AppColors.grey500,
          ),
        ],
      ),
    );
  }

  Widget _buildLocation() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.info.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.location_on,
            size: 20.sp,
            color: AppColors.info,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              announcement.location!,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.info,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Icon(
            Icons.open_in_new,
            size: 16.sp,
            color: AppColors.info,
          ),
        ],
      ),
    );
  }

  Color _getTypeColor() {
    switch (announcement.type) {
      case AnnouncementType.important:
        return AppColors.error;
      case AnnouncementType.exam:
        return AppColors.warning;
      case AnnouncementType.assignment:
        return AppColors.info;
      case AnnouncementType.schedule:
        return AppColors.success;
      case AnnouncementType.event:
        return AppColors.primary;
      default:
        return AppColors.grey500;
    }
  }

  String _getTypeText() {
    switch (announcement.type) {
      case AnnouncementType.important:
        return 'مهم';
      case AnnouncementType.exam:
        return 'امتحان';
      case AnnouncementType.assignment:
        return 'واجب';
      case AnnouncementType.schedule:
        return 'جدول';
      case AnnouncementType.event:
        return 'فعالية';
      default:
        return 'عام';
    }
  }

  Color _getBorderColor() {
    if (announcement.isImportant) {
      return AppColors.error.withOpacity(0.3);
    }
    return AppColors.borderLight;
  }

  IconData _getAttachmentIcon() {
    switch (announcement.attachmentType) {
      case AttachmentType.image:
        return Icons.image;
      case AttachmentType.pdf:
        return Icons.picture_as_pdf;
      case AttachmentType.document:
        return Icons.description;
      case AttachmentType.video:
        return Icons.videocam;
      case AttachmentType.audio:
        return Icons.audiotrack;
      default:
        return Icons.attach_file;
    }
  }

  String _getAttachmentName() {
    if (announcement.attachmentUrl == null) return '';
    
    final url = announcement.attachmentUrl!;
    final fileName = url.split('/').last;
    return fileName.isNotEmpty ? fileName : 'مرفق';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return DateFormat('HH:mm').format(date);
    } else if (difference.inDays == 1) {
      return 'أمس';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} أيام';
    } else {
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }
}

class AnnouncementList extends StatelessWidget {
  final List<Announcement> announcements;
  final Function(Announcement)? onTap;
  final bool showFullContent;

  const AnnouncementList({
    super.key,
    required this.announcements,
    this.onTap,
    this.showFullContent = false,
  });

  @override
  Widget build(BuildContext context) {
    if (announcements.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: announcements.length,
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final announcement = announcements[index];
        return AnnouncementCard(
          announcement: announcement,
          onTap: onTap != null ? () => onTap!(announcement) : null,
          showFullContent: showFullContent,
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(32.w),
      child: Column(
        children: [
          Icon(
            Icons.announcement_outlined,
            size: 48.sp,
            color: AppColors.grey400,
          ),
          SizedBox(height: 16.h),
          Text(
            'لا توجد إعلانات',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.grey600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'ستظهر الإعلانات الجديدة هنا',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.grey500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

