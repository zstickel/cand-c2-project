import os
import json

def lambda_handler(event, context):
    return {
     'body': json.dumps("{} from Lambda!".format(os.environ['greeting']))
    }