import requests
from bs4 import BeautifulSoup
import csv
def getdata():
    # URL الصفحة التي تحتوي على الأخبار
    url = "https://www.usthb.dz/archive"

    # إرسال طلب GET إلى الصفحة
    response = requests.get(url)

    # التحقق من نجاح الطلب
    if response.status_code == 200:
        # تحليل HTML باستخدام BeautifulSoup
        soup = BeautifulSoup(response.text, 'html.parser')
        
        # العثور على جميع المقالات
        articles = soup.find_all('a', class_="hover:scale-105 duration-300 w-full rounded overflow-hidden")
        
        # فتح ملف CSV لكتابة البيانات
        with open('news_usthb.csv', 'w', newline='', encoding='utf-8') as file:
            writer = csv.writer(file)
            # كتابة رأس الجدول
            writer.writerow(['Title', 'Date', 'Description', 'Link', 'Image'])
            
            # استخراج البيانات من كل مقال
            for article in articles:
                # استخراج عنوان الخبر
                title_element = article.find('div', class_='font-bold text-lg block-ellipsis2 h-14')
                title = title_element.text.strip() if title_element else 'No title'
                
                # استخراج تاريخ الخبر
                date_element = article.find('div', class_='font-semibold inline-block p-1 rounded-full bg-blue-100 text-xs mb-2')
                date = date_element.text.strip() if date_element else 'No date'
                
                # استخراج الوصف (النص المقتطف)
                description_element = article.find('p', class_='block-ellipsis h-16 font-bold text-gray-700 text-sm dark:text-gray-300')
                description = description_element.text.strip() if description_element else 'No description'
                
                # استخراج رابط الخبر
                link = article['href'] if article.get('href') else 'No link'
                
                # استخراج رابط الصورة (إن وجد)
                image = article.find('img')['src'] if article.find('img') else 'No image'
                
                # كتابة البيانات في ملف CSV
                writer.writerow([title, date, description, link, image])
        
        print("تم حفظ الأخبار في ملف news_usthb.csv")
    else:
        print(f"فشل تحميل الصفحة. حالة الاستجابة: {response.status_code}")
