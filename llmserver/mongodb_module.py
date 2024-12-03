import os
from pymongo import MongoClient
from typing import List
from bson import ObjectId

from chromadb_module import create_vector_and_save

mongo_url = os.getenv('MONGO_URL')

client = MongoClient(mongo_url)
dbname = str(os.getenv('DB_NAME'))
db = client[dbname] 
productCollection = db['products']

def vectorise_product_details():
    products_to_vect = get_data_for_vector_save()

    for item in products_to_vect:
        create_vector_and_save(f"{item['data']['NAME']} {item['generatedDescription']}", f"{item['_id']}")

def get_data_for_vector_save():
    try:
        items = productCollection.find({
            "$or": [
                {"vector_created": False},
                {"vector_created": {"$exists": False}}
            ]
        })
        return list(items)

    except Exception as e:
       print(f"Error fetching data: {str(e)}")
       return []

def create_vector_text(data: dict) -> str:
    name = data['NAME'].strip()
    units = ' '.join(data['UNIT'])
    
    category = name.split('-')[-1].strip() if '-' in name else ''
    
    vector_text = f"product: {name} category: {category} available sizes: {units}"
    
    return vector_text


def add_product(data: dict, generatedDescription: str = None, images: list = None, generatedCategories: list = None):
    try:
        product = {
            "data": data,
            "images": images if images is not None else [],
            "generatedDescription": generatedDescription,
            "generatedCategories": generatedCategories if generatedCategories is not None else []
        }

        result = productCollection.insert_one(product)
        print(result.inserted_id)

    except Exception as e:
       print(f"Error adding product: {str(e)}")
       raise

async def get_items_by_ids(ids: List[str]) -> List[dict]:
    try:
        object_ids = [ObjectId(id_str) for id_str in ids]
        documents = list(productCollection.find({'_id': {'$in': object_ids}}))
        for doc in documents:
            doc['_id'] = str(doc['_id'])
            
        return documents
    except Exception as e:
        print(f"Error fetching documents: {str(e)}")
        return []