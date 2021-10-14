import argparse
from PIL import Image, ImageOps

# Specify two command line arguments
parser = argparse.ArgumentParser(description="Convert to greyscale")
parser.add_argument('input_file', help="Image to convert")
parser.add_argument('output_file', nargs='?', default=None,
                    help="Output image. Replaces input if not specified")

# Parse arguments, setting output=input if not given
args = parser.parse_args()
if args.output_file is None:
    args.output_file = args.input_file

# Convert input to greyscale
with Image.open(args.input_file) as im:
    grey = ImageOps.grayscale(im)

# Save converted image
grey.save(args.output_file)
