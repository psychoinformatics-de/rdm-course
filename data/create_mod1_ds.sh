# Contains commands from the 1st module
# Creates (mostly) the same dataset as would be expected
# after completing the first module.

DS_NAME=my-ds

datalad create -c text2git $DS_NAME
cd $DS_NAME
echo "# Example dataset\n\nThis is an example datalad dataset.\n" >> README.md
echo ".ipynb_checkpoints/" >> .gitignore
datalad save -m "Add gitignore and a short README"

mkdir -p inputs/images
wget -O inputs/images/chinstrap_01.jpg "https://unsplash.com/photos/3Xd5j9-drDA/download?force=true"
echo "Raw data is kept in \`inputs\` folder:\n- penguin photos are in \`inputs/images\`" >> README.md
datalad save -m "Add first penguin image" inputs/images/chinstrap_01.jpg
datalad save -m "Update readme" README.md

datalad download-url -O inputs/images/chinstrap_02.jpg "https://unsplash.com/photos/8PxCm4HsPX8/download?force=true"

echo "photographer: Derek Oyen\nlicense: Unsplash License\npenguin_count: 3" > inputs/images/chinstrap_01.yaml
echo "photographer: Derek Oyen\nlicense: Unsplash License\npenguin_count: 2" > inputs/images/chinstrap_02.yaml
datalad save -m "Add sidecar metadata to photos"

echo "HAHA, content gone" > README.md
datalad save -m "Break things"
git revert --no-edit HEAD

mkdir code
mkdir -p outputs/images_greyscale
wget -O code/greyscale.py https://github.com/psychoinformatics-de/rdm-course/raw/gh-pages/data/greyscale.py
datalad save -m "Add an image processing script"

python code/greyscale.py inputs/images/chinstrap_01.jpg outputs/images_greyscale/chinstrap_01_grey.jpg
datalad save -m "Convert the first image to greyscale"

# skipping the part where an image gets overwritten

datalad run \
    --input inputs/images/chinstrap_02.jpg \
    --output outputs/images_greyscale/chinstrap_02_grey.jpg \
    -m "Convert the second image to greyscale" \
    python code/greyscale.py {inputs} {outputs}

# skipping part of exercise (adding the 3rd image)

echo "## Credit\n Chinstrap photos by [Derek Oyen](https://unsplash.com/@goosegrease) on [Unsplash](https://unsplash.com)" >> README.md
datalad save -m "Add credit to README"
