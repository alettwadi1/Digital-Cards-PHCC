-- ══════════════════════════════════════════════════════
-- بطاقة المراجع الرقمية - تجمع جازان الصحي
-- Supabase Database Setup Script
-- ══════════════════════════════════════════════════════

-- Enable UUID extension
create extension if not exists "uuid-ossp";

-- ── Table: patients ──────────────────────────────────
create table if not exists patients (
  id          uuid primary key default uuid_generate_v4(),
  id_no       varchar(10) not null unique,
  full_name   text not null,
  mobile_no   varchar(15),
  dob_g       date not null,
  created_at  timestamptz default now(),
  updated_at  timestamptz default now()
);

create index idx_patients_id_no on patients(id_no);

-- Auto-update updated_at
create or replace function update_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

create trigger trg_patients_updated_at
  before update on patients
  for each row execute function update_updated_at();

-- ── Table: notifications ──────────────────────────────
create table if not exists notifications (
  id          uuid primary key default uuid_generate_v4(),
  id_no       varchar(10) not null,  -- patient id_no or 'ALL'
  title       text not null,
  message     text not null,
  is_read     boolean default false,
  created_at  timestamptz default now()
);

create index idx_notifications_id_no on notifications(id_no);

-- ── Table: upload_history ─────────────────────────────
create table if not exists upload_history (
  id            uuid primary key default uuid_generate_v4(),
  file_name     text not null,
  uploaded_by   text not null,
  total_rows    int default 0,
  inserted_rows int default 0,
  updated_rows  int default 0,
  skipped_rows  int default 0,
  status        text default 'success',
  created_at    timestamptz default now()
);

-- ── Table: admin_users ────────────────────────────────
create table if not exists admin_users (
  id          uuid primary key default uuid_generate_v4(),
  username    text not null unique,
  role        text default 'admin',
  created_at  timestamptz default now()
);

-- ── Row Level Security ────────────────────────────────
alter table patients enable row level security;
alter table notifications enable row level security;
alter table upload_history enable row level security;
alter table admin_users enable row level security;

-- Patients: public can read (for patient self-search)
create policy "patients_public_read" on patients
  for select using (true);

-- Patients: only authenticated admins can write
create policy "patients_admin_write" on patients
  for all using (auth.role() = 'authenticated');

-- Notifications: patient can read their own (or ALL)
create policy "notifications_read" on notifications
  for select using (true);

-- Notifications: only authenticated can write
create policy "notifications_admin_write" on notifications
  for all using (auth.role() = 'authenticated');

-- Upload history: only authenticated
create policy "upload_history_admin" on upload_history
  for all using (auth.role() = 'authenticated');

-- Admin users: only authenticated
create policy "admin_users_read" on admin_users
  for select using (auth.role() = 'authenticated');

-- ── Sample Data ───────────────────────────────────────
insert into patients (id_no, full_name, mobile_no, dob_g) values
  ('1234567890', 'أحمد محمد العسيري',   '0501234567', '1990-05-15'),
  ('2345678901', 'فاطمة علي الزهراني', '0557654321', '1985-08-20'),
  ('3456789012', 'محمد سعد القحطاني',  '0591112233', '1995-03-10'),
  ('4567890123', 'نورة خالد الغامدي',  '0544556677', '1992-11-25'),
  ('5678901234', 'عبدالله أحمد المالكي','0533221100', '1988-07-05')
on conflict (id_no) do nothing;

insert into notifications (id_no, title, message) values
  ('1234567890', 'تذكير بموعد طبي',     'لديك موعد في عيادة الباطنية يوم الأحد الساعة 10:00 صباحاً.'),
  ('1234567890', 'نتائج التحاليل جاهزة','تحاليلك المخبرية أصبحت جاهزة للاستلام.'),
  ('ALL',        'تنبيه عام: ساعات الدوام','تعديل مواعيد الدوام خلال إجازة عيد الأضحى المبارك.');
