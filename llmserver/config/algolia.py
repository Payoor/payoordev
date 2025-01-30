import os
import asyncio
import requests
from algoliasearch.search.client import SearchClientSync
from dotenv import load_dotenv
from pprint import pprint

from config.redis import redis_client
from config.mongoose import productCollection  

load_dotenv()

ALGOLIA_APP_ID=os.getenv('ALGOLIA_APP_ID')
ALGOLIA_APP_KEY=os.getenv('ALGOLIA_APP_KEY')
ALGOLIA_PRODUCTS_INDEX=os.getenv('ALGOLIA_PRODUCTS_INDEX')

algolia_client = SearchClientSync(ALGOLIA_APP_ID, ALGOLIA_APP_KEY)
products_index = ALGOLIA_PRODUCTS_INDEX
movies_index = "movies_index"

def initialize_product_index_settings():
    try:
        isFirstRun = redis_client.setnx('ALGOLIA_PRODUCTS_INDEX_SETTINGS_SET_V_ONE', 'true')

        if isFirstRun and os.getenv('FLASK_ENV') == 'production':
            response = algolia_client.set_settings(
                index_name=products_index,
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

            response = algolia_client.get_settings(
                index_name=movies_index,
            ) 

            print(response)
            print("Algolia products index settings set")
        elif(os.getenv('FLASK_ENV') != 'production'):
            print("This is a development environment")
        else:
            print('Algolia products settings already set')
    except Exception as e:
        print(e)

initialize_product_index_settings()

def sync_to_algolia_in_batches():
    batch_size = 10
    
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
            save_resp = algolia_client.save_object(
                index_name=products_index,
                body=body
            )

            algolia_client.wait_for_task(
                index_name=products_index,
                task_id=save_resp.task_id,
            )

            productCollection.update_one(
                {"_id": product["_id"]},
                {"$set": {"synced_to_algolia": True}}
            )

            print(f"Done syncing product {str(product['_id'])}")

        except Exception as e:
            print(f"Error syncing product {product['_id']}: {e}")

def update_algolia_item(product_id, body):
    try:
        response = algolia_client.partial_update_object(
            index_name=products_index,
            object_id=product_id,
            attributes_to_update=body,
        )

        algolia_client.wait_for_task(
            index_name=products_index,
            task_id=response.task_id,
        )

        print(f"Done syncing product {str(product_id)}")

    except Exception as e:
            print(f"Error syncing product {product_id}: {e}")

def delete_algolia_item(product_id):
    try:
        print(product_id)
        print('deleting product in algolia')
        response = algolia_client.delete_object(
            index_name=products_index,
            object_id=product_id,
        )

        algolia_client.wait_for_task(
            index_name=products_index,
            task_id=response.task_id,
        )

        print(f"Done deleting product from algolia index {products_index} {str(product_id)}")

    except Exception as e:
            print(f"Error syncing product {product_id}: {e}")  

def search_algolia_product_index(search_query):

    response = algolia_client.search(
        search_method_params={
            "requests": [
                {
                    "indexName": products_index,
                    "typoTolerance": True,
                    "query": search_query,
                    "hitsPerPage": 50,
                },
            ],
        },
    )

    pprint(response.results)

    if response.results[0].actual_instance.hits and len(response.results[0].actual_instance.hits) > 0:
       return response.results[0].actual_instance.hits
    return []



