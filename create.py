import json
import boto3
import logging
import uuid
from datetime import datetime

def handler(event, context):
    dynamodb = boto3.resource('dynamodb')
    client = boto3.client('dynamodb')

    table = dynamodb.Table('table_test')

    eventDateTime = (datetime.now()).strftime("%Y-%m-%d %H:%M:%S")
    todo_id = str(uuid.uuid1())
    text = event['text']

    table.put_item(
        Item={
            'eventDateTime': eventDateTime,
            'todo_id': todo_id,
            'text': text
        }
    )

    return {
            "statusCode": 200,
            "statusDescription": "200 OK!",
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps(text)
            }
