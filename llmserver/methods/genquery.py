import os
from dotenv import load_dotenv
from openai import OpenAI

# Load environment variables
load_dotenv()

# Get API key from .env
api_key = os.getenv("API_KEY")

# Initialize OpenAI client
openai = OpenAI(api_key=api_key)

def genquery(query_text):
    response = openai.chat.completions.create(
        model="gpt-4o-mini",
        messages=[
            {
                "role": "system",
                "content": (
                    "You are a Nigerian grocery shopping assistant. Your task is to return ONLY a "
                    "comma-separated list of grocery items based on the user's query.\n\n"
                    "Instructions:\n"
                    "1. Analyze the user's query to understand what Nigerian food items or ingredients they need.\n"
                    "2. Output ONLY the list of food items, with no explanations, greetings, or additional text.\n"
                    "3. Separate each item with a comma.\n"
                    "4. Include quantities if specified in the query, otherwise just list the items.\n"
                    "5. Focus on Nigerian staples and ingredients when appropriate.\n\n"
                    "Examples:\n"
                    'User: "I want to make jollof rice"\n'
                    "Response: rice, tomatoes, onions, red bell peppers, scotch bonnet peppers, "
                    "vegetable oil, curry powder, thyme, bay leaves, salt, chicken stock\n\n"
                    'User: "I need breakfast items"\n'
                    "Response: eggs, bread, akara ingredients, pap ingredients, yam, plantain, beans, tea, sugar"
                ),
            },
            {"role": "user", "content": query_text},
        ],
        temperature=0,
        max_tokens=100,
    )

    # Extract response content
    query = response.choices[0].message.content.strip()
    return query
