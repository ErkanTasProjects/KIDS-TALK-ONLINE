import re
import os

with open('lib/data/curriculum_data.dart', 'r', encoding='utf-8') as f:
    text = f.read()

pattern = r'["\'](?:target|word|soundText|sentence|suggested)["\']\s*:\s*["\']([^"\']+)["\']'
matches = re.findall(pattern, text)

unique_items = set()
for m in matches:
    val = m.strip()
    if len(val) > 1 and not val.startswith('assets') and not val.startswith('#') and not val.startswith('starter_'):
        unique_items.add(val)

print(f"Total extracted items: {len(unique_items)}")

# Check which ones already exist in speech folder
speech_dir = 'assets/sounds/speech'
existing_files = set([f.lower().replace('.mp3', '') for f in os.listdir(speech_dir)])

missing = []
for item in sorted(list(unique_items)):
    clean_key = re.sub(r'[^a-zA-Z0-9\s]', '', item).strip().lower().replace(' ', '_')
    if clean_key not in existing_files:
        missing.append((item, clean_key))

print(f"Missing items count: {len(missing)}")
with open('missing_speech.txt', 'w', encoding='utf-8') as out:
    for orig, key in missing:
        out.write(f"{orig} => {key}.mp3\n")
