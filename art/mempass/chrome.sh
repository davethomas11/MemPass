file=$1
convert "$file.png" -resize 16x16 icon-bitty.png
convert "$file.png" -resize 48x48 icon-small.png
convert "$file.png" -resize 128x128 icon-large.png
convert "$file.png" -resize 87x87 icon.png
