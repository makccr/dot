#!/usr/bin/env python

import urllib.request
import json

USERNAME="mackenziegcriswell" #replace with channel username

with open("/home/makc/Dropbox/keys/youtube.txt", "r") as file:
    APIKEY = file.readline().strip()

data = urllib.request.urlopen("https://www.googleapis.com/youtube/v3/channels?part=statistics&forUsername="+USERNAME+"&key="+APIKEY).read()
subs = json.loads(data)["items"][0]["statistics"]["subscriberCount"]

print("{:,d}".format(int(subs)))
