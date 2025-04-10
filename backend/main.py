with open('universities.txt', 'r') as file:
    lines = file.readlines()
    # Remove leading/trailing whitespace
    lines = [line.strip() for line in lines]
    # Remove duplicates
    lines = list(set(lines))
    file.close()
for line in lines:
    line = line.replace('https://', '').replace('http://', '').replace('www.', '').replace('/', '')
    with open(f'{line}.py', 'w') as file:
        for line in lines:
            file.write('import requests' + '\n' + "from bs4 import BeautifulSoup")
        file.close()
"""
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
from googlesearch import search
"""