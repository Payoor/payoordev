import os
from pymongo import MongoClient, UpdateOne
from bson.objectid import ObjectId
from dotenv import load_dotenv

load_dotenv()

class MongoDB:
    def __init__(self):
        self.mongo_url = os.getenv('MONGO_URL')
        self.dbname = os.getenv('DB_NAME')
        
        try:
            self.client = MongoClient(self.mongo_url)
            self.db = self.client[self.dbname]
            self.productCollection = self.db['newproducts']
            self.productVariant = self.db['productvariants']
            self.orderCollection = self.db['orders']
            self.imageCollection = self.db['images']
            self.foodmodelsCollection = self.db['foodmodels']
            
            self.client.server_info()
            print(f"Successfully connected to MongoDB: {self.dbname}")
            print(self.db.list_collection_names())
            
        except Exception as e:
            print(f"MongoDB Connection Error: {e}")
            raise

db = MongoDB()
productCollection = db.productCollection
productVariant = db.productVariant
orderCollection = db.orderCollection
imageCollection = db.imageCollection
foodmodelsCollection = db.foodmodelsCollection