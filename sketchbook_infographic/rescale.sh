for i in $(ls *.png); do convert -resize 4096x2048\! $i $i; done
