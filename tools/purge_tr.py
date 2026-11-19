import glob
import re

# Matches: isTurkish ? "Turkish text" : "English text"
pattern = re.compile(r'isTurkish\s*\?\s*(["\'])(.*?)\1\s*:\s*(["\'])(.*?)\3')
pattern2 = re.compile(r'isTr\s*\?\s*(["\'])(.*?)\1\s*:\s*(["\'])(.*?)\3')

dart_files = glob.glob('lib/**/*.dart', recursive=True)
updated_files = 0

for filepath in dart_files:
    with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
        content = f.read()

    new_content = pattern.sub(r"'\4'", content)
    new_content = pattern2.sub(r"'\4'", new_content)

    if new_content != content:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(new_content)
        updated_files += 1
        print(f"Purged Turkish from: {filepath}")

print(f"Total files converted to 100% English: {updated_files}")
