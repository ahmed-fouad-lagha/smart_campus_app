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
from googlesearch import search

from googleapiclient.discovery import build


url = "https://univ-oran1.dz/category/%D9%85%D8%B3%D8%AA%D8%AC%D8%AF%D8%A7%D8%AA/"
response = requests.get(url)
soup = BeautifulSoup(response.text, 'html.parser')
links = soup.find_all('a', href=True)
university_links = []
for link in links:
    href = link['href']
    university_links.append(href)
university_links = list(set(university_links))
university_links = [link for link in university_links if link.startswith('https://univ-oran1.dz')]
for i, link in enumerate(university_links, 1):
    with open('univ-oran1.txt', 'a') as file:
        
            file.write(f"{link}" + '\n')
            file.close()


"""

with open('univ-oran1.txt', 'r') as file:
    lines = file.readlines()
    lines = [line.strip() for line in lines]
    lines = list(set(lines))
    file.close()
for url in lines:
    try:
        response = requests.get(url)
        soup = BeautifulSoup(response.text, 'html.parser')
        links = soup.find_all('a', href=True)
        university_events= []
        for link in links:
            href = link['href']
            university_events.append(href)
        university_events = list(set(university_events))
        university_events = [link for link in university_events if link.startswith('https://univ-oran1.dz')]
        for i, link in enumerate(university_events, 1):
            with open('univ-oran1.txt', 'a') as file:
                if "category" in link and "https://univ-oran1.dz" not in link:
                    file.write(f"https://univ-oran1.dz/{link}" + '\n')
                    file.close()
    except Exception as e:
        print(f"Error processing {url}: {e}")
        continue
"""