import requests
from bs4 import BeautifulSoup

# The target URL
url = "https://eddirasa.com/ens-uni/universities-sites-algerie/"

# Send a GET request to the website
response = requests.get(url)

# Check for successful response
if response.status_code == 200:
    soup = BeautifulSoup(response.text, 'html.parser')

    # Find all anchor tags
    links = soup.find_all('a', href=True)

    # Filter university URLs
    university_urls = []
    for link in links:
        href = link['href']
        # You can adjust the condition based on observed patterns
        if href.startswith('http') and '.dz' in href:
            university_urls.append(href)

    # Remove duplicates
    university_urls = list(set(university_urls))

    # Print all found URLs
    for i, url in enumerate(university_urls, 1):
        with open('universities.txt', 'a') as file:
            file.write(url + '\n')

        

else:
    print(f"Failed to retrieve page. Status code: {response.status_code}")
