import pandas as pd
from datetime import datetime

# قراءة البيانات من الملف
data = pd.read_csv('news_usthb.csv')

# تحويل التاريخ إلى نوع datetime لكي يتم ترتيبه بشكل صحيح
data['Date'] = pd.to_datetime(data['Date'], format='%B %d ,%Y by\n                    Usthb')

# ترتيب البيانات حسب التاريخ بشكل تنازلي (الأحدث أولاً)
sorted_data = data.sort_values(by='Date', ascending=False)

# حفظ البيانات المرتبة في ملف جديد
sorted_data.to_csv('sorted_data.csv', index=False)

print("تم ترتيب البيانات وحفظها في ملف sorted_data.csv")
