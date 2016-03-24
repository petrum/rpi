#!/usr/bin/env python3

import urllib.request, urllib.parse, urllib.error
from xml.dom.minidom import parse

WEATHER_URL = 'http://xml.weather.yahoo.com/forecastrss?p=%s'
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
        'temp': condition.getAttribute('temp'),
        'forecasts': forecasts,
        'units': units.getAttribute('temperature'),
        'city': location.getAttribute('city'),
        'region': location.getAttribute('region'),
        'sunrise': astronomy.getAttribute('sunrise'),
        'sunset': astronomy.getAttribute('sunset'),
    }
    return d

def print_weather(w): 
    units = w['units']
    print("Current conditions: {1}{2} and {0} in {3} {4}\nThe sun rises at {5} and sunsets at {6}".format(
        w['condition'], w['temp'], units, w['city'], w['region'], w['sunrise'], w['sunset']))
    print("Forecast")
    for f in w['forecasts']:
        print('{0}: {1} low = {2}{4}, high = {3}{4}'.format(f['day'], f['condition'], f['low'], f['high'], units))


while True:
    try:
        w = get_weather(10583, 5, False)
        print_weather(w)
    except Exception, e:
        print("Error:", str(e))
