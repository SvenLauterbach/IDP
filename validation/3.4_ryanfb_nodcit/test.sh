LANG=lat

rm -f result.txt

find "." -type f -name '*.png' -o -name '*.tif' | sort | while read i; do
	filename=$(basename "$i" | cut -d "." -f1)
	tesseract "$i" "$filename"_ocr -l "$LANG" nodict;
	ocrevalutf8 accuracy "$filename".txt "$filename"_ocr.txt > "$filename"_eval.txt;
done

find "." -type f -name '*_eval.txt' | sort | while read i; do 
	accuracy=$(sed '5q;d' "$i");
	echo "$i" "$accuracy" >> result.txt;
done


