import pandas as pd
from deep_translator import GoogleTranslator
import time

# Load the CSV file
df = pd.read_csv('sorted_data.csv')  # Replace with your file name

# Check if 'Description' column exists
if 'Description' not in df.columns:
    raise ValueError("The column 'Description' was not found in the CSV file.")

# Translate each row in 'Description' column
translated = []
for text in df['Description']:
    try:
        # Translate only non-empty text
        if pd.notna(text):
            translation = GoogleTranslator(source='auto', target='en').translate(text)
            print(f"Translating: {text} -> {translation}")
        else:
            translation = ''
    except Exception as e:
        print(f"Error translating: {text}\n{e}")
        translation = ''
    
    translated.append(translation)
    
    # Optional: wait to avoid rate-limiting
    time.sleep(1)

# Add the translated column to the dataframe
df['Description_EN'] = translated

# Save to new CSV
df.to_csv('translated_descriptions.csv', index=False)

print("✅ Translation complete. Saved as 'translated_descriptions.csv'.")
