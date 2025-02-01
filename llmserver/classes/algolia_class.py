import os
from algoliasearch.search.client import SearchClientSync
from dotenv import load_dotenv
from pprint import pprint

from configurations.redis_configuration import redis_client
from configurations.mongoose_configuration import productCollection
from classes.logginghandler_class import LoggingHandler

class AlgoliaManager:
    def __init__(self):
        load_dotenv()
        
        self.logger = LoggingHandler(__name__)
        
        self.app_id = os.getenv('ALGOLIA_APP_ID')
        self.app_key = os.getenv('ALGOLIA_APP_KEY')
        self.products_index = os.getenv('ALGOLIA_PRODUCTS_INDEX')
        self.ingredients_index = os.getenv('ALGOLIA_INGREDIENTS_INDEX')
        
        self.algolia_client = SearchClientSync(self.app_id, self.app_key)
        
        self.initialize_product_index_settings()

    def initialize_product_index_settings(self):
        try:
            isFirstRun = redis_client.setnx('ALGOLIA_PRODUCTS_INDEX_SETTINGS_SET_V_ONE', 'true')

            if isFirstRun and os.getenv('FLASK_ENV') == 'production':
                products_init_response = self.algolia_client.set_settings(
                    index_name=self.products_index,
                    index_settings={
                        "searchableAttributes": ["unordered(name)", "unordered(generatedDescription)", "unordered(generatedCategories)"],
                        "customRanking": ["desc(popularity)"],
                        "ranking": ["typo", "geo", "words", "filters", "proximity", "attribute", "exact", "custom"],
                        "paginationLimitedTo": 1000,
                        "hitsPerPage": 20, 
                        "minWordSizefor1Typo": 4, 
                        "minWordSizefor2Typos": 8,
                        "queryType": "prefixLast",
                        "removeWordsIfNoResults": "none",
                        "exactOnSingleWordQuery": "attribute",
                        "highlightPreTag": "<em>",
                        "highlightPostTag": "</em>",
                        "maxValuesPerFacet": 100,
                        "alternativesAsExact": ["ignorePlurals", "singleWordSynonym"],
                        "separatorsToIndex": ""
                    },
                    forward_to_replicas=True
                )

                ingredients_init_response = self.algolia_client.set_settings(
                    index_name=self.ingredients_index,
                    index_settings={
                        "searchableAttributes": ["unordered(ingredients)"],
                        "customRanking": ["desc(popularity)"],
                        "ranking": ["typo", "geo", "words", "filters", "proximity", "attribute", "exact", "custom"],
                        "paginationLimitedTo": 1000,
                        "hitsPerPage": 20, 
                        "minWordSizefor1Typo": 4, 
                        "minWordSizefor2Typos": 8,
                        "queryType": "prefixLast",
                        "removeWordsIfNoResults": "none",
                        "exactOnSingleWordQuery": "attribute",
                        "highlightPreTag": "<em>",
                        "highlightPostTag": "</em>",
                        "maxValuesPerFacet": 100,
                        "alternativesAsExact": ["ignorePlurals", "singleWordSynonym"],
                        "separatorsToIndex": ""
                    },
                    forward_to_replicas=True
                )

                products_index_init_response = self.algolia_client.get_settings(
                    index_name=self.products_index,
                )

                ingredients_index_init_response = self.algolia_client.get_settings(
                    index_name=self.ingredients_index,
                )

                print("Algolia products index settings set")
            elif(os.getenv('FLASK_ENV') != 'production'):
                print("This is a development environment")
            else:
                print('Algolia products settings already set')
        except Exception as e:
            self.logger.logger.error(f"Error initializing Algolia settings: {str(e)}")

    def sync_to_algolia_in_batches(self):
        batch_size = 10
    
        while True:
            count = productCollection.count_documents({
                "synced_to_algolia": {"$ne": True}
            }, limit=batch_size)

            if count == 0:
                print("All products synced to Algolia")
                break

            unsaved_products = productCollection.find({
                "synced_to_algolia": {"$ne": True}
            }).limit(batch_size)

            for product in unsaved_products:
                body = {
                    "objectID": str(product["_id"]),
                    "name": product.get("name", ""),
                    "image": product.get("image", ""),
                    "generatedDescription": product.get("generatedDescription", "")
                }

                try:
                    save_resp = self.algolia_client.save_object(
                        index_name=self.products_index,
                        body=body
                    )

                    self.algolia_client.wait_for_task(
                        index_name=self.products_index,
                        task_id=save_resp.task_id,
                    )

                    productCollection.update_one(
                        {"_id": product["_id"]},
                        {"$set": {"synced_to_algolia": True}}
                    )

                    print(f"Done syncing product {str(product['_id'])}, {str(product['name'])}")

                except Exception as e:
                    self.logger.logger.error(f"Error syncing product {product['_id']}: {str(e)}")

    def update_algolia_item(self, product_id, body):
        try:
            response = self.algolia_client.partial_update_object(
                index_name=self.products_index,
                object_id=product_id,
                attributes_to_update=body,
            )

            self.algolia_client.wait_for_task(
                index_name=self.products_index,
                task_id=response.task_id,
            )

            print(f"Done syncing product {str(product_id)}")

        except Exception as e:
            self.logger.logger.error(f"Error syncing product {product_id}: {str(e)}")

    def delete_algolia_item(self, product_id):
        try:
            print(f'Deleting product {product_id} in algolia')
            response = self.algolia_client.delete_object(
                index_name=self.products_index,
                object_id=product_id,
            )

            self.algolia_client.wait_for_task(
                index_name=self.products_index,
                task_id=response.task_id,
            )

            print(f"Done deleting product from algolia index {self.products_index} {str(product_id)}")

        except Exception as e:
            self.logger.logger.error(f"Error deleting product {product_id}: {str(e)}")

    def add_ingredient_to_algolia(self, body):
        try:
            print(body)
            print('+++++=============')
            save_resp = self.algolia_client.save_object(
                    index_name=self.ingredients_index,
                    body=body
            )

            self.algolia_client.wait_for_task(
                index_name=self.ingredients_index,
                task_id=save_resp.task_id,
            )

            print(f"Done adding ingredient body {body['ingredients']}")
        except Exception as e:
                self.logger.logger.error(f"Error syncing product {body['id']}: {str(e)}")