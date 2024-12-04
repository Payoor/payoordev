import chromadb
#import chromadb.utils.embedding_functions as embedding_functions
from chromadb.utils.embedding_functions import SentenceTransformerEmbeddingFunction

import os
from dotenv import load_dotenv

load_dotenv()

chroma_client = chromadb.PersistentClient(path="chroma_persistent_storage")

collection_name = "product_collection"

api_key = os.getenv('OPENAI_API_KEY')

embedding_function = SentenceTransformerEmbeddingFunction()

chromaProductCollection = chroma_client.get_or_create_collection(
    name=collection_name, embedding_function=embedding_function
)