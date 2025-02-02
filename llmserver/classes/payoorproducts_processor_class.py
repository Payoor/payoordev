import os
import pandas as pd
from datetime import datetime
from collections import defaultdict

from configurations.mongoose_configuration import productCollection, productVariant 
from classes.algolia_class import AlgoliaManager
from classes.logginghandler_class import LoggingHandler
from configurations.chroma_configuration import chroma_client, openai_ef

class PayoorExcelProductsDataProcessor:
    def __init__(self):
        self.productCollection = productCollection
        self.productVariant = productVariant
        
        self.logger = LoggingHandler(__name__)
        
        self.current_dir = os.getcwd()
        self.file_path = os.path.join(self.current_dir, "excelsheets", "PAYOOR_PRODUCTS.xlsx")

        self.algolia_manager = AlgoliaManager()
        
        self.collectionName = "product_collection"
        self.collection = chroma_client.get_or_create_collection(name=self.collectionName, embedding_function=openai_ef)

    def add_product_to_mongodb(self, product):
        try:
            product['createdAt'] = datetime.utcnow()
            product['updatedAt'] = datetime.utcnow()
            
            result = self.productCollection.insert_one(product)
            return result.inserted_id
        except Exception as e:
            self.logger.logger.error(f"Error adding product to MongoDB: {str(e)}")
            return None

    def add_product_variants_to_mongodb(self, variants, productId):
        try:
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
            
            result = self.productVariant.insert_many(variant_bodies)
            added_variants = list(self.productVariant.find({"_id": {"$in": result.inserted_ids}}))
            return added_variants
        except Exception as e:
            self.logger.logger.error(f"Error adding product variants: {str(e)}")
            return []

    def add_product_to_chroma(self, product):
        try:
            print('chroma')
            print(product)

            self.collection.upsert(
                documents=[product.get("name", "")],
                ids=product.get("id", "")
            )
        except Exception as e:
            self.logger.logger.error(f"Error adding product variants: {str(e)}")
            return False

    def process_excel_and_add_to_mongodb(self):
        try:
            df = pd.read_excel(self.file_path)
            
            all_items = []
            grouped_products = defaultdict(list)
            
            for row in df.itertuples():
                item = {
                    'product_name': self.clean_product_name(getattr(row, 'NAME', "N/A")),
                    'unit': getattr(row, 'UNIT', "N/A"),
                    'price': getattr(row, 'UNITPRICE', "1"),
                    'availability': getattr(row, 'AVAILABILITY', "NO"),
                    'db_tag': getattr(row, 'NAME', "N/A")
                }
                
                all_items.append(item)

            for product in all_items:
                product_name = product['product_name']
                grouped_products[product_name].append(product)

            added_products = []
            for product_name, variants in grouped_products.items():
                try:
                    product_data = {
                        "product_name": product_name,
                        "generatedCategories": [variant["db_tag"] for variant in variants],
                        "variants": variants
                    }

                    #print(product_data)

                    new_product = {
                        "image": "",
                        "generatedDescription": "",
                        "generatedCategories": product_data["generatedCategories"],
                        "synced_to_algolia": False,
                        "name": product_data["product_name"]
                    }

                    #print(new_product)
                    product_id = self.add_product_to_mongodb(new_product)
                    new_product["id"] = product_id.__str__()
                    new_product["name"] = [variant["db_tag"] for variant in variants][0].lower()
                    self.add_product_to_chroma(new_product)

                    if product_id:
                        variant_ids = self.add_product_variants_to_mongodb(product_data["variants"], product_id)
                        
                        added_products.append({
                            "product_id": product_id,
                            "name": product_data["product_name"],
                            "variant_count": len(variant_ids)
                        })
                
                except Exception as product_error:
                    self.logger.logger.error(f"Error processing product {product_name}: {str(product_error)}")
                    continue

            return True, {
                "success": True,
                "message": f"Successfully processed {len(added_products)} products",
                "products": added_products
            }

        except FileNotFoundError:
            self.logger.logger.error(f"File not found at: {self.file_path}")
            return False, {
                "success": False,
                "message": f"File not found at: {self.file_path}"
            }
        except Exception as e:
            self.logger.logger.error(f"Error processing Excel file: {str(e)}")
            return False, {
                "success": False,
                "message": f"Error processing file: {str(e)}"
            }

    def clean_product_name(self, name):
        return ''.join(char.lower() for char in name if char.isalnum())

    def run_data_processing(self):
        try:
            success, result = self.process_excel_and_add_to_mongodb()
            
            '''if success:
                print("Excel processing completed successfully")
                print(result['message'])
                
                self.algolia_manager.sync_to_algolia_in_batches()
                print("Algolia sync completed")
                return result
            else:
                self.logger.logger.error(f"Excel processing failed: {result['message']}")
                return result'''
                
        except Exception as e:
            error_message = f"An error occurred during data processing: {str(e)}"
            self.logger.logger.error(error_message)
            return {
                "success": False,
                "message": error_message
            }