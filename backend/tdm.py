import sqlite3
from transformers import pipeline
from tqdm import tqdm
def classyfay():

    # إعداد المصنف
    classifier = pipeline("zero-shot-classification", model="facebook/bart-large-mnli", framework="pt")

    # التصنيفات المقترحة
    labels = ["Computer Science", "Biology", "Pharmacy", "Business", "Arts", "Engineering", "Medicine", "Law", "Design", "Education"]

    # الاتصال بقاعدة البيانات
    conn = sqlite3.connect("student_news.db")
    cursor = conn.cursor()

    # جلب الأخبار التي لا تحتوي على تصنيف (category فارغ أو NULL)
    cursor.execute("SELECT id, title FROM news WHERE category IS NULL OR category = ''")
    rows = cursor.fetchall()

    print(f"📦 تم العثور على {len(rows)} خبرًا غير مصنف.\n")

    # تصنيف وتحديث القاعدة
    for row in tqdm(rows):
        news_id, title = row
        text = title[:512] if title else "unknown"
        
        try:
            result = classifier(text, candidate_labels=labels)
            best_category = result['labels'][0]
            
            # تحديث الخبر بالتصنيف
            cursor.execute("UPDATE news SET category = ? WHERE id = ?", (best_category, news_id))
            conn.commit()
        except Exception as e:
            print(f"❌ خطأ عند تصنيف الخبر ID {news_id}: {e}")

    print("✅ تم تصنيف جميع الأخبار بنجاح.")
    conn.close()
