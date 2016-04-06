
if [ -z "$1" ]; then file="MemPassIcon"; else file="$1"; fi

sizes=(29 40 50 57 60 72 76 83.5)
multiples=(1 2 3)
icon=MemPassIcon.png

for size in ${sizes[@]}
do
	for multi in ${multiples[@]}
	do
		filename="$file_${size}x${size}@${multi}x.png"
		dimen=$(echo "$size * $multi" | bc)	
		echo $dimen
		convert "$file.png" -resize ${dimen}x${dimen} "$filename"

	done
done

convert "$file.png" -resize 16x16 icon-bitty.png
convert "$file.png" -resize 48x48 icon-small.png
convert "$file.png" -resize 128x128 icon-large.png
