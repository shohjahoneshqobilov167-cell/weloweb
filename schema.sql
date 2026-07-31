-- ============================================
-- AURUM CYCLES — Supabase sxemasi
-- Buni Supabase loyihangizda "SQL Editor" bo'limiga
-- to'liq nusxalab, "Run" tugmasini bosing.
-- ============================================

-- 1) MAHSULOTLAR jadvali
create table if not exists products (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  tagline text,
  frame text,
  weight text,
  transmission text,
  colorway text,
  price text,
  image_url text,
  sort_order int default 0,
  created_at timestamptz default now()
);

-- 2) BUYURTMALAR jadvali
create table if not exists orders (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  phone text not null,
  model text,
  message text,
  status text default 'yangi',   -- yangi | qongiroq_qilindi | yakunlandi
  created_at timestamptz default now()
);

-- 3) Xavfsizlikni yoqish (Row Level Security)
alter table products enable row level security;
alter table orders enable row level security;

-- 4) MAHSULOTLAR: hamma o'qiy oladi (sayt ko'rsatishi uchun)
create policy "public_read_products" on products
  for select using (true);

-- 5) MAHSULOTLAR: faqat tizimga kirgan admin qo'sha/o'zgartira/o'chira oladi
create policy "admin_write_products" on products
  for all using (auth.role() = 'authenticated')
  with check (auth.role() = 'authenticated');

-- 6) BUYURTMALAR: faqat admin ko'ra oladi (mijozlarning telefon raqami himoyalanadi)
create policy "admin_read_orders" on orders
  for select using (auth.role() = 'authenticated');

create policy "admin_update_orders" on orders
  for update using (auth.role() = 'authenticated');

-- Eslatma: mijoz saytdan buyurtma yuborganda, so'rov /api/order orqali
-- "service role" kaliti bilan yoziladi — bu RLS'ni chetlab o'tadi,
-- shuning uchun mijozlar uchun alohida INSERT siyosati kerak emas.

-- 7) Boshlang'ich 6 ta mahsulotni qo'shish (xohlasangiz o'zgartiring)
insert into products (name, tagline, frame, weight, transmission, colorway, price, image_url, sort_order) values
('Corsa Nera', 'Yo''l tezligi uchun yaratilgan', 'To''liq karbon T1100', '6.1 kg', '12 tezlik, elektron', 'Ohaklangan qora / brass', '$8,900', 'images/model-corsa-nera.jpg', 1),
('Monte Titano', 'Tog'' yo''llari uchun mustahkam', 'Grade-9 titan', '9.4 kg', '140mm amortizator', 'Xom titan / burgundy', '$11,400', 'images/model-monte-titano.jpg', 2),
('Villa Randonneur', 'Uzoq safarlar uchun nafis yechim', 'Qo''lda kavsharlangan po''lat', '10.2 kg', 'Charm to''shama, mis detallar', 'Yong''oq jigar / oltin', '$7,250', 'images/model-villa-randonneur.jpg', 3),
('Fulmine Aero', 'Shamolga qarshi — aerodinamik yo''l ramasi', 'Aero-profil karbon', '6.8 kg', '12 tezlik, elektron', 'Charog''i qora / brass', '$9,600', 'images/model-fulmine-aero.jpg', 4),
('Gravello Endurance', 'Uzoq masofa va notekis yo''llar uchun', 'Karbon + titan qo''shilma', '8.3 kg', '650b, keng shina', 'Zaytun yashil / brass', '$8,150', 'images/model-gravello-endurance.jpg', 5),
('Cittá Classic', 'Shahar uchun kundalik nafislik', 'Qo''lda kavsharlangan xrom-moli', '11.5 kg', 'Charm sumka, mis qo''ng''iroq', 'Krem oq / brass', '$5,400', 'images/model-citta-classic.jpg', 6);
