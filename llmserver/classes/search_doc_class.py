import chromadb
import os
import pandas as pd
from datetime import datetime
from collections import defaultdict

from dotenv import load_dotenv
from openai import OpenAI

load_dotenv()

api_key = os.getenv('API_KEY')

openai = OpenAI(api_key=api_key)

current_dir = os.getcwd()

chroma_client = chromadb.Client()

collection_name = "test_collection"
product_collection = chroma_client.create_collection("products")
collection = chroma_client.get_or_create_collection(name=collection_name)

file_path = os.path.join(current_dir, "excelsheets", "PAYOOR_PRODUCTS.xlsx")

df = pd.read_excel(file_path)
all_items = []
grouped_products = defaultdict(list)

product_docs = []

query_text = "Vegetable/Spice"

for row in df.itertuples():
    doc = {
        'product_name': getattr(row, 'NAME', "N/A"),
        'unit': getattr(row, 'UNIT', "N/A"),
        'price': getattr(row, 'UNITPRICE', "1"),
    }

    all_items.append(doc)

for product in all_items:
    product_name = product['product_name']
    grouped_products[product_name].append(product)

for product_name, variants in grouped_products.items():
    product_data = {
        "product_name": product_name,
        "variants": variants
    }

    #product_docs.append(product_data)
    product_doc = {
        "id": product_name,
        "product_name": product_name,
    }


    product_collection.upsert(documents=[product_doc["product_name"]], ids=product_doc["id"])


def categorize_query_items(query_text, model="gpt-4o-mini"):
    system_prompt = '''
        Can you categorize each item according to food or grocery type
    '''
    
    response = openai.chat.completions.create(
        model=model,
        messages=[
            {"role": "system", "content": system_prompt},
            {"role": "user", "content": query_text}
        ],
        temperature=0,
        max_tokens=100
    )

    print(response.choices[0].message.content)

results = product_collection.query(
    query_texts=[query_text], 
    n_results=50
)

print(results)

#categorize_query_items(query_text)

#parsed_categories = categorize_query_items(query_text)
#Vegetable/Spice

#print(parsed_categories)

'''def pair_ids_and_docs(data):
    return {id_item: doc_item for id_item, doc_item in zip(data['ids'][0], data['documents'][0])}



query_text = "rice, eggs, beans, pepper, fish, stock fish"

results = product_collection.query(
    query_texts=[query_text], 
    n_results=50
)

result_mapping = pair_ids_and_docs(results)

print(result_mapping)

system_prompt = 
You are an expert at analyzing food item relevance.

For the given relevant items:
1. Categorize each item precisely
2. Explain why it matches the query
3. Provide additional context if applicable

Output Format:
- Item: [Original Item Name]
- Category: [Precise Food Category]
- Relevance Reason: [Why it matches]


response = openai.chat.completions.create(
    model="gpt-4o-mini",
    messages=[
        {
            "role": "system",
            "content": system_prompt
        },
        {
            "role": "user",
            "content": f"Relevant Items: {result_mapping}\nUser Query: {query_text}"
        }
    ],
    temperature=0,
    max_tokens=300
)

print(response.choices[0].message.content)'''