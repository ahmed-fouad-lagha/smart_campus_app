import sqlite3

# الاتصال بقاعدة البيانات
conn = sqlite3.connect('student_news.db')
cursor = conn.cursor()

# استعلام لجلب كل البيانات من جدول news
cursor.execute("SELECT * FROM news")
rows = cursor.fetchall()

# عرض البيانات
print("📦 محتوى جدول الأخبار (news):\n")
for row in rows:
    print(f"🆔 ID: {row[0]}")
    print(f"📌 Title: {row[1]}")
    print(f"🔗 Content: {row[2]}")
    print("-" * 40)

# غلق الاتصال
conn.close()
