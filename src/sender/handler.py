import boto3
import json
import os

def handler(event, context):
    s3 = boto3.resource('s3')
    bucket = os.environ['BUCKET']
    key = 'sample.json'
    obj = s3.Object(bucket, key)
    body = obj.get()['Body'].read().decode('utf-8')
    return json.loads(body)