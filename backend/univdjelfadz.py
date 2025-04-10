import requests
from bs4 import BeautifulSoup
import csv
def getdata():
    # تحديد عنوان الصفحة
    url = "https://www.univ-djelfa.dz/ar/?page_id=13673"

    # إرسال طلب HTTP لجلب محتوى الصفحة
    headers = {
        "User-Agent": "Mozilla/5.0"
    }
    response = requests.get(url, headers=headers)
    soup = BeautifulSoup(response.content, 'html.parser')

    # العثور على جميع العناصر التي تحتوي على الأحداث
    events = soup.find_all('div', class_='eael-post-list-post')

    # فتح ملف CSV لكتابة البيانات
    with open('djelfa_events.csv', 'w', newline='', encoding='utf-8') as csvfile:
        fieldnames = ['title', 'link', 'date', 'image_url']
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()

        # استخراج المعلومات لكل حدث وكتابتها في ملف CSV
        for event in events:
            title_tag = event.find('h2', class_='eael-post-list-title')
            if title_tag:
                title = title_tag.get_text(strip=True)
                link = title_tag.find('a')['href'] if title_tag.find('a') else 'No link'
            else:
                title = 'No title'
                link = 'No link'

            date_tag = event.find('span')
            date = date_tag.get_text(strip=True) if date_tag else 'No date'

            image_tag = event.find('img')
            image_url = image_tag['src'] if image_tag else 'No image'

            writer.writerow({'title': title, 'link': link, 'date': date, 'image_url': image_url})

    print("تم استخراج الأحداث وحفظها في ملف djelfa_events.csv بنجاح.")
