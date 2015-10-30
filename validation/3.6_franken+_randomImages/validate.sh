#! /bin/bash
ROOT=~/source/IDP
LANG=latin_randomImages

rm -f result.txt

export LC_ALL=C

find "$ROOT/validations/images/" -type f  -name '*.tif' | sort | while read i; do
	tesseract "$i" $(basename "$i")_result -l "$LANG" nodict;
done

find "." -type f  -name '*_result.txt' | sort | while read i; do
	current=$(basename "$i" | cut -d "." -f1);
	current=${current#"0"};
	gt="$ROOT/Tacitus_Germania_1678_lat/ground truth/${current}_gt.txt";
	echo "$gt - $i";
	ocrevalutf8 accuracy "$gt" "$i" > "$i"_ocreval.txt;
done

find "." -type f -name '*_ocreval.txt' | sort | while read i; do
	sed '5q;d' "$i" >> result.txt;
done
