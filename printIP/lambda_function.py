def handler(event, context):
  ip_address = event.get('requestContext', {}).get('headers', {}).get('X-Forwarded-For', '')
  print(f"Requester IP: {ip_address}")
  # Your function logic here
  return {}

if __name__ == "__main__":
    pass
