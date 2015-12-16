
if [ -z "$1" ]; then file="MemPassIcon"; else file="$1"; fi

sizes=(29 40 60)
multiples=(2 3)
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

