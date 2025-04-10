import sqlite3
import requests
from bs4 import BeautifulSoup

# وظيفة لفحص وجود الخبر مسبقًا
def news_exists(cursor, title):
    cursor.execute("SELECT 1 FROM news WHERE title = ?", (title,))
    return cursor.fetchone() is not None

# وظيفة لجلب الأخبار من موقع جامعة الجلفة
def fetch_djelfa_news():
    conn = sqlite3.connect('student_news.db')
    cursor = conn.cursor()

    cursor.execute('''
        CREATE TABLE IF NOT EXISTS news (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            content TEXT NOT NULL
        )
    ''')
    conn.commit()

    url = "https://www.univ-djelfa.dz/ar/?page_id=13673"
    headers = {"User-Agent": "Mozilla/5.0"}
    response = requests.get(url, headers=headers)
    soup = BeautifulSoup(response.content, 'html.parser')

    news_items = soup.find_all('div', class_='eael-post-list-post')
    added_count = 0

    for item in news_items:
        title_tag = item.find('h2', class_='eael-post-list-title')
        title = title_tag.get_text(strip=True) if title_tag else 'No title'
        link = title_tag.find('a')['href'] if title_tag and title_tag.find('a') else 'No link'

        # 🔁 تحقق هل الخبر موجود مسبقًا
        if news_exists(cursor, title):
            continue  # تخطاه إذا كان موجودًا

        cursor.execute("INSERT INTO news (title, content) VALUES (?, ?)", (title, link))
        added_count += 1

    conn.commit()
    print(f"✅ تمت إضافة {added_count} خبرًا جديدًا من موقع جامعة الجلفة.")
    conn.close()

# وظيفة لجلب الأخبار من موقع USTHB
def fetch_usthb_news():
    conn = sqlite3.connect('student_news.db')
    cursor = conn.cursor()

    cursor.execute('''
        CREATE TABLE IF NOT EXISTS news (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            content TEXT NOT NULL
        )
    ''')
    conn.commit()

    url = "https://www.usthb.dz/archive"
    response = requests.get(url)
    soup = BeautifulSoup(response.text, 'html.parser')

    articles = soup.find_all('a', class_="hover:scale-105 duration-300 w-full rounded overflow-hidden")
    added_count = 0

    for article in articles:
        title_el = article.find('div', class_='font-bold text-lg block-ellipsis2 h-14')
        title = title_el.text.strip() if title_el else "No title"

        description_element = article.find('p', class_='block-ellipsis h-16 font-bold text-gray-700 text-sm dark:text-gray-300')
        description = description_element.text.strip() if description_element else 'No description'

        link = "https://www.usthb.dz/archive" + (article.get('href') or "")

        # 🔁 تحقق هل الخبر موجود مسبقًا
        if news_exists(cursor, title):
            continue

        cursor.execute("INSERT INTO news (title, content) VALUES (?, ?)", (description, link))
        added_count += 1

    conn.commit()
    print(f"✅ تمت إضافة {added_count} خبرًا جديدًا من موقع USTHB.")
    conn.close()
