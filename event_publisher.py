#!/usr/bin/env python
"""Copyright 2014 Cyrus Dasadia

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

This is a helper script to help integrate monitoring systems with CitoEngine.

For more information, refer to http://citoengine.readthedocs.org/
"""
from datetime import datetime
import json
from time import time
import sys
try:
    import requests
    from argparse import ArgumentParser
except ImportError:
    print "Dependencies not installed, please run: \n\n\t pip install requests argparse \n"
    sys.exit(1)

API_URI = 'api/v1/incidents/add/'

parser = ArgumentParser(description='Simple Event publisher for CitoEngine.',
        epilog='event_publisher.py -e 666 -H host.foo.com -m "Out of memory" --cito-server 1.1.1.1 --cito-port 9000')
url = ''
parser.add_argument('-e', '--eventid', required=True, type=int, dest='eventid', help='Cito Event ID')
parser.add_argument('-H', '--hostname', required=True, dest='hostname', help='Element a.k.a hostname of alerting node')
parser.add_argument('-m', '--message', required=True, dest='message', help='Alert message')
parser.add_argument('-t', '--time', required=False, default=int(time()), dest='timestamp', help='Unix timestamp of event, leave blank to use now')
parser.add_argument('--cito-server', required=True, default='localhost', dest='cito_server', help='CitoEngine Event Listener FQDN/IP')
parser.add_argument('--cito-port', required=True, default=8080, type=int, dest='cito_port', help='CitoEngine Event Listener Port')
parser.add_argument('--use-ssl', required=False, help='Use SSL with CitoEngine server', action='store_true', default=False, dest='use_ssl')
args = parser.parse_args()

json_data = dict()
if args.timestamp:
    json_data['event'] = {"eventid": args.eventid, "element": args.hostname, "message" : args.message}
    json_data['timestamp'] = int(args.timestamp)
else:
    json_data =  {"eventid": args.eventid, "element": args.hostname, "message" : args.message}

if args.use_ssl:
    url = 'https://'
else:
    url = 'http://'

url += '%s:%d/%s' % (args.cito_server, args.cito_port, API_URI)
headers = ''
response = requests.post(url, data=json.dumps(json_data), headers=headers)
if response.text is None:
    print response
else:
    print 'Response %s' % response.text

