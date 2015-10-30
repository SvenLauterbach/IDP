FONT_NAMES = \
             "Andale Mono" \
             "Arial Black, Regular" \
             "Arial Bold Italic" \
             "Arial Bold" \
             "Arial Italic" \
             "Comic Sans MS Bold" \
             "Comic Sans MS" \
             "Courier New Bold Italic" \
             "Courier New Bold" \
             "Courier New Italic" \
             "Courier New" \
             "Georgia Bold Italic" \
             "Georgia Bold" \
             "Georgia Italic" \
             "Times New Roman, Bold Italic" \
             "Times New Roman, Bold" \
             "Times New Roman, Italic" \
             "Times New Roman, Regular" \
             "Trebuchet MS Bold Italic" \
             "Trebuchet MS Bold" \
             "Trebuchet MS Italic" \
	     "Trebuchet MS" \
             "Verdana Bold Italic" \
             "Verdana Bold" \
             "Verdana Italic"
CHARSPACING = 1.0
FONT_NAME = lat2

.SUFFIXES: .txt -dawg

all: lat.traineddata

lat.traineddata: features mftraining $(FONT_NAME).normproto
	combine_tessdata $(FONT_NAME).

images: training_text.txt
	for i in $(FONT_NAMES); do \
		n=`echo $$i | sed 's/ //g'` ; \
		for e in -3 -2 -1 0 1 2 3 ; do \
			text2image --exposure $$e --char_spacing $(CHARSPACING) \
			           --fonts_dir /usr/share/fonts/truetype/msttcorefonts/ \
				   --text training_text.txt --degrade_image=true \
			           --outputbase $(FONT_NAME).$$n.exp$$e --font "$$i" ; \
		done ; \
	done
	touch $@

# .tr files
features: images
	for i in *tif; do b=`basename $$i .tif`; tesseract $$i $$b box.train; done
	touch $@

# unicharset to pass to mftraining
$(FONT_NAME).earlyunicharset: images
	unicharset_extractor *box
	set_unicharset_properties -U unicharset -O $@ --script_dir .
	rm unicharset

# cntraining
$(FONT_NAME).normproto: features
	cntraining $(FONT_NAME)*tr
	mv normproto $@

# mftraining
mftraining: $(FONT_NAME).earlyunicharset features font_properties
	echo "mftrainign starting..."
	mftraining -F font_properties -U $(FONT_NAME).earlyunicharset -O $(FONT_NAME).unicharset lat*tr
	echo "finished"
	for i in inttemp pffmtable shapetable; do mv $$i $(FONT_NAME).$$i; done
	touch mftraining

install: lat.traineddata
	cp $(FONT_NAME).traineddata ../../../tessdata

clean:
	rm -f images features mftraining *tif *box *tr *dawg $(FONT_NAME).*txt
	rm -f $(FONT_NAME).inttemp $(FONT_NAME).normproto $(FONT_NAME).pffmtable $(FONT_NAME).shapetable $(FONT_NAME).unicharset $(FONT_NAME).earlyunicharset

cleanfonts:
	rm -f fonts *otf
