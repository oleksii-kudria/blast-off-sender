import requests

def handler(event, context):
    r = requests.get('https://github.com')
    return r.status_code