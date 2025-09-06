import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../models/lesson_model.dart';
import '../config/app_colors.dart';

class ScheduleCard extends StatelessWidget {
  final Lesson lesson;
  final VoidCallback? onTap;
  final bool showFullDetails;

  const ScheduleCard({
    super.key,
    required this.lesson,
    this.onTap,
    this.showFullDetails = false,
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
                // Subject Icon
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: _getSubjectColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    _getSubjectIcon(),
                    color: _getSubjectColor(),
                    size: 20.sp,
                  ),
                ),
                
                SizedBox(width: 12.w),
                
                // Subject Name
                Expanded(
                  child: Text(
                    lesson.subject,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimaryLight,
                    ),
                  ),
                ),
                
                // Time
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    lesson.time,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 12.h),
            
            // Details
            Row(
              children: [
                _buildDetailItem(
                  icon: Icons.calendar_today,
                  text: _formatDate(lesson.date),
                  color: AppColors.grey600,
                ),
                
                SizedBox(width: 16.w),
                
                _buildDetailItem(
                  icon: Icons.location_on,
                  text: lesson.center,
                  color: AppColors.grey600,
                ),
              ],
            ),
            
            if (lesson.teacherName != null) ...[
              SizedBox(height: 8.h),
              _buildDetailItem(
                icon: Icons.person,
                text: 'المدرس: ${lesson.teacherName}',
                color: AppColors.grey500,
              ),
            ],
            
            if (lesson.description != null && showFullDetails) ...[
              SizedBox(height: 12.h),
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: AppColors.grey50,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  lesson.description!,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.grey600,
                    height: 1.4,
                  ),
                ),
              ),
            ],
            
            if (showFullDetails) ...[
              SizedBox(height: 12.h),
              Row(
                children: [
                  if (lesson.maxStudents != null) ...[
                    _buildStatItem(
                      icon: Icons.people,
                      text: '${lesson.currentStudents ?? 0}/${lesson.maxStudents}',
                      color: AppColors.info,
                    ),
                    SizedBox(width: 16.w),
                  ],
                  
                  _buildStatusChip(),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16.sp,
          color: color,
        ),
        SizedBox(width: 4.w),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12.sp,
              color: color,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12.sp,
            color: color,
          ),
          SizedBox(width: 4.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip() {
    final isActive = lesson.isActive;
    final color = isActive ? AppColors.success : AppColors.grey500;
    final text = isActive ? 'نشط' : 'غير نشط';
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.w,
            height: 6.w,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getSubjectColor() {
    switch (Subject.fromString(lesson.subject)) {
      case Subject.mathematics:
        return AppColors.primary;
      case Subject.physics:
        return AppColors.info;
      case Subject.chemistry:
        return AppColors.warning;
      case Subject.biology:
        return AppColors.success;
      case Subject.english:
        return AppColors.secondary;
      case Subject.arabic:
        return AppColors.error;
      default:
        return AppColors.grey500;
    }
  }

  IconData _getSubjectIcon() {
    switch (Subject.fromString(lesson.subject)) {
      case Subject.mathematics:
        return Icons.calculate;
      case Subject.physics:
        return Icons.science;
      case Subject.chemistry:
        return Icons.biotech;
      case Subject.biology:
        return Icons.eco;
      case Subject.english:
        return Icons.language;
      case Subject.arabic:
        return Icons.menu_book;
      default:
        return Icons.school;
    }
  }

  Color _getBorderColor() {
    final now = DateTime.now();
    final lessonDate = lesson.date;
    
    if (lessonDate.isBefore(now)) {
      return AppColors.grey300;
    } else if (lessonDate.day == now.day && lessonDate.month == now.month) {
      return AppColors.primary.withOpacity(0.5);
    } else {
      return AppColors.borderLight;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);
    
    if (difference.inDays == 0) {
      return 'اليوم';
    } else if (difference.inDays == 1) {
      return 'غداً';
    } else if (difference.inDays == -1) {
      return 'أمس';
    } else if (difference.inDays.abs() < 7) {
      return DateFormat('EEEE', 'ar').format(date);
    } else {
      return DateFormat('dd/MM/yyyy', 'ar').format(date);
    }
  }
}

class ScheduleList extends StatelessWidget {
  final List<Lesson> lessons;
  final Function(Lesson)? onTap;
  final bool showFullDetails;

  const ScheduleList({
    super.key,
    required this.lessons,
    this.onTap,
    this.showFullDetails = false,
  });

  @override
  Widget build(BuildContext context) {
    if (lessons.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: lessons.length,
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final lesson = lessons[index];
        return ScheduleCard(
          lesson: lesson,
          onTap: onTap != null ? () => onTap!(lesson) : null,
          showFullDetails: showFullDetails,
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
            Icons.schedule_outlined,
            size: 48.sp,
            color: AppColors.grey400,
          ),
          SizedBox(height: 16.h),
          Text(
            'لا توجد جداول',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.grey600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'ستظهر الجداول الجديدة هنا',
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

