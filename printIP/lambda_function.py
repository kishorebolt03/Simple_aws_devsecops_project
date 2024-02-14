def handler(event, context):
    print(event)
    #method_type=str(event['requestContext']['http']['method'])
    if (method_type == 'GET'):
        ip_address = event.get('requestContext', {}).get('headers', {}).get('X-Forwarded-For', '')
        print(f"Requester IP: {ip_address}")
        # Your function logic here
        return {
                'statusCode':200,
                'body': json.dumps(f"Requester IP : {ip_address}")
                }

if __name__ == "__main__":
    pass

