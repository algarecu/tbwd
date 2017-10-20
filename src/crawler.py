#!usr/bin/env python
#encoding:utf-8

import pandas as pd
import requests
import json
import base64

df=pd.read_csv('../datasets/1-ss-hs-is-metadata.csv', usecols=['STREAMDOMAIN'])

print "The list of streaming domains \n"
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
    # body = json.loads(r.text)

    # Check status_code and write to file
    if r.status_code == requests.codes.ok:
        print "Correct URL, alive and parsed"
        # Save website html and image files
        with open('../datasets/html/' + item, 'wb') as fd:
            for chunk in r.iter_content(chunk_size=128):
                fd.write(chunk)
        # with open('../datasets/png/%s.png' % item, 'wb') as pngfile:
        #     pngfile.write(base64.b64decode(body['png']))
    else:
        print("Request to %s failed with error code %d" % (item, r.status_code) )
