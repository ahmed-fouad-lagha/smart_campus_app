from deep_translator import GoogleTranslator

original_text = "مرحبا بك، كيف حالك؟"

translated_text = GoogleTranslator(source='auto', target='en').translate(original_text)

print("Translated text:", translated_text)
