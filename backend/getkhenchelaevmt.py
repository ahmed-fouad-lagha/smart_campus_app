import requests
from bs4 import BeautifulSoup
import fitz  # PyMuPDF

def fetch_event_content(url):
    response = requests.get(url)
    if response.status_code != 200:
        return "Failed to access the page."

    soup = BeautifulSoup(response.text, 'html.parser')

    # ابحث عن رابط PDF إن وجد
    pdf_link_tag = soup.find('a', href=True, text=lambda t: t and t.lower().endswith('.pdf'))
    if not pdf_link_tag:
        # إذا لا يوجد PDF، نطبع الفقرة فقط
        paragraph_div = soup.find('div', class_='event-content')
        if paragraph_div:
            return paragraph_div.get_text(strip=True)
        else:
            return "No paragraph or PDF found on the page."

    # إذا وجد PDF، نحمله ونقرأ محتواه
    pdf_url = pdf_link_tag['href']
    if not pdf_url.startswith('http'):
        pdf_url = 'https://univ-khenchela.com/' + pdf_url

    pdf_response = requests.get(pdf_url)
    if pdf_response.status_code != 200:
        return "Failed to download PDF."

    with open('temp.pdf', 'wb') as f:
        f.write(pdf_response.content)

    content = ""
    try:
        with fitz.open('temp.pdf') as pdf:
            for page in pdf:
                content += page.get_text()
    except Exception as e:
        content = f"Error reading PDF: {e}"

    return content

# روابط الأحداث
urls = [
    "https://univ-khenchela.com/explore/events.php?event=3747",
    "https://univ-khenchela.com/explore/events.php?event=3745"
]

# استخراج وطباعة المحتوى
for url in urls:
    print(f"\n--- Content from {url} ---\n")
    print(fetch_event_content(url))
    print("\n" + "="*80 + "\n")
