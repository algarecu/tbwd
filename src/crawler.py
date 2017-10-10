#!usr/bin/env python
#encoding:utf-8

import pandas as pd
import requests
import json

df=pd.read_csv('../datasets/1-ss-hs-is-metadata.csv', usecols=['STREAMDOMAIN'])

print "The list of straming domains \n"
print list(df.apply(set)[0])

for item in list(df.apply(set)[0]):
    if item == 'streamflv.com':
        url ='http://web.archive.org/web/20170727115737/http://streamflv.com/'
    else:
        url = 'http://' + item

    headers = {'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) \
                AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36'}
    # Parse
    r = requests.get(url, headers=headers)

    # Check status_code and write to file
    if r.status_code == requests.codes.ok:
        print "Correct URL, alive and parsed"
        # Save content to text file
        with open('../datasets/html/' + item + '.html', 'wb') as fd:
            for chunk in r.iter_content(chunk_size=128):
                fd.write(chunk)
