from dotenv import load_dotenv
import os
import redis

load_dotenv()

redis_client = redis.Redis.from_url(
    url=os.getenv('REDIS_URL'),
    decode_responses=True
)

def toggle_bookmark(product_id, user_id):
   try:
       if product_id in redis_client.lrange(f'bookmarks:{user_id}', 0, -1):
           redis_client.lrem(f'bookmarks:{user_id}', 0, product_id)
           return "Bookmark removed"
       else:
           redis_client.lpush(f'bookmarks:{user_id}', product_id)
           return "Bookmark added"
   except redis.ConnectionError:
       return "Failed to toggle bookmark"

def check_bookmarks_for_product(product_id, user_id):
    try:
        if product_id in redis_client.lrange(f'bookmarks:{user_id}', 0, -1):
           return True
        else:
           return False
    except redis.ConnectionError:
       return "Failed to check bookmark successfully"

def check_redis_connection():
    try:
        response = redis_client.ping()
        print("Connected to Redis" if response else "Connection failed")
    except redis.ConnectionError:
        print("Failed to connect to Redis")

check_redis_connection()