import os
import chromadb
from chromadb.utils.embedding_functions import SentenceTransformerEmbeddingFunction
from langchain.text_splitter import (
    RecursiveCharacterTextSplitter,
    SentenceTransformersTokenTextSplitter,
)

embedding_function = SentenceTransformerEmbeddingFunction()

chroma_client = chromadb.Client()
chroma_collection = chroma_client.create_collection(
    "product-collection", embedding_function=embedding_function
)

from utils import Utils

def save_data_experimemt(directory_path, file_name):
    data_dict = Utils.excel_to_dict(directory_path, file_name)
    final_data = Utils.process_excel_data(data_dict)

    character_splitter = RecursiveCharacterTextSplitter(
        separators=["\n\n", "\n", ". ", " ", ""], chunk_size=1000, chunk_overlap=0
    )

    descriptions = [] 

    for name, data in final_data.items():
        #print(f"\n{name}:")
        generatedDescription = Utils.create_text_from_data(data)
        descriptions.append(generatedDescription) 
        #print(generatedDescription)

    character_split_texts = character_splitter.split_text("\n\n".join(descriptions))

    token_splitter = SentenceTransformersTokenTextSplitter(
        chunk_overlap=0, tokens_per_chunk=256
    )

    token_split_texts = []
    for text in character_split_texts:
        token_split_texts += token_splitter.split_text(text)

    ids = [str(i) for i in range(len(token_split_texts))]

    chroma_collection.add(ids=ids, documents=token_split_texts)
    count = chroma_collection.count()

    query = "cake, rice, eggs, chicken, goat meat, tomatoes"

    results = chroma_collection.query(
        query_texts=query, n_results=5, include=["documents", "embeddings"]
    )

    retrieved_documents = results["documents"][0]

    print(retrieved_documents)
    
    #retrieved_documents = results["documents"]

    """relevance = Utils.figure_out_relevance(query, retrieved_documents, display=[{
        "product_name": "",
        "price": 20,
        "quantity": 10,
        "details": "available sizes : 1 carton', 'product : crayfish category : available sizes : 50g ( 1 milk cup ), 150g ( 1 derica )",
        "total": 200
    }])

    print(relevance)"""

#save_data_experimemt(os.getcwd(), "payoorproduct.xlsx")




















"""from flask import Flask, request, jsonify, session
from dotenv import load_dotenv
from langchain_openai import ChatOpenAI
from flask_cors import CORS
from langchain.schema import AIMessage, HumanMessage, SystemMessage
from langchain.prompts import ChatPromptTemplate, MessagesPlaceholder
from langchain.schema.output_parser import StrOutputParser
from langchain.schema.runnable import RunnableParallel, RunnableLambda
from langchain.memory import ChatMessageHistory
from uuid import uuid4
import os
import secrets
from typing import List, Dict, Tuple






from llmspecific import InputClassifier
from mongodb_module import vectorise_product_details, get_items_by_ids, create_vector_text, add_product
from cleanup_excel_doc import excel_to_dict, process_excel_data
from chromadb_module import openai_ef, chroma_client

exceldb = excel_to_dict(os.getcwd(), "payoorproduct.xlsx")

app = Flask(__name__)
port = int(os.getenv('PORT', 8084))

app.secret_key = secrets.token_hex(16)

load_dotenv()





vectorise_product_details()








exceldb = excel_to_dict(os.getcwd(), "payoorproduct.xlsx")

final_data = process_excel_data(exceldb)

for name, data in final_data.items():
    #print(f"\n{name}:")
    generatedDescription = create_vector_text(data)
    print(generatedDescription)
    add_product(data, generatedDescription)

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
            "allow_headers": ["Content-Type", "Authorization", "Session-ID"],
            "supports_credentials": True,
            "expose_headers": ["Content-Range", "X-Content-Range"]
        }
     })

model = ChatOpenAI(model="gpt-4")

sessions = {}

@app.route('/start-session', methods=['POST'])
def start_session():
    session_id = str(uuid4())
    sessions[session_id] = {
        'history': ChatMessageHistory(),
        'order_id': str(uuid4())[:8]
    }
    return jsonify({'session_id': session_id})


@app.route('/message/user/send', methods=['POST'])
async def get_user_message():
    session_id = request.headers.get('Session-ID')

    if not session_id:
        return jsonify({'error': 'Missing session ID'}), 401
     
    
    data = request.json
    user_input = data.get('text', '').lower()
    current_items = data.get('currentItems', '')
    
    #session['user_id'] = session_id

    #print(session['user_id'])
    
    if not user_input:
        return jsonify({'error': 'Missing session_id or message'}), 400
    
    try:
        collection = chroma_client.get_or_create_collection(name="products")
        classifier = InputClassifier()

        query_embeddings = openai_ef([user_input])
        query_results = collection.query(
            query_embeddings=query_embeddings,
            n_results=10
        )

        #print(query_results['ids'][0])
        #print(query_results['documents'][0])
        product_ids = query_results['ids'][0]
        
        products_documents = await get_items_by_ids(product_ids)
        print(products_documents)

        if current_items:
        
            await classifier.classify_and_route(user_input, current_items)
        else:
            await classifier.search_products(user_input)

        await classifier.search_products(user_input)


        if session.get('user_id') is None:
            print("user_id is null") 

        response_data = {
            "success": True,
            "data": {
                "message": "Success response",
                "chatresponse": {
                    "text": "testing ai",
                    "results": products_documents,
                    "isClient": False,
                    "isRead": False
                }
            }
        }
        
        response = jsonify(response_data)
        response.status_code = 200
        return response

    except Exception as e:
        print(e)
        return jsonify({'error': str(e)}), 500

@app.route('/end-session', methods=['POST'])
def end_session():
    data = request.json
    session_id = data.get('session_id')
    
    if not session_id:
        return jsonify({'error': 'Missing session_id'}), 400
    
    if session_id not in sessions:
        return jsonify({'error': 'Invalid session_id'}), 404
    
    del sessions[session_id]
    return jsonify({'message': 'Session ended successfully'})

if __name__ == '__main__':
    app.run(
        host='0.0.0.0', 
        port=port,      
        debug=True     
    )
"""