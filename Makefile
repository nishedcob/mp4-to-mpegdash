
RESOLUTIONS=320 640 720 1280 1920 2560 audio
FFMPEG_RES_CONVERT_UNIVERSAL_FLAGS=-x264opts 'keyint=59:min-keyint=59:no-scenecut' -strict -2 -r 30000/1001
MP4BOX_TO_DASH_UNIVERSAL_FLAGS=-dash 2000 -frag 2000 -rap -frag-rap -profile live

####################################################

%.dash: %_dash.mpd
	rm -rdvf $@
	-mkdir $@
	cp -vr $(RESOLUTIONS) $@/
	cp -v $< $@/

####################################################

env.install:
	pipenv --three
	touch env.install

dependencies.install: env.install
	pipenv install
	touch dependencies.install

xmltodict.install: dependencies.install
	pipenv install xmltodict
	touch xmltodict.install

####################################################

320:
	rm -rdvf $@
	mkdir $@

640:
	rm -rdvf $@
	mkdir $@

720:
	rm -rdvf $@
	mkdir $@

1280:
	rm -rdvf $@
	mkdir $@

1920:
	rm -rdvf $@
	mkdir $@

2560:
	rm -rdvf $@
	mkdir $@

audio:
	rm -rdvf $@
	mkdir $@

####################################################

320/%.mp4: %.mp4 320
	rm -rfdv $@
	ffmpeg -i $< -vf scale=320:-2 $(FFMPEG_RES_CONVERT_UNIVERSAL_FLAGS) $@ -y

640/%.mp4: %.mp4 640
	rm -rfdv $@
	ffmpeg -i $< -vf scale=640:-2 $(FFMPEG_RES_CONVERT_UNIVERSAL_FLAGS) $@ -y

720/%.mp4: %.mp4 720
	rm -rfdv $@
	ffmpeg -i $< -vf scale=720:-2 $(FFMPEG_RES_CONVERT_UNIVERSAL_FLAGS) $@ -y

1280/%.mp4: %.mp4 1280
	rm -rfdv $@
	ffmpeg -i $< -vf scale=1280:-2 $(FFMPEG_RES_CONVERT_UNIVERSAL_FLAGS) $@ -y

1920/%.mp4: %.mp4 1920
	rm -rfdv $@
	ffmpeg -i $< -vf scale=1920:-2 $(FFMPEG_RES_CONVERT_UNIVERSAL_FLAGS) $@ -y

2560/%.mp4: %.mp4 2560
	rm -rfdv $@
	ffmpeg -i $< -vf scale=2560:-2 $(FFMPEG_RES_CONVERT_UNIVERSAL_FLAGS) $@ -y

audio/%.mp4: %.mp4 audio
	rm -rfdv $@
	cp -v $< $@

####################################################

320/%.mpd: %.mp4 320/%.mp4
	rm -rdvf $@
	cd $(@D); MP4Box $(MP4BOX_TO_DASH_UNIVERSAL_FLAGS) $<\#video
	touch -r $(@D)/$< $@
	touch -r $(@D)/$< $(@D)

640/%.mpd: %.mp4 640/%.mp4
	rm -rdvf $@
	cd $(@D); MP4Box $(MP4BOX_TO_DASH_UNIVERSAL_FLAGS) $<\#video
	touch -r $(@D)/$< $@
	touch -r $(@D)/$< $(@D)

720/%.mpd: %.mp4 720/%.mp4
	rm -rdvf $@
	cd $(@D); MP4Box $(MP4BOX_TO_DASH_UNIVERSAL_FLAGS) $<\#video
	touch -r $(@D)/$< $@
	touch -r $(@D)/$< $(@D)

1280/%.mpd: %.mp4 1280/%.mp4
	rm -rdvf $@
	cd $(@D); MP4Box $(MP4BOX_TO_DASH_UNIVERSAL_FLAGS) $<\#video
	touch -r $(@D)/$< $@
	touch -r $(@D)/$< $(@D)

1920/%.mpd: %.mp4 1920/%.mp4
	rm -rdvf $@
	cd $(@D); MP4Box $(MP4BOX_TO_DASH_UNIVERSAL_FLAGS) $<\#video
	touch -r $(@D)/$< $@
	touch -r $(@D)/$< $(@D)

2560/%.mpd: %.mp4 2560/%.mp4
	rm -rdvf $@
	cd $(@D); MP4Box $(MP4BOX_TO_DASH_UNIVERSAL_FLAGS) $<\#video
	touch -r $(@D)/$< $@
	touch -r $(@D)/$< $(@D)

audio/%.mpd: %.mp4 audio/%.mp4
	rm -rdvf $@
	cd $(@D); MP4Box $(MP4BOX_TO_DASH_UNIVERSAL_FLAGS) $<\#audio
	touch -r $(@D)/$< $@
	touch -r $(@D)/$< $(@D)

####################################################

%_dash.mpd: xmltodict.install 320/%.mpd 640/%.mpd 720/%.mpd 1280/%.mpd 1920/%.mpd 2560/%.mpd audio/%.mpd
	rm -rdvf $@
	pipenv run python combine_MPDs.py --mpd_name $@

####################################################
