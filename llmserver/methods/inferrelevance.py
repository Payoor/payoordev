import os
from dotenv import load_dotenv
from openai import OpenAI

# Load environment variables
load_dotenv()

# Get API key from .env
api_key = os.getenv("API_KEY")

# Initialize OpenAI client
openai = OpenAI(api_key=api_key)

def inferrelevance(query_response: str) -> str:
    """Determines if a text is relevant to a grocery shopping query."""
    response = openai.chat.completions.create(
        model="gpt-4-turbo", 
        messages=[
            {"role": "system", "content": "How relevant is this text to food and groceries? Respond with 'relevant' or 'not relevant'. "},
            {"role": "user", "content": query_response}
        ],
        temperature=0,
        max_tokens=10
    )
    
    content = response.choices[0].message.content.strip().lower()
    
    return content

