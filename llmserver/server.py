from flask import Flask, request, jsonify
import os
import re
import json

from pprint import pprint

import asyncio
from dotenv import load_dotenv
from flask_cors import CORS
from datetime import datetime
from threading import Timer

from configurations.mongoose_configuration import ObjectId, productCollection, productVariant 
from configurations.redis_configuration import toggle_bookmark, check_bookmarks_for_product

from classes.logginghandler_class import LoggingHandler
from classes.payoorproducts_processor_class import PayoorExcelProductsDataProcessor
from classes.payooringredients_processor_class import PayoorExcelIngredientsProcessor
from classes.algolia_class import AlgoliaManager
from classes.algolia_class import AlgoliaManager
from classes.search_class import SearchManager

load_dotenv()

app = Flask(__name__)
port = int(os.getenv('PORT')) 

logging_handler = LoggingHandler(__name__ )
algolia_manager = AlgoliaManager()
excel_products_processor = PayoorExcelProductsDataProcessor()
excel_ingredients_processor = PayoorExcelIngredientsProcessor()
search_manager = SearchManager()


UPLOAD_FOLDER = 'uploads'

if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)

app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

@app.route('/product/bookmark', methods=['POST'])
def add_product_to_bookmark():
    try:
        product_id = request.args.get('product_id')
        user_id = request.args.get('user_id')
        
        bookmark_message = toggle_bookmark(product_id, user_id)
        
        response_data = {
            "success": True,
            "data": {
                "product_id": product_id,
                "bookmark_message": bookmark_message
            }
        }

        response = jsonify(response_data)
        response.status_code = 200
        return response
    except Exception as e:
        logging_handler.logger.info(e)
        return jsonify({"error": str(e)}), 500 

@app.route('/product/bookmark/check', methods=['GET'])
def check_book_marked():
    try:
        product_id = request.args.get('product_id')
        user_id = request.args.get('user_id')

        product_bookmarked = check_bookmarks_for_product(product_id, user_id)

        response_data = {
            "success": True,
            "data": {
                "product_id": product_id,
                "product_bookmarked": product_bookmarked
            }
        }

        response = jsonify(response_data)
        response.status_code = 200
        return response
    except Exception as e:
        print(e)
        return jsonify({"error": str(e)}), 500 

@app.route('/product/algolia/add', methods=['POST'])
def add_product_to_algolia():
    try:
        product_id = request.args.get('product_id')

        algolia_manager.sync_to_algolia_in_batches()

        response_data = {
            "success": True,
            "data": {
                "product_id": product_id
            }
        }

        response = jsonify(response_data)
        response.status_code = 200
        return response
    except Exception as e:
        print(e)
        return jsonify({"error": str(e)}), 500 

@app.route('/product/algolia/update', methods=['PUT'])
def update_product_in_algolia():
    try:
        product_id = request.json.get('product_id')
        product_name = request.json.get('product_name')

        algolia_manager.update_algolia_item(product_id, { "name": product_name })
        response_data = {
            "success": True,
            "data": {
                "product_id": product_id
            }
        }

        response = jsonify(response_data)
        response.status_code = 200
        return response
    except Exception as e:
        print(e)
        return jsonify({"error": str(e)}), 500 

@app.route('/product/algolia/delete', methods=['DELETE'])
def delete_product_from_algolia():
    product_id = request.args.get('product_id')

    try:
        algolia_manager.delete_algolia_item(product_id)
        response_data = {
            "success": True,
            "data": {
                "product_id": product_id
            }
        }

        response = jsonify(response_data)
        response.status_code = 200
        return response
    except Exception as e:
        print(e)
        return jsonify({"error": str(e)}), 500 

@app.route('/product/variants', methods=['GET'])
def get_product_variant():
    product_id = request.args.get('product_id')

    def convert_objectids(item):
        item['_id'] = str(item['_id'])
        item['productId'] = str(item['productId'])
        return item

    try:
        productVariants = list(productVariant.find({"productId": ObjectId(product_id)}))
        product_variants = [convert_objectids(item) for item in productVariants]

        data = {
            "message": "Success response",
            "product_variants": product_variants
        }

        response_data = {
            "success": True,
            "data": data
        }

        print("product variants=======")
        print(product_variants)

        response = jsonify(response_data)
        response.status_code = 200
        return response
    except Exception as e:
        print(e)
        return jsonify({"error": str(e)}), 500 

