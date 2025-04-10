import sqlite3

conn = sqlite3.connect("student_news.db")
cursor = conn.cursor()

# إضافة عمود category إن لم يكن موجودًا
cursor.execute("ALTER TABLE news ADD COLUMN category TEXT")

conn.commit()
conn.close()
