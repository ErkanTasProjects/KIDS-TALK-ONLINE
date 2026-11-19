from rembg import remove
import sys

def main():
    input_path = "assets/images/piko.jpg"
    output_path = "assets/images/piko_transparent.png"
    
    with open(input_path, 'rb') as i:
        with open(output_path, 'wb') as o:
            input_data = i.read()
            output_data = remove(input_data)
            o.write(output_data)

if __name__ == "__main__":
    main()
