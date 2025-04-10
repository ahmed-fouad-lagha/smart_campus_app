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
from datetime import datetime
from tqdm import tqdm
url = "https://www.univ-eloued.dz/"
response = requests.get(url)
soup = BeautifulSoup(response.text, 'html.parser')
links = soup.find_all('a', href=True)
university_links = []
for link in links:
    href = link['href']
    if 'univ-eloued.dz' in href:
        university_links.append(href)
university_links = list(set(university_links))
for i, link in enumerate(university_links, 1):
    with open('univ-eloued.txt', 'a') as file:
        if "ar/" in link:
            file.write(link + '\n')
            file.close()

with open('univ-eloued.txt', 'r') as file:
    lines = file.readlines()
    lines = [line.strip() for line in lines]
    lines = list(set(lines))
    file.close()
for url in lines:
    soup = BeautifulSoup(response.text, 'html.parser')
    links = soup.find_all('a', href=True)
    university_events= []
    for link in links:
        href = link['h1']
        university_events.append(href)
        
        

