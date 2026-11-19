import base64

def get_b64(path):
    with open(path, 'rb') as f:
        return 'data:image/png;base64,' + base64.b64encode(f.read()).decode('utf-8')

celebrating = get_b64('web-app/public/mascot/gigi_celebrating.png')
waving = get_b64('web-app/public/mascot/gigi_waving.png')
pointing = get_b64('web-app/public/mascot/gigi_pointing.png')
thinking = get_b64('web-app/public/mascot/gigi_thinking.png')

with open('web-app/src/data/mascotImages.js', 'w', encoding='utf-8') as f:
    f.write('export const MASCOT_IMAGES = {\n')
    f.write(f'  celebrating: "{celebrating}",\n')
    f.write(f'  waving: "{waving}",\n')
    f.write(f'  pointing: "{pointing}",\n')
    f.write(f'  thinking: "{thinking}",\n')
    f.write('};\n')

print('mascotImages.js created successfully!')

