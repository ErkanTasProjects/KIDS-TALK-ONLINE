with open('lib/screens/lesson_screen.dart', 'rb') as f:
    raw = f.read()

# Replace any byte sequence containing KONTROL ET with CHECK ANSWER
target = "text: 'KONTROL ET".encode('utf-8')
idx = raw.find(target)
if idx != -1:
    end_idx = raw.find(b"',", idx)
    raw = raw[:idx] + b"text: 'CHECK ANSWER \xe2\xad\x90'" + raw[end_idx:]

with open('lib/screens/lesson_screen.dart', 'wb') as f:
    f.write(raw)

print("Replacement done in binary safe mode.")
