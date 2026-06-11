# بطاقة المراجع الرقمية — تجمع جازان الصحي

## 🏥 نظرة عامة

نظام بطاقة المراجع الرقمية هو تطبيق ويب متكامل يتيح للمرضى الوصول إلى بطاقتهم الصحية الرقمية، ويوفر للمدراء لوحة تحكم شاملة لإدارة المرضى والإشعارات ورفع البيانات.

---

## 📁 هيكل الملفات

```
digital-health-card/
├── index.html          ← التطبيق الكامل (مريض + إدارة)
├── supabase_setup.sql  ← سكريبت قاعدة البيانات
└── README.md           ← هذا الملف
```

---

## 🚀 خطوات الإعداد

### 1. إنشاء مشروع Supabase

1. اذهب إلى [supabase.com](https://supabase.com) وأنشئ مشروعاً جديداً
2. انتقل إلى **SQL Editor** وشغّل محتوى `supabase_setup.sql`
3. انسخ **Project URL** و **anon public key** من إعدادات المشروع

### 2. ربط التطبيق

في `index.html`، غيّر الإعدادات التالية:

```javascript
const SUPABASE_URL = 'https://YOUR_PROJECT.supabase.co';
const SUPABASE_ANON_KEY = 'YOUR_ANON_KEY';
const DEMO_MODE = false;  // غيّر إلى false بعد الربط
```

### 3. إعداد المصادقة (اختياري)

في Supabase Dashboard:
- Authentication → Users → أضف مستخدمي الإدارة
- أو استخدم Supabase Auth مع Email/Password

---

## 👤 تطبيق المراجع

### كيفية الاستخدام:
1. أدخل **رقم الهوية الوطنية** (10 أرقام)
2. أدخل **تاريخ الميلاد**
3. اضغط **بحث**
4. عرض البطاقة الرقمية مع QR Code وBarcode
5. إضافة البطاقة إلى Apple/Google Wallet

---

## 🔐 بوابة الإدارة

### الوصول:
- اضغط زر **الإدارة** في الشريط العلوي
- بيانات الدخول التجريبية: `admin` / `admin123`

### الصفحات:
| الصفحة | الوظيفة |
|--------|---------|
| لوحة التحكم | إحصاءات عامة |
| المرضى | عرض، إضافة، حذف، تصدير |
| الإشعارات | إرسال للفرد أو الجميع |
| رفع بيانات | رفع Excel من Microsoft Access |
| سجل الرفع | تاريخ جميع عمليات الرفع |

---

## 📊 أعمدة ملف Excel المطلوبة

```
ID_No       رقم الهوية الوطنية (10 أرقام)
Full_Name   الاسم الكامل
Mobile_no   رقم الجوال
DOB_G       تاريخ الميلاد (YYYY-MM-DD)
```

---

## 🛠 التقنيات المستخدمة

- **Frontend**: HTML5 + CSS3 (Vanilla)
- **Database**: Supabase (PostgreSQL)
- **Auth**: Supabase Authentication
- **Libraries**:
  - `@supabase/supabase-js` — قاعدة البيانات
  - `qrcode` — توليد QR Code
  - `jsbarcode` — توليد Barcode
  - `xlsx` — قراءة وكتابة Excel
- **Font**: IBM Plex Sans Arabic

---

## 🌐 النشر على Vercel

```bash
# تثبيت Vercel CLI
npm i -g vercel

# رفع المشروع
vercel --prod
```

أو ارفع مباشرة من GitHub عبر [vercel.com/new](https://vercel.com/new)

---

## 🔒 الأمان

- التحقق من رقم الهوية وتاريخ الميلاد معاً قبل عرض أي بيانات
- Row Level Security على جميع جداول Supabase
- JWT Authentication للوصول الإداري
- تشفير البيانات في Transit (HTTPS)

---

## 📱 PWA

لتفعيل PWA، أضف `manifest.json` و `service-worker.js`:

```json
{
  "name": "بطاقة المراجع الرقمية",
  "short_name": "JHC Card",
  "start_url": "/",
  "display": "standalone",
  "background_color": "#0D4B8F",
  "theme_color": "#0D4B8F",
  "icons": [{ "src": "/icon-192.png", "sizes": "192x192" }]
}
```

---

*تجمع جازان الصحي — نظام البطاقات الرقمية v1.0*
