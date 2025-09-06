# تطبيق أحمد سامي - سبشيال وان

تطبيق Flutter لإدارة حضور الطلاب مع قاعدة بيانات Supabase.

## المميزات

### 🔐 نظام المصادقة
- تسجيل الدخول بالبريد الإلكتروني وكلمة المرور
- تسجيل الدخول بالاسم والرقم القومي
- تسجيل حساب جديد للطلاب
- إدارة كلمات المرور

### 👥 إدارة الطلاب
- تسجيل الطلاب الجدد
- انتظار الموافقة على الحسابات
- إدارة بيانات الطلاب
- رفع صورة الرقم القومي

### 📚 إدارة الدروس
- عرض الجدول الدراسي
- إدارة الدروس
- تتبع الحضور والغياب
- إحصائيات الحضور

### 📢 الإعلانات
- إرسال إعلانات للطلاب
- أنواع مختلفة من الإعلانات
- إرفاق ملفات

### 📱 واجهة المستخدم
- تصميم متجاوب
- دعم اللغة العربية والإنجليزية
- واجهة سهلة الاستخدام
- تصميم حديث وجذاب

## التقنيات المستخدمة

### Frontend
- **Flutter** - إطار عمل التطبيق
- **Riverpod** - إدارة الحالة
- **Go Router** - التنقل
- **ScreenUtil** - التجاوب

### Backend
- **Supabase** - قاعدة البيانات والمصادقة
- **PostgreSQL** - قاعدة البيانات
- **Row Level Security** - الأمان

### Services
- **Supabase Auth** - المصادقة
- **Supabase Database** - قاعدة البيانات
- **Firebase Messaging** - الإشعارات

## التثبيت والتشغيل

### 1. متطلبات النظام
- Flutter SDK 3.10.0 أو أحدث
- Dart SDK 3.0.0 أو أحدث
- Android Studio أو VS Code
- Git

### 2. استنساخ المشروع
```bash
git clone <repository-url>
cd mobile-app
```

### 3. تثبيت التبعيات
```bash
flutter pub get
```

### 4. إعداد قاعدة البيانات
1. اذهب إلى [Supabase Dashboard](https://supabase.com/dashboard)
2. أنشئ مشروع جديد
3. انسخ محتوى `database_schema.sql` في SQL Editor
4. شغل الكود لإنشاء الجداول

### 5. إعداد متغيرات البيئة
أنشئ ملف `.env` في مجلد `mobile-app`:
```env
SUPABASE_URL=https://zrxgvzhikiyqyhxprmwc.supabase.co
SUPABASE_ANON_KEY=your_anon_key_here
```

### 6. تشغيل التطبيق
```bash
flutter run
```

## هيكل المشروع

```
lib/
├── config/                 # إعدادات التطبيق
│   ├── app_colors.dart
│   ├── app_theme.dart
│   ├── localization.dart
│   └── supabase_config.dart
├── core/                   # الخدمات الأساسية
│   ├── services/
│   │   ├── auth_service.dart
│   │   ├── supabase_service.dart
│   │   └── notification_service.dart
│   └── widgets/            # العناصر المشتركة
├── features/               # الميزات
│   ├── auth/              # المصادقة
│   ├── dashboard/         # لوحة التحكم
│   ├── schedule/          # الجدول
│   └── announcements/     # الإعلانات
├── models/                # نماذج البيانات
├── routes/                # التنقل
└── main.dart             # نقطة البداية
```

## قاعدة البيانات

### الجداول الرئيسية

#### students
- الطلاب المُعتمدين
- يحتوي على جميع بيانات الطالب

#### students_pending
- الطلاب في انتظار الموافقة
- نفس هيكل جدول students

#### lessons
- الدروس والجداول
- يحتوي على تفاصيل كل درس

#### attendance
- سجل الحضور والغياب
- مرتبط بجدول الطلاب والدروس

#### announcements
- الإعلانات والأخبار
- يمكن ربطها بالمعلمين

## الأمان

### Row Level Security (RLS)
- الطلاب يمكنهم رؤية بياناتهم فقط
- الطلاب يمكنهم رؤية جميع الدروس والإعلانات
- الطلاب يمكنهم رؤية سجل حضورهم فقط
- أي شخص يمكنه إضافة طالب في انتظار الموافقة

### المصادقة
- استخدام Supabase Auth
- تشفير كلمات المرور
- جلسات آمنة

## التطوير

### إضافة ميزة جديدة
1. أنشئ مجلد جديد في `features/`
2. أضف النماذج في `models/`
3. أنشئ الخدمات في `core/services/`
4. أضف الصفحات في `presentation/pages/`
5. حدث التنقل في `routes/`

### إضافة جدول جديد
1. أضف الجدول في `database_schema.sql`
2. أنشئ النموذج في `models/`
3. أضف العمليات في `supabase_service.dart`
4. حدث الواجهات

## الاختبار

```bash
# تشغيل الاختبارات
flutter test

# تحليل الكود
flutter analyze

# فحص الأمان
flutter pub deps
```

## النشر

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## المساهمة

1. Fork المشروع
2. أنشئ branch جديد (`git checkout -b feature/amazing-feature`)
3. Commit التغييرات (`git commit -m 'Add amazing feature'`)
4. Push إلى Branch (`git push origin feature/amazing-feature`)
5. افتح Pull Request

## الترخيص

هذا المشروع مرخص تحت رخصة MIT - راجع ملف [LICENSE](LICENSE) للتفاصيل.

## الدعم

للحصول على المساعدة:
- افتح issue في GitHub
- تواصل مع فريق التطوير
- راجع الوثائق

## التحديثات المستقبلية

- [ ] إضافة نظام الدفع
- [ ] تحسين واجهة المستخدم
- [ ] إضافة المزيد من التقارير
- [ ] دعم المزيد من اللغات
- [ ] تطبيق ويب
- [ ] API للوصول الخارجي