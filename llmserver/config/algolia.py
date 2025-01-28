import os
import asyncio
import requests
from algoliasearch.search.client import SearchClientSync
from dotenv import load_dotenv
from pprint import pprint

from config.mongoose import productCollection  

load_dotenv()

ALGOLIA_APP_ID=os.getenv('ALGOLIA_APP_ID')
ALGOLIA_APP_KEY=os.getenv('ALGOLIA_APP_KEY')

algolia_client = SearchClientSync(ALGOLIA_APP_ID, ALGOLIA_APP_KEY)
products_index = "products-index"
movies_index = "movies_index"

def sync_to_algolia_in_batches():
    batch_size = 10
    
    unsaved_products = productCollection.find({
        "synced_to_algolia": {"$ne": True}
    }).limit(batch_size)

    for product in unsaved_products:
        body = {
           "objectID": str(product["_id"]),
           "name": product["name"],
           "image": product["image"],
           "generatedDescription": product["generatedDescription"]
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



