#!/usr/bin/env python3

import urllib.request, urllib.parse, urllib.error
from xml.dom.minidom import parse
import time
import sys

WEATHER_URL = 'htstp://xml.weather.yahoo.com/forecastrss?p=%s'
METRIC_PARAMETER = '&u=c'
WEATHER_NS = 'http://xml.weather.yahoo.com/ns/rss/1.0'

def get_weather(zipCode, days, metric):
    url = WEATHER_URL % zipCode
    if metric:
        url = url + METRIC_PARAMETER
    #print(url)
    dom = parse(urllib.request.urlopen(url))
    forecasts = []
    for i, node in enumerate(dom.getElementsByTagNameNS(WEATHER_NS, 'forecast')):
        if i >= days:
            break
        else:
            forecasts.append({
                'date': node.getAttribute('date'),
                'low': node.getAttribute('low'),
                'high': node.getAttribute('high'),
                'day': node.getAttribute('day'),
                'condition': node.getAttribute('text')
            })
    units = dom.getElementsByTagNameNS(WEATHER_NS, 'units')[0]
    location = dom.getElementsByTagNameNS(WEATHER_NS, 'location')[0]
    condition = dom.getElementsByTagNameNS(WEATHER_NS, 'condition')[0]
    astronomy = dom.getElementsByTagNameNS(WEATHER_NS, 'astronomy')[0]

    d = {
        'condition': condition.getAttribute('text'),
        'when': condition.getAttribute('date'),
        'temp': condition.getAttribute('temp'),
        'forecasts': forecasts,
        'units': units.getAttribute('temperature'),
        'city': location.getAttribute('city'),
        'region': location.getAttribute('region'),
        'sunrise': astronomy.getAttribute('sunrise'),
        'sunset': astronomy.getAttribute('sunset'),
    }
    return d

def format_weather(w): 
    units = w['units']
    ret = []
    ret.append("Current conditions as of {5}\n{1}{2} and {0} in {3} {4}".format(
        w['condition'], w['temp'], units, w['city'], w['region'], w['when']))
    ret.append("The sun rises at {0} and sunsets at {1}".format(w['sunrise'], w['sunset']))
    ret.append("Forecast:")
    for f in w['forecasts']:
        ret.append('{0}: {1} low = {2}{4}, high = {3}{4}'.format(f['day'], f['condition'], f['low'], f['high'], units))
    return ret

fName = "/tmp/weather.txt"
def get_weather_forever():
    while True:
        try:
            w = get_weather(10583, 5, False)
            s = format_weather(w)
            f = open(fName, "w")
            for n in s:
                print(n, file=f)
            f.close()
            display(s)
        except Exception as e:
            display(["ERROR: " + repr(e)])
            with open(fName, 'r') as f:
                display(f.read().splitlines())
                f.close()        
        time.sleep(10)

def display(s):
    for line in s:
        print(line)

get_weather_forever()
#w = get_weather(10583, 5, False)
#display(format_weather(w))
