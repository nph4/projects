#! python3
# getBridge.py - Prints the status of the bridges in Portland OR.
# Created by Nelson Hickman

import requests

# hardcode the API key
secret = '?access_token=INSERT_API_KEY'

# Download the JSON data from mulnomah county's API.
url ='https://api.multco.us/bridges' + secret
response = requests.get(url)
response.raise_for_status()

# Load JSON data into a Python variable.
bridge_data = response.json()

#Loop through the bridges and print status

for bridge in bridge_data:
    if not bridge['isUp']:
        print(bridge['name'] + ' is down')
    elif bridge['isUp']:
        print(bridge['name'] + ' is up')

# List of bridges that Org cares about
bridge_list = ['hawthorne', 'morrison', 'burnside', 'broadway']

# function to get next scheduled lift
def get_bridge_schedule(bridge):
    scheduleUrl = f'https://api.multco.us/bridges/{bridge}/events/scheduled{secret}'
    schedule_response = requests.get(scheduleUrl)
    schedule_response.raise_for_status()

    schedule_bridge_data = schedule_response.json()
    if schedule_bridge_data != []:
        print(f'The next scheduled lift for {bridge} is: ' + schedule_bridge_data[0])
    else:
        print(f'no secheduled lift for {bridge}.')

# get next scheduled lift
for bridge in bridge_list:
    get_bridge_schedule(bridge)