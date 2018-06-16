# mp4-to-mpegdash
Perl script to convert a MP4 video into MPEG-DASH

- Creates the multiple bitrate versions to a pre-defined set of resolutions ('320', '640', '720', '1280', '1920', '2560')
- Split the versions into segments of 1 second (by default)
- Handle the main MPEG-DASH manifest file.

# Dependencies

- FFmpeg https://www.ffmpeg.org/
- MP4Box https://gpac.wp.mines-telecom.fr/mp4box/

## Perl Dependencies

XML::Simple

Install with `cpan install XML::Simple`

## Python Dependencies

xmltodict

Install with `pip install xmltodict` or `pipenv install`

# Usage
Original transcoding tool:
- `$ perl transcode.pl $FILENAME`

MPD Combiner tool:
- `$ pipenv run python combine_MPDs.py --mpd_name' "$FILENAMEwithoutEXT_dash.mpd"` or `$ python combine_MPDs.py --mpd_name' "$FILENAMEwithoutEXT_dash.mpd"`

Transcode then combine script/tool:
- `$ ./mp4_to_dash.sh $FILENAMEwithoutEXT`
