import requests
from bs4 import BeautifulSoup
import pandas as pd

# URL of the page to scrape
url = "https://univ-khenchela.com/%D8%AA%D9%83%D9%88%D9%8A%D9%86%D8%A7%D8%AA-%D9%85%D8%A7%D8%B3%D8%AA%D8%B1-43"

# Send a request to the website and get the page content
response = requests.get(url)
soup = BeautifulSoup(response.text, 'html.parser')

# Find all rows containing the data
rows = soup.find_all('div', class_='row g-brd-around g-brd-top-none g-brd-secondary-light-v2 g-font-size-16 g-py-15')

# Extract the relevant data: column 1 (field of study), column 2 (program name with link), column 3 (degree type)
data = []

for row in rows:
    field_of_study = row.find('div', class_='col-sm-4').text.strip()  # Field of study (first column)
    program_link = row.find('div', class_='col-sm-6').find('a')  # Program (second column)
    program_name = program_link.text.strip()  # Program name
    program_url = program_link['href'] if program_link else ''  # Program URL
    degree_type = row.find('div', class_='col-sm-2').text.strip()  # Degree type (third column)

    data.append([field_of_study, program_name, program_url, degree_type])

# Convert the data into a DataFrame
df = pd.DataFrame(data, columns=["Field of Study", "Program Name", "Program URL", "Degree Type"])

# Save the DataFrame to a CSV file
df.to_csv('scraped_courses.csv', index=False, encoding='utf-8-sig')

print("Data has been scraped and saved to 'scraped_courses.csv'")
