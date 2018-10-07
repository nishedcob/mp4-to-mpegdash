
RESOLUTIONS=320 640 720 1280 1920 2560 audio
FFMPEG_RES_CONVERT_UNIVERSAL_FLAGS=-x264opts 'keyint=59:min-keyint=59:no-scenecut' -strict -2 -r 30000/1001
MP4BOX_TO_DASH_UNIVERSAL_FLAGS=-dash 2000 -frag 2000 -rap -frag-rap -profile live
REMOVE=rm -rdvf
MKDIR=mkdir -pv
TOUCH=touch
TOUCH_R=$(TOUCH) -r
COPY=cp -v
COPY_R=$(COPY) -r
FFMPEG=ffmpeg -i
PIPENV=pipenv
PIPENV_INSTALL=$(PIPENV) install
PIPENV_RUN=$(PIPENV) run
COMBINE_MPDS=python combine_MPDs.py --mpd_name

####################################################

%.dash: %_dash.mpd ../dest
	$(REMOVE) $@
	$(MKDIR) $@
	$(COPY_R) $(RESOLUTIONS) $@/
	$(COPY) $< $@/
	$(COPY_R) $@ ../dest/

####################################################

env.install:
	$(PIPENV) --three
	$(TOUCH) $@

dependencies.install: env.install
	$(PIPENV_INSTALL)
	$(TOUCH) $@

xmltodict.install: dependencies.install
	$(PIPENV_INSTALL) xmltodict
	$(TOUCH) $@

####################################################

320:
	$(REMOVE) $@
	$(MKDIR) $@

640:
	$(REMOVE) $@
	$(MKDIR) $@

720:
	$(REMOVE) $@
	$(MKDIR) $@

1280:
	$(REMOVE) $@
	$(MKDIR) $@

1920:
	$(REMOVE) $@
	$(MKDIR) $@

2560:
	$(REMOVE) $@
	$(MKDIR) $@

audio:
	$(REMOVE) $@
	$(MKDIR) $@

../dest:
	$(REMOVE) $@
	$(MKDIR) $@

####################################################

320/%.mp4: %.mp4 320
	$(REMOVE) $@
	$(FFMPEG) $< -vf scale=320:-2 $(FFMPEG_RES_CONVERT_UNIVERSAL_FLAGS) $@ -y

640/%.mp4: %.mp4 640
	$(REMOVE) $@
	$(FFMPEG) $< -vf scale=640:-2 $(FFMPEG_RES_CONVERT_UNIVERSAL_FLAGS) $@ -y

720/%.mp4: %.mp4 720
	$(REMOVE) $@
	$(FFMPEG) $< -vf scale=720:-2 $(FFMPEG_RES_CONVERT_UNIVERSAL_FLAGS) $@ -y

1280/%.mp4: %.mp4 1280
	$(REMOVE) $@
	$(FFMPEG) $< -vf scale=1280:-2 $(FFMPEG_RES_CONVERT_UNIVERSAL_FLAGS) $@ -y

1920/%.mp4: %.mp4 1920
	$(REMOVE) $@
	$(FFMPEG) $< -vf scale=1920:-2 $(FFMPEG_RES_CONVERT_UNIVERSAL_FLAGS) $@ -y

2560/%.mp4: %.mp4 2560
	$(REMOVE) $@
	$(FFMPEG) $< -vf scale=2560:-2 $(FFMPEG_RES_CONVERT_UNIVERSAL_FLAGS) $@ -y

audio/%.mp4: %.mp4 audio
	$(REMOVE) $@
	$(COPY) $< $@

####################################################

320/%.mpd: %.mp4 320/%.mp4
	$(REMOVE) $@
	cd $(@D); MP4Box $(MP4BOX_TO_DASH_UNIVERSAL_FLAGS) $<\#video
	$(TOUCH_R) $(@D)/$< $@
	$(TOUCH_R) $(@D)/$< $(@D)

640/%.mpd: %.mp4 640/%.mp4
	$(REMOVE) $@
	cd $(@D); MP4Box $(MP4BOX_TO_DASH_UNIVERSAL_FLAGS) $<\#video
	$(TOUCH_R) $(@D)/$< $@
	$(TOUCH_R) $(@D)/$< $(@D)

720/%.mpd: %.mp4 720/%.mp4
	$(REMOVE) $@
	cd $(@D); MP4Box $(MP4BOX_TO_DASH_UNIVERSAL_FLAGS) $<\#video
	$(TOUCH_R) $(@D)/$< $@
	$(TOUCH_R) $(@D)/$< $(@D)

1280/%.mpd: %.mp4 1280/%.mp4
	$(REMOVE) $@
	cd $(@D); MP4Box $(MP4BOX_TO_DASH_UNIVERSAL_FLAGS) $<\#video
	$(TOUCH_R) $(@D)/$< $@
	$(TOUCH_R) $(@D)/$< $(@D)

1920/%.mpd: %.mp4 1920/%.mp4
	$(REMOVE) $@
	cd $(@D); MP4Box $(MP4BOX_TO_DASH_UNIVERSAL_FLAGS) $<\#video
	$(TOUCH_R) $(@D)/$< $@
	$(TOUCH_R) $(@D)/$< $(@D)

2560/%.mpd: %.mp4 2560/%.mp4
	$(REMOVE) $@
	cd $(@D); MP4Box $(MP4BOX_TO_DASH_UNIVERSAL_FLAGS) $<\#video
	$(TOUCH_R) $(@D)/$< $@
	$(TOUCH_R) $(@D)/$< $(@D)

audio/%.mpd: %.mp4 audio/%.mp4
	$(REMOVE) $@
	cd $(@D); MP4Box $(MP4BOX_TO_DASH_UNIVERSAL_FLAGS) $<\#audio
	$(TOUCH_R) $(@D)/$< $@
	$(TOUCH_R) $(@D)/$< $(@D)

####################################################

%_dash.mpd: xmltodict.install 320/%.mpd 640/%.mpd 720/%.mpd 1280/%.mpd 1920/%.mpd 2560/%.mpd audio/%.mpd
	$(REMOVE) $@
	$(PIPENV_RUN) $(COMBINE_MPDS) $@

####################################################
