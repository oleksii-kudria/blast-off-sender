import boto3
import json
import os

client = boto3.client('dynamodb')

def handler(event, context):
  table = os.environ['TABLE']
  data = client.get_item(
    TableName=table,
    Key={
        'id': {
          'S': '005'
        }
    }
  )

  response = {
      'statusCode': 200,
      'body': json.dumps(data),
      'headers': {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*'
      },
  }

  return response