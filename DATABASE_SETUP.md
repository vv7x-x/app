# إعداد قاعدة البيانات - Supabase

## خطوات الإعداد

### 1. إنشاء قاعدة البيانات
1. اذهب إلى [Supabase Dashboard](https://supabase.com/dashboard)
2. أنشئ مشروع جديد أو استخدم المشروع الموجود
3. اذهب إلى SQL Editor

### 2. تشغيل Schema
انسخ محتوى ملف `database_schema.sql` والصقه في SQL Editor ثم اضغط "Run"

### 3. إعداد Authentication
1. اذهب إلى Authentication > Settings
2. فعّل "Enable email confirmations" إذا كنت تريد تأكيد البريد الإلكتروني
3. في "Site URL" ضع: `http://localhost:3000` للتطوير
4. في "Redirect URLs" أضف:
   - `http://localhost:3000/**`
   - `com.yourapp.specialone://**` (للتطبيق)

### 4. إعداد Storage (اختياري)
إذا كنت تريد رفع الصور:
1. اذهب إلى Storage
2. أنشئ bucket جديد باسم "student-documents"
3. فعّل RLS policies

### 5. إعداد Environment Variables
في ملف `.env`:
```
SUPABASE_URL=https://zrxgvzhikiyqyhxprmwc.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

## الجداول المُنشأة

### 1. students
- الطلاب المُعتمدين
- يحتوي على جميع بيانات الطالب

### 2. students_pending
- الطلاب في انتظار الموافقة
- نفس هيكل جدول students

### 3. lessons
- الدروس والجداول
- يحتوي على تفاصيل كل درس

### 4. attendance
- سجل الحضور والغياب
- مرتبط بجدول الطلاب والدروس

### 5. announcements
- الإعلانات والأخبار
- يمكن ربطها بالمعلمين

## الصلاحيات (RLS Policies)

- الطلاب يمكنهم رؤية بياناتهم فقط
- الطلاب يمكنهم رؤية جميع الدروس والإعلانات
- الطلاب يمكنهم رؤية سجل حضورهم فقط
- أي شخص يمكنه إضافة طالب في انتظار الموافقة

## البيانات التجريبية

تم إدراج بيانات تجريبية لاختبار التطبيق:
- طالب واحد في انتظار الموافقة
- 3 دروس تجريبية
- 3 إعلانات تجريبية
