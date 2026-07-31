// /api/order — mijoz forma to'ldirganda shu funksiya ishga tushadi.
// Vercel avtomatik ravishda bu faylni "https://saytingiz.vercel.app/api/order"
// manzilida ishlaydigan backend funksiyaga aylantiradi.

export default async function handler(req, res) {
  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Faqat POST so\'rov qabul qilinadi' });
  }

  const { name, phone, model, message } = req.body || {};

  if (!name || !phone) {
    return res.status(400).json({ error: 'Ism va telefon raqami majburiy' });
  }

  const SUPABASE_URL = process.env.SUPABASE_URL;
  const SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;
  const BOT_TOKEN = process.env.TELEGRAM_BOT_TOKEN;
  const CHAT_ID = process.env.TELEGRAM_ADMIN_CHAT_ID;

  if (!SUPABASE_URL || !SERVICE_KEY) {
    return res.status(500).json({ error: 'Server sozlanmagan: SUPABASE o\'zgaruvchilari yo\'q' });
  }

  try {
    // 1) Buyurtmani Supabase bazasiga yozish
    const dbRes = await fetch(`${SUPABASE_URL}/rest/v1/orders`, {
      method: 'POST',
      headers: {
        apikey: SERVICE_KEY,
        Authorization: `Bearer ${SERVICE_KEY}`,
        'Content-Type': 'application/json',
        Prefer: 'return=representation',
      },
      body: JSON.stringify([{ name, phone, model, message, status: 'yangi' }]),
    });

    if (!dbRes.ok) {
      const errText = await dbRes.text();
      console.error('Supabase xatosi:', errText);
      return res.status(500).json({ error: 'Bazaga yozishda xatolik' });
    }

    // 2) Telegram botga bildirishnoma (ixtiyoriy — token bo'lsa ishlaydi)
    if (BOT_TOKEN && CHAT_ID) {
      const text =
        `🚲 *Yangi buyurtma!*\n\n` +
        `*Ism:* ${name}\n` +
        `*Telefon:* ${phone}\n` +
        `*Model:* ${model || '-'}\n` +
        `*Xabar:* ${message || '-'}`;

      await fetch(`https://api.telegram.org/bot${BOT_TOKEN}/sendMessage`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ chat_id: CHAT_ID, text, parse_mode: 'Markdown' }),
      });
    }

    return res.status(200).json({ success: true });
  } catch (e) {
    console.error(e);
    return res.status(500).json({ error: 'Kutilmagan xatolik yuz berdi' });
  }
}
