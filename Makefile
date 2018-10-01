
RESOLUTIONS=320 640 720 1280 1920 2560 audio
FFMPEG_RES_CONVERT_UNIVERSAL_FLAGS=-x264opts 'keyint=59:min-keyint=59:no-scenecut' -strict -2 -r 30000/1001
MP4BOX_TO_DASH_UNIVERSAL_FLAGS=-dash 2000 -frag 2000 -rap -frag-rap -profile live

####################################################

%.dash: %_dash.mpd
	-mkdir $@
	mv -v $(RESOLUTIONS) $@/
	mv -v $< $@/
	rm -v `echo $@ | sed 's/^\(.*\).dash$\/\1.mp4/'`
	find $@ -iname `echo $@ | sed 's/^\(.*\).dash$\/\1.mp4/'` -delete

####################################################

env.install:
	pipenv --three
	touch env.install

xmltodict.install: env.install
	pipenv install xmltodict
	touch xmltodict.install

####################################################

320:
	rm -rf 320
	mkdir 320

640:
	rm -rf 640
	mkdir 640

720:
	rm -rf 720
	mkdir 720

1280:
	rm -rf 1280
	mkdir 1280

1920:
	rm -rf 1920
	mkdir 1920

2560:
	rm -rf 2560
	mkdir 2560

audio:
	rm -rf audio
	mkdir audio

####################################################

320/%.mp4: %.mp4 320
	#perl transcode.pl $<
	ffmpeg -i $< -vf scale=320:-2 $(FFMPEG_RES_CONVERT_UNIVERSAL_FLAGS) $@ -y

640/%.mp4: %.mp4 640
	#perl transcode.pl $<
	ffmpeg -i $< -vf scale=640:-2 $(FFMPEG_RES_CONVERT_UNIVERSAL_FLAGS) $@ -y

720/%.mp4: %.mp4 720
	#perl transcode.pl $<
	ffmpeg -i $< -vf scale=720:-2 $(FFMPEG_RES_CONVERT_UNIVERSAL_FLAGS) $@ -y

1280/%.mp4: %.mp4 1280
	#perl transcode.pl $<
	ffmpeg -i $< -vf scale=1280:-2 $(FFMPEG_RES_CONVERT_UNIVERSAL_FLAGS) $@ -y

1920/%.mp4: %.mp4 1920
	#perl transcode.pl $<
	ffmpeg -i $< -vf scale=1920:-2 $(FFMPEG_RES_CONVERT_UNIVERSAL_FLAGS) $@ -y

2560/%.mp4: %.mp4 2560
	#perl transcode.pl $<
	ffmpeg -i $< -vf scale=2560:-2 $(FFMPEG_RES_CONVERT_UNIVERSAL_FLAGS) $@ -y

audio/%.mp4: %.mp4 audio
	#perl transcode.pl $<
	#ffmpeg -i $< -vf scale=320:-2 $(FFMPEG_RES_CONVERT_UNIVERSAL_FLAGS) $@ -y
	cp -v $< $@

####################################################

320/%.mpd: %.mp4 320/%.mp4
	#perl transcode.pl $<
	cd $(@D); MP4Box $(MP4BOX_TO_DASH_UNIVERSAL_FLAGS) $<\#video #; rm -v $<

640/%.mpd: %.mp4 640/%.mp4
	#perl transcode.pl $<
	cd $(@D); MP4Box $(MP4BOX_TO_DASH_UNIVERSAL_FLAGS) $<\#video #; rm -v $<

720/%.mpd: %.mp4 720/%.mp4
	#perl transcode.pl $<
	cd $(@D); MP4Box $(MP4BOX_TO_DASH_UNIVERSAL_FLAGS) $<\#video #; rm -v $<

1280/%.mpd: %.mp4 1280/%.mp4
	#perl transcode.pl $<
	cd $(@D); MP4Box $(MP4BOX_TO_DASH_UNIVERSAL_FLAGS) $<\#video #; rm -v $<

1920/%.mpd: %.mp4 1920/%.mp4
	#perl transcode.pl $<
	cd $(@D); MP4Box $(MP4BOX_TO_DASH_UNIVERSAL_FLAGS) $<\#video #; rm -v $<

2560/%.mpd: %.mp4 2560/%.mp4
	#perl transcode.pl $<
	cd $(@D); MP4Box $(MP4BOX_TO_DASH_UNIVERSAL_FLAGS) $<\#video #; rm -v $<

audio/%.mpd: %.mp4 audio/%.mp4
	#perl transcode.pl $<
	cd $(@D); MP4Box $(MP4BOX_TO_DASH_UNIVERSAL_FLAGS) $<\#audio #; rm -v $<

####################################################

%_dash.mpd: 320/%.mpd 640/%.mpd 720/%.mpd 1280/%.mpd 1920/%.mpd 2560/%.mpd audio/%.mpd
	pipenv run python combine_MPDs.py --mpd_name $@

####################################################
