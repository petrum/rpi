#!/usr/bin/env python
from __future__ import print_function
import sys, os, time
import urllib2, urllib, json

def get_weather(w, days, metric):
    baseurl = "https://query.yahooapis.com/v1/public/yql?"
    yql_query = "select * from weather.forecast where woeid=" + str(w)
    yql_url = baseurl + urllib.urlencode({'q' : yql_query}) + "&format=json"
    result = urllib2.urlopen(yql_url).read()
    data = json.loads(result)
    channel = data['query']['results']['channel']
    res = channel['item']
    condition = res['condition']
    units = channel['units']
    location = channel['location']
    astronomy = channel['astronomy']
    forecasts = []
    for i, f in enumerate(res['forecast']):
        if i >= days:
            break
        else:
            forecasts.append({
                'date': f['date'],
                'low': f['low'],
                'high': f['high'],
                'day': f['day'],
                'condition': f['text'],
            })
    d = {
        'condition': condition['text'],
        'when': condition['date'],
        'temp': condition['temp'],
        'forecasts': forecasts,
        'units': units['temperature'],
        'city': location['city'],
        'region': location['region'],
        'sunrise': astronomy['sunrise'],
        'sunset': astronomy['sunset'],
    }
    return d

def format_weather(w): 
    units = w['units']
    ret = []
    ret.append("Current {0}".format(w['when']))
    ret.append("{1}{2} and {0} in {3} {4}".format(w['condition'], w['temp'], units, w['city'], w['region'], w['when']))
    ret.append("The sun rises at {0} and sunsets at {1}".format(w['sunrise'], w['sunset']))
    ret.append("Forecast:")
    for f in w['forecasts']:
        ret.append('- {0}: {1} low = {2}{4}, high = {3}{4}'.format(f['day'], f['condition'], f['low'], f['high'], units))
    return ret

if len(sys.argv) >= 6:
    path = sys.argv[4]
    age = int(sys.argv[5])
    if os.path.isfile(path):
        st = os.stat(path)
        mtime = st.st_mtime
        now = int(time.time())
        ago = now - mtime
        #print(now, mtime, ago)
        if ago < age:
            #print("The file was modified ", ago, " seconds ago");
            sys.exit(0)

w = get_weather(int(sys.argv[1]), int(sys.argv[2]), sys.argv[3] != '0')

f = sys.stdout
if len(sys.argv) >= 5:
    f = open(sys.argv[4], 'w+')

for line in format_weather(w):
    print(line, file=f)
