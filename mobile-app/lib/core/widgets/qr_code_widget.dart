import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../config/app_colors.dart';

class QRCodeWidget extends StatelessWidget {
  final String data;
  final double size;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final bool showLogo;
  final Widget? logo;

  const QRCodeWidget({
    super.key,
    required this.data,
    this.size = 200,
    this.foregroundColor,
    this.backgroundColor,
    this.showLogo = false,
    this.logo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.qrBackground,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.borderLight,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          QrImageView(
            data: data,
            version: QrVersions.auto,
            size: size,
            foregroundColor: foregroundColor ?? AppColors.qrForeground,
            backgroundColor: backgroundColor ?? AppColors.qrBackground,
            embeddedImage: showLogo ? const AssetImage('assets/images/logo.png') : null,
            embeddedImageStyle: showLogo
                ? QrEmbeddedImageStyle(
                    size: Size(size * 0.2, size * 0.2),
                  )
                : null,
            errorStateBuilder: (context, error) {
              return Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: AppColors.grey100,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: AppColors.error,
                      size: 32.sp,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'خطأ في توليد QR',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          if (logo != null) ...[
            SizedBox(height: 12.h),
            logo!,
          ],
        ],
      ),
    );
  }
}

class QRCodeWithActions extends StatefulWidget {
  final String data;
  final double size;
  final String title;
  final String subtitle;
  final VoidCallback? onRefresh;
  final VoidCallback? onShare;

  const QRCodeWithActions({
    super.key,
    required this.data,
    this.size = 200,
    this.title = 'كود الحضور',
    this.subtitle = 'اعرض هذا الكود للمدرس',
    this.onRefresh,
    this.onShare,
  });

  @override
  State<QRCodeWithActions> createState() => _QRCodeWithActionsState();
}

class _QRCodeWithActionsState extends State<QRCodeWithActions>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Text(
            widget.title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimaryLight,
            ),
          ),
          
          SizedBox(height: 8.h),
          
          // Subtitle
          Text(
            widget.subtitle,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.grey600,
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: 20.h),
          
          // QR Code with Animation
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.scale(
                scale: _animation.value,
                child: Opacity(
                  opacity: _animation.value,
                  child: QRCodeWidget(
                    data: widget.data,
                    size: widget.size,
                  ),
                ),
              );
            },
          ),
          
          SizedBox(height: 20.h),
          
          // Student ID
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              'ID: ${widget.data}',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
                fontFamily: 'monospace',
              ),
            ),
          ),
          
          SizedBox(height: 20.h),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: widget.onRefresh ?? _refreshQR,
                  icon: const Icon(Icons.refresh),
                  label: const Text('تحديث'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                ),
              ),
              
              SizedBox(width: 12.w),
              
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: widget.onShare ?? _shareQR,
                  icon: const Icon(Icons.share),
                  label: const Text('مشاركة'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _refreshQR() {
    _animationController.reset();
    _animationController.forward();
  }

  void _shareQR() {
    Share.share(
      'كود الحضور: ${widget.data}\n\nأحمد سامي - سبشيال وان',
      subject: 'كود الحضور',
    );
  }
}

class QRCodeScanner extends StatelessWidget {
  final Function(String) onScanned;
  final String? title;

  const QRCodeScanner({
    super.key,
    required this.onScanned,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? 'مسح QR Code'),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.black,
        child: Stack(
          children: [
            // Camera view would go here
            Center(
              child: Container(
                width: 250.w,
                height: 250.w,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.primary,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: const Center(
                  child: Icon(
                    Icons.qr_code_scanner,
                    color: AppColors.primary,
                    size: 64,
                  ),
                ),
              ),
            ),
            
            // Instructions
            Positioned(
              bottom: 100.h,
              left: 0,
              right: 0,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 32.w),
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  'وجه الكاميرا نحو كود QR لمسحه',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

