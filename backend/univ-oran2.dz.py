import requests
from bs4 import BeautifulSoup
import csv

# جلب محتوى الصفحة
url = "https://univ-oran1.dz/category/%D9%85%D8%B3%D8%AA%D8%AC%D8%AF%D8%A7%D8%AA/"  # الرابط المطلوب
response = requests.get(url)

# التأكد من حالة الاستجابة
if response.status_code == 200:
    # تحليل الصفحة
    soup = BeautifulSoup(response.text, 'html.parser')
    
    # العثور على جميع <div class="entry">
    entry_divs = soup.find_all('div', class_='entry')
    
    # إعداد ملف CSV لحفظ البيانات
    with open('output.csv', mode='w', newline='', encoding='utf-8') as file:
        writer = csv.writer(file)
        writer.writerow(["Paragraph", "More Link"])  # رأس العمود
        
        # استخراج البيانات من كل div
        for entry_div in entry_divs:
            # استخراج الفقرة <p> التي تحتوي على النص
            paragraph = entry_div.find('p').get_text(strip=True) if entry_div.find('p') else ''
            
            # استخراج الرابط <a> الذي يحتوي على "more-link"
            more_link = entry_div.find('a', class_='more-link')['href'] if entry_div.find('a', class_='more-link') else ''
            
            # حفظ البيانات في ملف CSV
            writer.writerow([paragraph, more_link])
    
    print("تم حفظ البيانات في ملف output.csv")
else:
    print(f"فشل تحميل الصفحة. الحالة: {response.status_code}")
