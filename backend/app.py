from flask import Flask, request, jsonify
import sqlite3
import chat4
import os
import threading
import time
import scrape_and_save
import tdm
app = Flask(__name__)

# قاعدة بيانات SQLite
def get_db_connection():
    conn = sqlite3.connect('student_news.db')
    conn.row_factory = sqlite3.Row
    return conn

# إعداد قاعدة البيانات عند بداية التطبيق
def init_db():
    conn = get_db_connection()
    # التأكد من وجود جدول news
    conn.execute('''
        CREATE TABLE IF NOT EXISTS news (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            content TEXT NOT NULL
        )
    ''')
    
    # التأكد من وجود جدول events
    conn.execute('''
        CREATE TABLE IF NOT EXISTS events (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            description TEXT NOT NULL
        )
    ''')
    conn.close()

# نموذج إشعارات الأخبار
def fetch_and_store_news():
    scrape_and_save.fetch_djelfa_news()
    scrape_and_save.fetch_usthb_news()
    """news_data = [
        {"title": "حدث جديد في الاقتصاد", "content": "تم إطلاق مؤتمر جديد في مجال الاقتصاد."},
        {"title": "حدث جديد في التكنولوجيا", "content": "تم اكتشاف تقنية جديدة في الذكاء الاصطناعي."}
    ]
    
    # تخزين الأخبار في قاعدة البيانات
    conn = get_db_connection()
    cursor = conn.cursor()
    
    for news in news_data:
        cursor.execute("INSERT INTO news (title, content) VALUES (?, ?)", (news["title"], news["content"]))
    
    conn.commit()
    conn.close()"""

@app.route('/process_student_data', methods=['POST'])
def process_student_data():
    data = request.get_json()
    
    # استخراج البيانات من الطلب
    name = data.get('name')
    grade = data.get('grade')
    interests = data.get('interests')

    if not name or not grade or not interests:
        return jsonify({"error": "جميع الحقول (الاسم، المعدل، الاهتمامات) مطلوبة"}), 400


    
    # استرجاع الاستجابة المعالجة
    response = chat4.suggest_specializations( grade, interests)
    
    return jsonify({"response": response})




# إضافة نقطة النهاية للحصول على آخر الأخبار
@app.route('/get_latest_news', methods=['GET'])
def get_latest_news():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM news ORDER BY id DESC LIMIT 5")
    news = cursor.fetchall()
    conn.close()

    news_list = [{"title": row["title"], "content": row["content"]} for row in news]
    
    return jsonify(news_list)



# إضافة نقطة النهاية للحصول على جميع الأحداث
@app.route('/get_all_events', methods=['GET'])
def get_all_events():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM events')
    events = cursor.fetchall()
    conn.close()

    events_list = [{"title": row["title"], "description": row["description"]} for row in events]
    
    return jsonify(events_list)
@app.route('/get_news_by_interests', methods=['POST'])
def get_news_by_interests():
    data = request.get_json()

    interests = data.get("interests")
    if not interests or not isinstance(interests, list):
        return jsonify({"error": "interests must be a non-empty list"}), 400

    conn = sqlite3.connect("student_news.db")
    cursor = conn.cursor()
    matched = []

    for interest in interests:
        cursor.execute("SELECT title, content FROM news WHERE category LIKE ?", (f"%{interest}%",))
        matched.extend(cursor.fetchall())

    conn.close()

    # تحويل النتائج إلى JSON
    results = [{"title": row[0], "content": row[1]} for row in matched]
    return jsonify(results)

# إضافة نقطة النهاية للحصول على الأخبار والأحداث معًا
@app.route('/get_all_news_and_events', methods=['GET'])
def get_all_news_and_events():
    conn = get_db_connection()
    
    # جلب الأخبار
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM news ORDER BY id DESC LIMIT 5")
    news = cursor.fetchall()
    
    # جلب الأحداث
    cursor.execute('SELECT * FROM events ORDER BY id DESC LIMIT 5')
    events = cursor.fetchall()
    
    conn.close()

    news_list = [{"title": row["title"], "content": row["content"]} for row in news]
    events_list = [{"title": row["title"], "description": row["description"]} for row in events]
    
    return jsonify({"news": news_list, "events": events_list})

def periodic_news_fetch():
    while True:
        fetch_and_store_news()
        tdm.classyfay()
        time.sleep(3600)  # كل ساعة
thread = threading.Thread(target=periodic_news_fetch)
thread.start()
# إعداد قاعدة البيانات عند بداية التطبيق
if __name__ == '__main__':
    init_db()
    app.run(debug=True)
