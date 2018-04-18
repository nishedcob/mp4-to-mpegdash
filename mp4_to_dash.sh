#! /bin/bash
echo "Usage: $0 name_of_mp4_without.ext"

echo 'perl transcode.pl' "$1.mp4"
perl transcode.pl "$1.mp4"

echo 'pipenv run python combine_MPDs.py --mpd_name' "$1_dash.mpd"
pipenv run python combine_MPDs.py --mpd_name "$1_dash.mpd"
