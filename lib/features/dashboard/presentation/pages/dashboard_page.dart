import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/localization.dart';
import '../../../../core/widgets/loading_button.dart';
import '../../../../core/widgets/logo_widget.dart';
import '../../../../core/widgets/qr_code_widget.dart';
import '../../../../core/widgets/statistics_card.dart';
import '../../../../core/widgets/announcement_card.dart';
import '../../../../core/widgets/schedule_card.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../../../features/schedule/presentation/providers/schedule_provider.dart';
import '../../../../features/announcements/presentation/providers/announcement_provider.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  @override
  void initState() {
    super.initState();
    // Load data when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(scheduleProvider.notifier).loadSchedules();
      ref.read(announcementProvider.notifier).loadAnnouncements();
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    final studentAsync = ref.watch(currentStudentProvider);
    final schedulesAsync = ref.watch(scheduleProvider);
    final announcementsAsync = ref.watch(announcementProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.translate('dashboard', locale)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.goToAnnouncements(),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.goToSettings(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            ref.read(scheduleProvider.notifier).loadSchedules(),
            ref.read(announcementProvider.notifier).loadAnnouncements(),
          ]);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              studentAsync.when(
                data: (student) => _buildWelcomeSection(student, locale),
                loading: () => _buildWelcomeLoading(),
                error: (_, __) => _buildWelcomeError(locale),
              ),
              
              SizedBox(height: 24.h),
              
              // Statistics Cards
              _buildStatisticsSection(locale),
              
              SizedBox(height: 24.h),
              
              // QR Code Section
              _buildQRCodeSection(locale),
              
              SizedBox(height: 24.h),
              
              // Recent Schedules
              _buildRecentSchedulesSection(schedulesAsync, locale),
              
              SizedBox(height: 24.h),
              
              // Recent Announcements
              _buildRecentAnnouncementsSection(announcementsAsync, locale),
              
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(locale),
    );
  }

  Widget _buildWelcomeSection(dynamic student, Locale locale) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const LogoIconWidget(
                size: 40,
                color: Colors.white,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${AppLocalizations.translate('welcome', locale)} ${student?.fullName ?? 'طالب'}',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${student?.stage ?? 'غير محدد'} | ${student?.center ?? 'غير محدد'}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.schedule,
                  color: Colors.white,
                  size: 16.sp,
                ),
                SizedBox(width: 6.w),
                Text(
                  'آخر تحديث: ${_getCurrentTime()}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeLoading() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: AppColors.grey300,
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 20.h,
                  width: 150.w,
                  decoration: BoxDecoration(
                    color: AppColors.grey300,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  height: 16.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                    color: AppColors.grey300,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeError(Locale locale) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: AppColors.error,
            size: 24.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'خطأ في تحميل بيانات الطالب',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsSection(Locale locale) {
    return Row(
      children: [
        Expanded(
          child: StatisticsCard(
            title: 'الجداول',
            value: '5',
            icon: Icons.schedule,
            color: AppColors.primary,
            onTap: () => context.goToSchedule(),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: StatisticsCard(
            title: 'الإعلانات',
            value: '3',
            icon: Icons.announcement,
            color: AppColors.success,
            onTap: () => context.goToAnnouncements(),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: StatisticsCard(
            title: 'الحضور',
            value: '95%',
            icon: Icons.check_circle,
            color: AppColors.warning,
            onTap: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildQRCodeSection(Locale locale) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.qr_code,
                color: AppColors.primary,
                size: 24.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                AppLocalizations.translate('attendance_qr', locale),
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Center(
            child: QRCodeWidget(
              data: 'STUDENT_ID_12345',
              size: 200.w,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            AppLocalizations.translate('show_to_teacher', locale),
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.grey600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Implement refresh QR
                  },
                  icon: const Icon(Icons.refresh),
                  label: Text(AppLocalizations.translate('refresh_qr', locale)),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Implement share QR
                    Share.share('كود الحضور: STUDENT_ID_12345');
                  },
                  icon: const Icon(Icons.share),
                  label: Text(AppLocalizations.translate('download_qr', locale)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSchedulesSection(AsyncValue schedulesAsync, Locale locale) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.translate('lesson_schedule', locale),
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => context.goToSchedule(),
              child: Text('عرض الكل'),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        schedulesAsync.when(
          data: (schedules) {
            if (schedules.isEmpty) {
              return _buildEmptyState(
                icon: Icons.schedule,
                title: AppLocalizations.translate('no_schedule', locale),
                subtitle: 'لا توجد جداول متاحة حالياً',
              );
            }
            return Column(
              children: schedules.take(3).map((schedule) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: ScheduleCard(schedule: schedule),
                );
              }).toList(),
            );
          },
          loading: () => _buildLoadingCards(),
          error: (_, __) => _buildErrorState('خطأ في تحميل الجداول'),
        ),
      ],
    );
  }

  Widget _buildRecentAnnouncementsSection(AsyncValue announcementsAsync, Locale locale) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.translate('announcements', locale),
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => context.goToAnnouncements(),
              child: Text('عرض الكل'),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        announcementsAsync.when(
          data: (announcements) {
            if (announcements.isEmpty) {
              return _buildEmptyState(
                icon: Icons.announcement,
                title: AppLocalizations.translate('no_announcements', locale),
                subtitle: 'لا توجد إعلانات جديدة',
              );
            }
            return Column(
              children: announcements.take(2).map((announcement) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: AnnouncementCard(announcement: announcement),
                );
              }).toList(),
            );
          },
          loading: () => _buildLoadingCards(),
          error: (_, __) => _buildErrorState('خطأ في تحميل الإعلانات'),
        ),
      ],
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: EdgeInsets.all(32.w),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 48.sp,
            color: AppColors.grey400,
          ),
          SizedBox(height: 16.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.grey600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            subtitle,
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

  Widget _buildLoadingCards() {
    return Column(
      children: List.generate(2, (index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: Container(
            height: 80.h,
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildErrorState(String message) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: AppColors.error,
            size: 20.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(Locale locale) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 0,
      onTap: (index) {
        switch (index) {
          case 0:
            // Already on dashboard
            break;
          case 1:
            context.goToSchedule();
            break;
          case 2:
            context.goToAnnouncements();
            break;
          case 3:
            context.goToTeacherNews();
            break;
          case 4:
            context.goToSettings();
            break;
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.dashboard),
          label: AppLocalizations.translate('dashboard', locale),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.schedule),
          label: AppLocalizations.translate('schedule', locale),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.announcement),
          label: AppLocalizations.translate('announcements', locale),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.newspaper),
          label: AppLocalizations.translate('teacher_news', locale),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.settings),
          label: AppLocalizations.translate('settings', locale),
        ),
      ],
    );
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }
}

