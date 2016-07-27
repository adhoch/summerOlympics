for file in /home/vega/winterOlympics/apps/processing/radialChart/data/countrySVG/*
do
	inkscape -z -e ${file}.png -w 1024 -h 768 ${file}
done