@app.route('/product/images', methods=['GET'])
def get_product_images():
    product_id = request.args.get('product_id')

    def get_image_by_id(product_id):
        product = productCollection.find_one({"_id": ObjectId(product_id)})
        return {"imageUrl": product['image']}

    try: 
        get_image_by_id(product_id)
        if not product_id:
            return jsonify({"error": "Product ID is required"}), 400

        images = [get_image_by_id(product_id)]

        data = {
            "message": "Success response",
            "images": images if len(images) > 0 else [{"imageUrl": "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse3.mm.bing.net%2Fth%3Fid%3DOIP.ug7mcOMWDCGNYWMVONgcgwHaE8%26pid%3DApi&f=1&ipt=1d65f51ac9670f196a7f095b3d1d343b800dbd6095143d4ecd8acc2d36080b97&ipo=images"}]
        }

        response_data = {
            "success": True,
            "data": data
        }

        response = jsonify(response_data)
        response.status_code = 200
        return response
    except Exception as e:
        print(e)
        return jsonify({"error": str(e)}), 500 

@app.route('/message/user/send', methods=['POST'])
def query_data():
    data = request.json
    user_query = data.get('text', '').lower()

    '''def process_search_string(user_query):
        char_array = re.split('[,\s]+', user_query.strip())

        return char_array

    def search_using_algolia(char_array):
        results_array = []

        for item in char_array:
            results = search_manager.search_algolia_product_index(item)

            if len(results) > 0:
                for result in results:
                    product_item = {
                        '_id': result.object_id,
                        'product_name': result.name,
                        'productImageUrl': result.image
                    }

                    results_array.append(product_item)

        return results_array

    def remove_duplicates_from_results(results_array):
        final_result = set()
        unique_products = []
        for product in results_array:
            if product['_id'] not in final_result:
                final_result.add(product['_id'])
                unique_products.append(product)

        return unique_products'''

    try:
        search_manager.search_ingredients_from_chroma(user_query)

        response_array = []
        nlp_response = "I found some items that might be relevant to your query"
        intent_render = "product"

        intent = search_manager.infer_intent(user_query)

        if isinstance(intent, str):
            intent = json.loads(intent)
        
        primary_item = intent['primary_item']

        print(intent["intent"])

        if (intent['intent'] == "ingredient"):
            print('ingredient')
            ingredients_result = search_manager.search_ingredients_from_chroma(primary_item)
            response_body = search_manager.format_ingredients_response(ingredients_result, user_query)
            nlp_response = response_body["nlp_response"]
            response_array = response_body["response_array"]
        else:
            print('search')
            char_array = search_manager.process_search_string(primary_item)
            results_array = search_manager.search_using_algolia(char_array)
            response_array = search_manager.remove_duplicates_from_results(results_array)
            nlp_response = "I found some items that might be relevant to your query"

        print(response_array)

        data = {
            "message": "Success response",
            "chatresponse": {
                "text": nlp_response,
                "results": response_array, #product_search_result
                "suggested_prompts": [],
                "isClient": False,
                "isRead": False,
                "intent_render": intent_render
            }
        }

        response_data = {
            "success": True,
            "data": data
        }
        
        response = jsonify(response_data)
        response.status_code = 200
        return response
    except Exception as e:
        print(e)
        return jsonify({"error": str(e)}), 500 
    
def initialize_app():
    with app.app_context():
        print('app is running now')
        excel_products_processor.run_data_processing()
        excel_ingredients_processor.process_excel()
        algolia_manager.sync_to_algolia_in_batches()

if __name__ == '__main__':
    app.debug = False
    
    initialize_app()
    
    app.run(
        host='0.0.0.0', 
        port=port,
        debug=False 
    )