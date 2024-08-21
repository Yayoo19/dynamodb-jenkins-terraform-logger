import json
import boto3
from datetime import datetime
from botocore.exceptions import ClientError

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('LogsTable')
counter_table = dynamodb.Table('LogIdCounter')

def get_next_log_id():
    try:
        response = counter_table.get_item(Key={'id': 'counter'})
        current_id = response.get('Item', {}).get('current_id', 0)
        
        next_id = current_id + 1
        
        counter_table.update_item(
            Key={'id': 'counter'},
            UpdateExpression='SET current_id = :val',
            ExpressionAttributeValues={':val': next_id}
        )
        
        return next_id
    except ClientError as e:
        print(f"Error getting or updating LogIdCounter: {e}")
        raise

def lambda_handler(event, context):
    log_message = event.get('message', 'Jenkins build has been executed')
    timestamp = datetime.now().isoformat()
    log_id = get_next_log_id()

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
