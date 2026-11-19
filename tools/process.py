import rembg
from PIL import Image
import os

input_path = 'assets/images/piko_new.jpg'
output_path = 'assets/images/piko_new_transparent.png'
cropped_path = 'assets/images/piko_new_cropped.png'

with open(input_path, 'rb') as i:
    input_data = i.read()

output_data = rembg.remove(input_data)

with open(output_path, 'wb') as o:
    o.write(output_data)

img = Image.open(output_path)
bbox = img.getbbox()
if bbox:
    img.crop(bbox).save(cropped_path)
else:
    img.save(cropped_path)
