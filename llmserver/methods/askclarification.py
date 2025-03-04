import os
from dotenv import load_dotenv
from openai import OpenAI

load_dotenv()

api_key = os.getenv("API_KEY")

openai = OpenAI(api_key=api_key)

def askclarification(user_query: str) -> str:
    response = openai.chat.completions.create(
        model="gpt-4-turbo",
        messages=[
            {"role": "system", "content": "You are a helpful grocery shopping assistant. The user has made an ambiguous request. Generate a clarifying question to better understand their needs. Keep it concise and friendly. Make sure to steer the conversation towards grocery shopping"},
            {"role": "user", "content": user_query}
        ],
        temperature=0.7,
        max_tokens=100
    )
    
    clarification = response.choices[0].message.content.strip()
    
    return clarification