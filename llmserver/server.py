from flask import Flask, request, jsonify
import os
from dotenv import load_dotenv
from werkzeug.utils import secure_filename
from flask_cors import CORS
from apscheduler.schedulers.background import BackgroundScheduler
from datetime import datetime
import logging
import schedule
import time
from threading import Timer

from chromadb.utils.embedding_functions import SentenceTransformerEmbeddingFunction

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

from data_upload import DataUpload
from data_prepare import DataPrepare
from data_use import DataUse
from cart_module import CartModule
from order_module import OrderModule

load_dotenv()

app = Flask(__name__)
port = int(os.getenv('PORT', 8084)) 

ALLOWED_ORIGINS = [
    'https://chat.payoor.store',
    'https://admin.payoor.store',
    'https://admin.development.payoor.store',
    'https://chat.development.payoor.store',
    'https://chat.development.payoor.store',
    'http://localhost:63882'
]

CORS(app, 
     resources={
        r"/*": {
            "origins": ALLOWED_ORIGINS,
            "methods": ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
            "allow_headers": ["Content-Type", "Authorization", "Session-ID"],
            "supports_credentials": True,
            "expose_headers": ["Content-Range", "X-Content-Range"]
        }
     })

dtupload = DataUpload()
data_prep = DataPrepare()
data_use = DataUse()
cart_module = CartModule()
order_module = OrderModule()

UPLOAD_FOLDER = 'uploads'

if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)

app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER


"""
put these in a cron job

items, message = data_prep.get_items_without_description()
description_templates = data_prep.turn_details_to_plain_text(items)
plain_text_descriptions = data_prep.generate_plaintext_description(description_templates)
"""

def run_once():
   Timer(120.0, schedule_data_update).start()

def schedule_data_update():
    items, message = data_prep.get_items_without_description()
    description_templates = data_prep.turn_details_to_plain_text(items)
    #print(description_templates)
    plain_text_descriptions = data_prep.generate_plaintext_description(description_templates)
    print(plain_text_descriptions)

"""scheduler = BackgroundScheduler()
scheduler.add_job(func=schedule_data_update, trigger="interval", hours=5)
scheduler.start()"""

#schedule_data_update()

run_once()

@app.route('/admin/upload/products/excel', methods=['POST'])
def upload_excel():
    try:
        if 'file' not in request.files:
            return jsonify({'error': 'No file part'}), 400

        file = request.files['file']
        if file.filename == '':
            return jsonify({'error': 'No selected file'}), 400

        if file and dtupload.allowed_file(file.filename):
            filename = secure_filename(file.filename)
            filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
            
            try:
                file.save(filepath)
            except IOError as e:
                return jsonify({'error': f'Failed to save file: {str(e)}'}), 500

            try:
                cleaned_records = dtupload.excel_to_dict(filepath)
                final_data = dtupload.process_excel_data(cleaned_records)
                plain_text = dtupload.convert_to_plaintext(final_data)
                
                success, message = dtupload.save_to_mongodb_database(plain_text)
                
                if success:
                    return jsonify({
                        'message': 'File processing completed',
                        'details': message
                    }), 200
                else:
                    return jsonify({
                        'error': 'Database operation failed',
                        'details': message
                    }), 500
                
            except Exception as e:
                return jsonify({
                    'error': 'Processing error',
                    'details': str(e)
                }), 500
            
            finally:
                try:
                    os.remove(filepath)
                except:
                    print("clean up failed")
                    
        return jsonify({'error': 'Invalid file type'}), 400
        
    except Exception as e:
        return jsonify({
            "error": "Server error",
            "details": str(e)
        }), 500

@app.route('/message/user/cartdetails', methods=['POST'])
def query_cart():
    try:
        data = request.json
        user_cart = data.get('cart')

        print(user_cart)

        response_data = {
            "success": True,
            "data": 'data'
        }

        cart_summary = cart_module.generate_cart_summary(user_cart)

        print(cart_summary)

        data = {
                "message": "Success response",
                "chatresponse": {
                    "text": cart_summary,
                    "isClient": False,
                    "isRead": False
                }
            }

        print(data)

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

@app.route('/message/user/getorderdetails', methods=['GET'])
def query_order_details():
    try:
        order_reference = request.args.get('orderReference')
        if not order_reference:
            return jsonify({"error": "orderReference is required"}), 400

        current_order = order_module.get_order_by_reference(order_reference)

        order_summary_naturallanguage = order_module.get_order_summary_natural_language(current_order)

        #print(order_summary_naturallanguage)

        data = {
                "message": "Success response",
                "chatresponse": {
                    "text": order_summary_naturallanguage
                }
            }

        #print(data)

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

@app.route('/product/images', methods=['GET'])
def get_product_images():
    try:
        product_id = request.args.get('product_id')

        if not product_id:
            return jsonify({"error": "Product ID is required"}), 400

        images = data_use.get_product_images(product_id)

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
    try:
        data = request.json
        user_query = data.get('text', '').lower()
        current_items = data.get('currentItems', '')

        success, raw_results, formatted, results_texts = data_use.query_products_from_chroma(user_query)
        raw_results_item_ids = raw_results["ids"][0]

        found_items_by_id = data_use.get_items_from_mongodb_by_id(raw_results_item_ids)

        '''query_relevance = data_use.judge_query_relevance(user_query, formatted)'''

        #generated_suggested_prompts = data_use.generate_suggested_prompt(results_texts)

        #print(generated_suggested_prompts)

        #suggested_prompts = data_use.clean_up_generated_prompts_list(generated_suggested_prompts)
        #print(suggested_prompts)

        data = {
                "message": "Success response",
                "chatresponse": {
                    "text": "I found some items that might be relevant to your query",
                    "results": found_items_by_id,
                    "suggested_prompts": [],
                    "isClient": False,
                    "isRead": False
                }
            }

        #print(data)

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

if __name__ == '__main__':
    app.run(
        host='0.0.0.0', 
        port=port,      
        debug=True     
    )