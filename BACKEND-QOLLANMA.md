# AURUM CYCLES — Backend o'rnatish qo'llanmasi

Bu tizimda 3 qism bor:
- **index.html** — mijozlar ko'radigan sayt (mahsulotlar Supabase'dan avtomatik yuklanadi)
- **admin.html** — sizning boshqaruv panelingiz (mahsulot qo'shish, buyurtmalarni ko'rish)
- **api/order.js** — mijoz forma yuborganda ishlaydigan backend funksiya (Vercel avtomatik ishga tushiradi)

---

## 1-QADAM: Supabase loyihasini yaratish

1. [supabase.com](https://supabase.com) ga kiring → **Start your project** → GitHub orqali ro'yxatdan o'ting
2. **New project** tugmasini bosing → nom bering (masalan `aurum-cycles`) → parol o'rnating (buni eslab qoling) → **Create**
3. Loyiha tayyor bo'lguncha 1-2 daqiqa kuting

## 2-QADAM: Jadvallarni yaratish

1. Chapdagi menyudan **SQL Editor** ni oching
2. **New query** tugmasini bosing
3. Ushbu paketdagi `sql/schema.sql` faylining butun mazmunini nusxalab shu yerga joylashtiring
4. **Run** tugmasini bosing — 6 ta boshlang'ich mahsulot bilan jadvallar yaratiladi

## 3-QADAM: Admin (o'zingiz) uchun login yaratish

1. Chapdagi menyudan **Authentication → Users** ni oching
2. **Add user → Create new user** tugmasini bosing
3. O'z email va parolingizni kiriting (masalan `admin@aurum.uz`) → **Auto Confirm User** ni belgilang → yarating
4. Shu email/parol bilan `admin.html` sahifasiga kirasiz

## 4-QADAM: Kalitlarni olish

1. Chapdagi menyudan **Project Settings → API** ni oching
2. Quyidagilarni nusxalab, boshqa joyga yozib qo'ying:
   - **Project URL** (masalan `https://xxxxx.supabase.co`)
   - **anon public** kaliti
   - **service_role** kaliti (⚠️ bu MAXFIY, hech kimga bermang)

## 5-QADAM: index.html va admin.html ichiga kalitlarni qo'yish

- `index.html` faylini oching, qidiring: `SIZNING_SUPABASE_URL` va `SIZNING_SUPABASE_ANON_KEY` — ularni o'zingizning **Project URL** va **anon public** kalitingizga almashtiring
- Xuddi shunday `admin.html` faylida ham almashtiring

(Bu ikkalasi client tomonida ishlaydi, shuning uchun "anon" kalitini yozish xavfsiz — u faqat ochiq ma'lumotlarni o'qish uchun ruxsat beradi)

## 6-QADAM: Telegram bot bildirishnomasi (ixtiyoriy, lekin tavsiya etiladi)

Sizda allaqachon Telegram bot bor. Shu botdan foydalanamiz:

1. Botingizning tokenini oling (BotFather'dan)
2. O'zingizning Telegram **chat ID** raqamingizni bilish uchun Telegram'da **@userinfobot** ga yozing — u sizga ID raqamingizni yuboradi

## 7-QADAM: GitHub'ga yuklash va Vercel'da maxfiy kalitlarni sozlash

1. Ushbu paketdagi barcha fayllarni (index.html, admin.html, api/ papkasi, images/ papkasi) GitHub repo'ingizga yuklang (eski fayllarning ustidan yozilaveradi)
2. Vercel loyihangizga kiring → **Settings → Environment Variables**
3. Quyidagi 4 ta o'zgaruvchini qo'shing:

   | Nomi | Qiymati |
   |---|---|
   | `SUPABASE_URL` | Supabase Project URL |
   | `SUPABASE_SERVICE_ROLE_KEY` | Supabase service_role kaliti (maxfiy) |
   | `TELEGRAM_BOT_TOKEN` | Telegram bot tokeningiz |
   | `TELEGRAM_ADMIN_CHAT_ID` | @userinfobot bergan ID raqamingiz |

4. **Save** qiling → Vercel loyihani avtomatik qayta deploy qiladi (yoki "Redeploy" bosing)

---

## Tayyor! Endi qanday ishlaydi:

- Mijoz saytga kirsa → mahsulotlar ro'yxati Supabase'dan avtomatik yuklanadi
- Mijoz "Buyurtma qilish" formasini to'ldirsa → ma'lumot Supabase'ga saqlanadi VA sizning Telegram botingizga xabar keladi
- Siz `yourdomain.vercel.app/admin.html` manziliga kirib, login qilib:
  - Barcha buyurtmalarni ko'rasiz, telefon raqamiga bossangiz qo'ng'iroq qilinadi
  - Buyurtma holatini belgilaysiz (Yangi / Qo'ng'iroq qilindi / Yakunlandi)
  - Yangi mahsulot qo'shasiz, mavjudini tahrirlaysiz yoki o'chirasiz — o'zgarish saytda darhol ko'rinadi

## Muhim eslatma — "admin.html" ni himoyalash

`admin.html` manzili ochiq (masalan `sayt.vercel.app/admin.html`), lekin login qilmagan odam hech narsa qila olmaydi — chunki Supabase har bir yozish amalini login tekshiradi. Baribir, xohlasangiz, bu sahifa manzilini boshqalarga tarqatmang.
