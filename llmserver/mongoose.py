import os
from pymongo import MongoClient, UpdateOne
from bson.objectid import ObjectId

mongo_url = os.getenv('MONGO_URL')

client = MongoClient(mongo_url)
dbname = str(os.getenv('DB_NAME'))

db = client[dbname] 
productCollection = db['products']