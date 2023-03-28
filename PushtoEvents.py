import json
import boto3
import datetime

client = boto3.client('events')

def lambda_handler(event, context):
    # Replace event bus name with your event bus arn
    
    response = client.put_events(
        Entries=[
            {
            'Time': datetime.datetime.now(),
            'Source': 'Lambda Publish',
            'Resources': [
             ],
            'DetailType': 'EB Demo',
            'Detail': json.dumps(event),
            'EventBusName': ' ',
            'TraceHeader': 'testdemo'
             },
                ]
             )
        
    return response