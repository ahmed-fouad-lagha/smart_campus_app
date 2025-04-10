import requests
from bs4 import BeautifulSoup
import time
import random
import re
from urllib.parse import urlparse
import os
import json
import logging
import sys


url = "https://univ-khenchela.com/explore/events.php"
response = requests.get(url)
soup = BeautifulSoup(response.text, 'html.parser')
links = soup.find_all('a', href=True)
university_links = []
for link in links:
    href = link['href']
    university_links.append(href)
university_links = list(set(university_links))
print(university_links)

for i, link in enumerate(university_links, 1):
    with open('univ-khenchela.txt', 'a') as file:
        if "events.php" in link and "https://univ-khenchela.com" not in link:
            file.write(f"https://univ-khenchela.com/{link}" + '\n')
            file.close()
