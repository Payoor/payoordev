from flask import Flask, request, jsonify
import os
import re
import json
import ast

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
from classes.nigerian_training import NigerianGrocerySearch

load_dotenv()

app = Flask(__name__)
port = int(os.getenv('PORT')) 

if app.debug or os.environ.get('FLASK_ENV') == 'development':
    CORS(app, resources={
        r"/*": {
            "origins": ["http://localhost:63882"],  # Updated to match your frontend port
            "methods": ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
            "allow_headers": [
                "Content-Type",
                "Authorization",
                "session-id"  # Added session-id header
            ],
            "expose_headers": ["session-id"]  # Allow the header to be exposed to the client
        }
    })

logging_handler = LoggingHandler(__name__ )
algolia_manager = AlgoliaManager()
excel_products_processor = PayoorExcelProductsDataProcessor()
excel_ingredients_processor = PayoorExcelIngredientsProcessor()
search_manager = SearchManager()
search_engine = NigerianGrocerySearch()


UPLOAD_FOLDER = 'uploads'

if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)

app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

def split_at_last_space(text):
    if ' ' in text:
        last_space_index = text.rindex(' ')
        before = text[:last_space_index]
        after = text[last_space_index + 1:]
        
        return {
            "name": before,
            "tags": after
        }
        
    return {
        "name": text,
        "tags": ""
    }

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

@app.route('/product/get', methods=['GET'])
def get_product():
    product_name = request.args.get('productname')
    if not product_name:
        return {'error': 'Product name is required'}, 400

    try:
        product = search_manager.search_product_in_mongodb(product_name)

        if product != None:
            product['_id'] = str(product['_id']) 
        else:
            print("fuck!!")
            print(product_name)

        data = {
            "message": "Success response",
            "product_data": product
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

@app.route('/products/suggestion/get', methods=['GET'])
def get_by_suggestion():
    suggestion = request.args.get('suggestion')
    
    if not suggestion:
        return {'error': 'suggestion is required'}, 400

    try:
        search_results = []
        results = search_engine.search(suggestion)
        
        for item, score in results:
            print(split_at_last_space(item))
            name_tags = split_at_last_space(item)
            print(score)
            search_results.append(name_tags)

        data = {
            "message": "Success response",
            "results": search_results,
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

    try:
        response_array = []
        nlp_response = "I found some items that might be relevant to your query"
        intent_render = "product"

        print(user_query)

        analysis = search_manager.analyze_text(user_query)
        analysis_query = analysis["other_words"]
        print(analysis["other_words"])
        #print(search_manager.format_results(analysis))

        search_queries = search_engine.parse_query(analysis_query)

        search_results = []
        result_tags = []

        print(search_queries)
        for query in search_queries:
            result_tags.append(query)

        results = search_engine.search(search_queries[0])
        
        for item, score in results:
            print(split_at_last_space(item))
            name_tags = split_at_last_space(item)
            print(score)
            search_results.append(name_tags)
            #result_tags.append(name_tags['tags'])

        print(search_results)
    
        data = {
            "message": "Success response",
            "chatresponse": {
                "text": nlp_response,
                "results": search_results,
                "result_tags": result_tags,
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
        excel_products_processor.process_excel_and_add_to_mongodb()

if __name__ == '__main__':
    app.debug = False
    
    #initialize_app()
    
    app.run(
        host='0.0.0.0', 
        port=port,
        debug=False 
    )