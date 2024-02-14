import json
from flask import Flask, render_template

def handler(event, context):
    print(event)
    print("Modified")
    method_type=str(event['httpMethod'])
    if (method_type == 'GET'):
        ip_address = event.get('headers', {}).get('X-Forwarded-For', '')
        print(f"Requester IP: {ip_address}")
        # Your function logic here
        return {
                'statusCode':200,
                'body': json.dumps(f"Requester IP address: {ip_address}\n IP address in Reverse: {".".join(ip_address.split('.')[::-1])}")
                }

if __name__ == "__main__":
    pass

