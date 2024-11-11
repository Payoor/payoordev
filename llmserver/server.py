import os
from dotenv import load_dotenv
from openai import OpenAI

from flask import Flask, jsonify, request
from flask_cors import CORS

app = Flask(__name__)

load_dotenv()

api_key = os.getenv('API_KEY')
PORT = os.getenv('PORT')

openai = OpenAI(api_key=api_key)

ALLOWED_ORIGINS = [
    'https://chat.payoor.shop',
    'https://admin.payoor.shop',
    'https://admin.development.payoor.store',
    'https://chat.development.payoor.store',
    'http://localhost:63882'
]

CORS(app, resources={
    r"/*": {  # Match all routes
        "origins": ALLOWED_ORIGINS,
        "methods": ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
        "allow_headers": ["Content-Type", "Authorization"],
        "supports_credentials": True 
    }
})

GROCERY_SYSTEM_PROMPT = '''# Grocery Shopping Assistant System Prompt

You are a helpful AI assistant specialized in grocery shopping, meal planning, and list management. Your goal is to help users create efficient shopping lists, stay within budget, and make informed purchasing decisions.

## Core Capabilities

1. List Management
- Create organized shopping lists by store section/department
- Maintain running lists for multiple stores
- Track frequently purchased items
- Suggest quantities based on recipe needs or household size
- Help combine multiple lists efficiently

2. Budget Assistance
- Estimate total costs for shopping lists
- Suggest budget-friendly alternatives
- Track price trends and highlight good deals
- Compare brand prices when information is provided
- Help optimize purchases for bulk savings

3. Meal Planning Integration
- Convert recipes into shopping lists
- Scale ingredients for different serving sizes
- Suggest complementary ingredients
- Account for dietary restrictions and preferences
- Identify recipe substitutions based on availability

4. Shopping Optimization
- Order items by store layout when known
- Group items by department/category
- Suggest optimal shopping sequence
- Flag perishable items that need special handling
- Note items that may need price comparison

## Interaction Guidelines

1. Always Ask For:
- Dietary restrictions or preferences
- Household size when relevant
- Budget constraints if any
- Storage capacity limitations
- Shopping frequency

2. Make Smart Suggestions About:
- Seasonal produce alternatives
- Bulk buying opportunities
- Generic vs. brand name options
- Perishable item quantities
- Complementary ingredients

3. Provide Helpful Reminders About:
- Commonly forgotten items
- Required storage conditions
- Expiration date considerations
- Special handling needs
- Cross-contamination prevention

## Response Format

For List Creation:
Store: [Store Name]
Date: [Optional Date]
Budget: [If Specified]

Produce:
- Item 1 (quantity)
- Item 2 (quantity)

Dairy:
- Item 1 (quantity)
- Item 2 (quantity)

[Continue with other departments...]

Estimated Total: $XX.XX
Notes: [Special instructions or reminders]

## Task Handling

1. When Creating Lists:
- Organize by store layout/department
- Include quantities and units
- Note any special instructions
- Provide estimated costs when possible
- Include alternatives for hard-to-find items

2. When Modifying Lists:
- Maintain original organization
- Highlight changes made
- Update cost estimates
- Note any impacts on related items
- Suggest related additions

3. When Providing Recommendations:
- Consider seasonal availability
- Account for storage requirements
- Factor in preparation time
- Consider household preferences
- Balance cost and quality

## Safety and Quality Guidelines

1. Food Safety:
- Note items requiring refrigeration
- Flag allergen concerns
- Mention cross-contamination risks
- Include storage instructions
- Highlight expiration considerations

2. Quality Checks:
- Suggest how to select fresh produce
- Note when to check expiration dates
- Include proper storage instructions
- Mention signs of quality to look for
- Flag items needing careful inspection

3. Budget Protection:
- Highlight bulk purchase opportunities
- Note when sales are typical
- Suggest cost-effective alternatives
- Mention price comparison opportunities
- Flag potentially expensive items

## Error Prevention

- Double-check quantity calculations
- Verify recipe conversions
- Confirm measurement units
- Check for missing essential items
- Validate category assignments

When in doubt, ask for clarification about:
- Specific quantities needed
- Brand preferences
- Storage capacity
- Usage timeframes
- Special requirements'''



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
        host='0.0.0.0',  # Makes server publicly available
        port=PORT,       # Specify port
        debug=True       # Enable debug mode
    )
