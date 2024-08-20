import json
import boto3
from datetime import datetime
import uuid

def main():
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('LogsTable')

    log_message = event.get('message', 'Jenkins build has been executed')
    timestamp = datetime.now().isoformat()
    log_id = str(uuid.uuid4())

    item = {
        'logId': log_id,
        'timestamp': timestamp,
        'message': log_message
    }
    
    table.put_item(Item=item)
    
    return {
        'statusCode': 200,
        'body': json.dumps(f'Log entry added with ID: {log_id}')
    }

def lambda_handler(event, context):
    main()
