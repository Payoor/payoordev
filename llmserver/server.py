import os
from dotenv import load_dotenv
from openai import OpenAI

from flask import Flask, jsonify, request
from flask_cors import CORS

import nigerian_groceries

app = Flask(__name__)

load_dotenv()

#print(nigerian_groceries)

api_key = os.getenv('API_KEY')
port = int(os.getenv('PORT', 8084))

openai = OpenAI(api_key=api_key)

ALLOWED_ORIGINS = [
    'https://chat.payoor.shop',
    'https://admin.payoor.shop',
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
            "allow_headers": ["Content-Type", "Authorization"],
            "supports_credentials": True,
            "expose_headers": ["Content-Range", "X-Content-Range"]
        }
     })

GROCERY_SYSTEM_PROMPT = """
    You are a helpful shopping assistant that processes user-provided lists and checks availability. Follow these strict interaction rules:

    1. WAIT for the user to provide their list first - never create lists for them.

    2. Check each item against the available items in 

""" + str(nigerian_groceries.nigeria_groceries) + """ 
    Clearly indicate which items are available
    Create a price in naira for each available item
    Format responses in an organized, easy-to-read manner

    3. For unavailable items:

        Explicitly identify which items are not available
        Ask if the user would like alternative suggestions
        Only provide alternatives if user confirms

    4. After availability and pricing are discussed:

       Calculate total price for available items
       Ask if user would like to proceed with payment

        Important guidelines:

        Always let the user drive the list creation
        Never assume items or add to their list
        Be explicit about availability status for each item
        Keep responses structured and clear
        Always confirm before proceeding to payment

        Follow this sample interaction format stricty and make strictly sure everything totals 500 naira:
        User: [Provides list]
        You: "I've checked availability for your items:
        Available:

        [Item 1] - [Price]
        [Item 2] - [Price]

        Not Available:

        [Item 3]
        [Item 4]

        Total: Total of Available items 

        Tell me if you'd like to see alternatives to unavailable items or you can simply tap this message to make payment for the available items
"""

@app.route('/')
def home():
    return 'Welcome to the Python Server!'

@app.route('/message/user/send', methods=['POST'])
def get_user_message():
    if not request.is_json:
        return jsonify({
            "error": "Content-Type must be application/json"
        }), 400

    data = request.get_json()

    message = data.get('text')

    if not message:
        return jsonify({
            "error": "text field is required and cannot be empty"
        }), 400

    messages = [
        {"role": "system", "content": GROCERY_SYSTEM_PROMPT},
        {"role": "user", "content": message}
    ]

    ai_response = openai.chat.completions.create(
        model = "gpt-4o-mini",
        messages = messages
    )

    response_content = ai_response.choices[0].message.content
    
    response_data = {
        "success": True,
        "data": {
            "message": "Success response",
            "chatresponse": {
                "text": response_content,
                "isClient": False,
                "isRead": False
            }
        }
    }
    
    response = jsonify(response_data)
    response.status_code = 200
    return response


if __name__ == '__main__':
    app.run(
        host='0.0.0.0', 
        port=port,      
        debug=True     
    )
