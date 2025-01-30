import os
import pandas as pd
import pathlib

from pymongo import MongoClient
from datetime import datetime
from collections import defaultdict

from config.mongoose import ObjectId, productCollection, productVariant 
from config.algolia import sync_to_algolia_in_batches

client = MongoClient('mongodb://localhost:27017')
db = client['chat-dbv35']

productCollection = db['newproducts']
productVariant = db['productvariants']

#print(db.list_collection_names())

grouped_products = defaultdict(list)

current_dir = os.getcwd()
file_path = os.path.join(current_dir, "PAYOOR.xlsx")

#print(file_path)

def add_product_to_mongodb(product):
    product['createdAt'] = datetime.utcnow()
    product['updatedAt'] = datetime.utcnow()

    result = productCollection.insert_one(product)
    
    inserted_product = productCollection.find_one({"_id": result.inserted_id})
    
    return inserted_product['_id']

def add_product_variants_to_mongodb(variants, productId):
    variant_bodies = [
        {
            "productId": productId, 
            "image": "",
            "unit": variant['unit'],  
            "price": variant['price'], 
            "availability": variant['availability'],
            "createdAt": datetime.utcnow(),
            "updatedAt": datetime.utcnow()
        } 
        for variant in variants
    ]
    
    result = productVariant.insert_many(variant_bodies)
    # Get all inserted variants
    added_variants = list(productVariant.find({"_id": {"$in": result.inserted_ids}}))
    
    return added_variants

def process_excel_and_add_to_mongodb(file_path):
    try:
        # Read Excel file
        df = pd.read_excel(file_path)
        
        # Initialize collections
        all_items = []
        grouped_products = defaultdict(list)
        
        # Process each row
        for row in df.itertuples():
            item = {
                'product_name': getattr(row, 'NAME', "N/A"),
                'unit': getattr(row, 'UNIT', "N/A"),
                'price': getattr(row, 'price', "N/A"),
                'availability': getattr(row, 'AVAILABILITY', "N/A")
            }
            all_items.append(item)

        # Group products by name
        for product in all_items:
            product_name = product['product_name']
            grouped_products[product_name].append(product)

        # Process and add to MongoDB
        added_products = []
        for grouped_product in grouped_products.items():
            try:
                product_data = {
                    "product_name": grouped_product[0],
                    "variants": grouped_product[1]
                }

                new_product = {
                    "image": "",
                    "generatedDescription": "",
                    "generatedCategories": [],
                    "synced_to_algolia": False,
                    "name": product_data["product_name"]
                }

                # Add product and its variants
                product_id = add_product_to_mongodb(new_product)
                variant_ids = add_product_variants_to_mongodb(product_data["variants"], product_id)
                
                added_products.append({
                    "product_id": product_id,
                    "name": product_data["product_name"],
                    "variant_count": len(variant_ids)
                })

                #print(added_products)
                
            except Exception as product_error:
                print(f"Error adding product {grouped_product[0]}: {product_error}")
                continue

        return True, {
            "success": True,
            "message": f"Successfully processed {len(added_products)} products",
            "products": added_products
        }

    except FileNotFoundError:
        return False, {
            "success": False,
            "message": f"File not found at: {file_path}"
        }
    except Exception as e:
        return False, {
            "success": False,
            "message": f"Error processing file: {str(e)}"
        }

def run_data_processing():
    try:
        # Run Excel processing first and check its success
        success, result = process_excel_and_add_to_mongodb(file_path)
        
        if success:
            print("Excel processing completed successfully")
            print(result['message'])
            
            # Only run Algolia sync if Excel processing was successful
            sync_to_algolia_in_batches()
            print("Algolia sync completed")
        else:
            print("Excel processing failed:", result['message'])
            
    except Exception as e:
        print(f"An error occurred: {str(e)}")
