# coding: utf-8

import xmltodict
from collections import OrderedDict
import argparse

#############################################

parser = argparse.ArgumentParser()
parser.add_argument('-m', '--mpd_name', type=str, default='WonderWoman2017_10min_dash.mpd', help='Name of MPD to Process', dest='mpdname')
parser.add_argument('-r', '--video_res', type=str, nargs="+", default=['320', '640', '720', '1280', '1920', '2560'], help='Video Resolutions to Process', dest='videores')
parser.add_argument('-a', '--audio_trk', type=str, nargs="+", default=['audio'], help='Audio Tracks to Process', dest='audiotrk')

#############################################

args = parser.parse_args()
mpd_name = args.mpdname
video_res = args.videores
audio_trk = args.audiotrk

#############################################

print("Video MPDs:")
for v_res in video_res:
    print("%s/%s" % (v_res, mpd_name))

print("Audio MPDs:")
for a_trk in audio_trk:
    print("%s/%s" % (a_trk, mpd_name))

############################################

v_res = video_res[-1]

cur_mpd = "%s/%s" % (v_res, mpd_name)

internal_dict = xmltodict.parse(open(cur_mpd).read())

del internal_dict['MPD']['Period']['AdaptationSet']['Representation']
internal_dict['MPD']['Period']['AdaptationSet']['Representation'] = []

for v_res in video_res:
    cur_mpd = "%s/%s" % (v_res, mpd_name)
    print(cur_mpd)
    internal_dict['MPD']['Period']['AdaptationSet']['Representation']\
        .append(
            xmltodict.parse(open(cur_mpd).read())\
                ['MPD']['Period']['AdaptationSet']['Representation']
        )
    internal_dict['MPD']['Period']['AdaptationSet']['Representation'][-1]\
        ['BaseURL'] = "%s/" % v_res

adaptation_set = internal_dict['MPD']['Period']['AdaptationSet']
del internal_dict['MPD']['Period']['AdaptationSet']
internal_dict['MPD']['Period']['AdaptationSet'] = [adaptation_set]

a_trk = audio_trk[-1]
a_trk_file = "%s/%s" % (a_trk, mpd_name)
print(a_trk_file)

internal_dict['MPD']['Period']['AdaptationSet'].append(
    xmltodict.parse(open(a_trk_file).read())['MPD']['Period']['AdaptationSet']
)

internal_dict['MPD']['Period']['AdaptationSet'][-1]['Representation']['BaseURL'] = 'audio/'

xml_out = xmltodict.unparse(internal_dict, pretty=True)

print(xml_out)

out_file_name = mpd_name

out_file = open(out_file_name, 'w')
out_file.write(xml_out)
out_file.close()
