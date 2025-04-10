from requests_html import HTMLSession
import time
import random

# إنشاء جلسة
session = HTMLSession()

# الرابط الأساسي للمدونة
base_url = "https://www.univ-constantine2.dz/blog/"

# قائمة لتخزين المقالات
all_articles = []

# البدء من الصفحة الأولى
page = 1

while True:
    # إنشاء رابط الصفحة
    url = f"{base_url}page/{page}/?lang=ar"
    print(f"جاري جلب: {url}")
    
    # إرسال الطلب
    response = session.get(url)
    
    # تنفيذ JavaScript (إذا كان هناك حاجة)
    response.html.render(timeout=20)
    
    # التحقق من نجاح الطلب
    if response.status_code != 200:
        print(f"فشل في جلب الصفحة {page}, الكود: {response.status_code}")
        break

    # استخراج المقالات
    articles = response.html.find('article')

    # التوقف إذا لم تكن هناك مقالات (نهاية التصفح)
    if not articles:
        break

    for article in articles:
        title_element = article.find('h2.entry-title', first=True)
        if title_element and title_element.absolute_links:
            title = title_element.text
            link = list(title_element.absolute_links)[0]
            all_articles.append({'title': title, 'link': link})

    # زيادة رقم الصفحة
    page += 1

    # تأخير عشوائي بين الطلبات لتجنب الحظر
    time.sleep(random.uniform(1, 3))

# عرض النتائج
for i, article in enumerate(all_articles, 1):
    print(f"{i}. {article['title']} - {article['link']}")
