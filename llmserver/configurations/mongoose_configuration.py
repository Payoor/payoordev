import os
from pymongo import MongoClient, UpdateOne
import json
from bson import ObjectId
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

            #self.create_indexes()
            
        except Exception as e:
            print(f"MongoDB Connection Error: {e}")
            raise

    def drop_text_indexes(self):
        try:
            for index in self.productCollection.list_indexes():
                index_info = index.to_dict()
                if 'textIndexVersion' in index_info:
                    index_name = index_info.get('name')
                    print(f"Dropping text index: {index_name}")
                    self.productCollection.drop_index(index_name)
                    
            print("All text indexes dropped successfully")
        except Exception as e:
            print(f"Error dropping text indexes: {e}")

    def create_indexes(self, force=False):
        try:
            self.drop_text_indexes()
            product_index_exists = False
            for index in self.productCollection.list_indexes():
                if index.get('name') == 'product_text_search':
                    product_index_exists = True
                    break
            
            if not product_index_exists or force:
                self.productCollection.create_index([
                    ('name', 'text'),
                    ('metadata', 'text')
                ], 
                weights={
                    'name': 10,
                    'metadata': 5
                },
                default_language='english',
                name='product_text_search')
                
                print("Product text indexes created successfully")
            else:
                print("Product text indexes already exist")
            
        except Exception as e:
            print(f"Error creating indexes: {e}")

    def search_products(self, search_term, limit=10, offset=0):
        try:
            total_count = list(self.productCollection.aggregate([
                {
                    '$match': {
                        '$text': {'$search': search_term}
                    }
                },
                {
                    '$count': 'total'
                }
            ]))
        
            results = list(self.productCollection.aggregate([
                {
                    '$match': {
                        '$text': {'$search': search_term}
                    }
                },
                {
                    '$addFields': {
                        'score': {'$meta': 'textScore'}
                    }
                },
                {
                    '$sort': {
                        'score': -1
                    }
                },
                {
                    '$skip': offset 
                },
                {
                    '$limit': limit
                },
                {
                    '$project': {
                        '_id': {'$toString': '$_id'},
                        'name': 1,
                        'metadata': 1,
                        'variantCount': 1,
                        'score': 1
                    }
                },
            ]))

            metadata_set = set()
            total = total_count[0]['total'] if total_count else 0
        
            metadata_set = {
                tag.strip()
                for product in results
                if 'metadata' in product and product['metadata']
                for tag in product['metadata'].split(',')
            }
        
            return {
                'products': results,
                'metadata_tags': list(metadata_set),
                'total': total,
            }
        except Exception as e:
            print(f"Error in search_products: {e}")
            return {
                'products': [],
                'metadata_tags': [],
                'total': 0,
            }

db = MongoDB()
productCollection = db.productCollection
productVariant = db.productVariant
orderCollection = db.orderCollection
imageCollection = db.imageCollection
foodmodelsCollection = db.foodmodelsCollection

search_products = db.search_products

