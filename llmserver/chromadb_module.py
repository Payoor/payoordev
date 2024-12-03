import chromadb
import chromadb.utils.embedding_functions as embedding_functions
import os
from dotenv import load_dotenv

load_dotenv()

chroma_client = chromadb.Client()

api_key = os.getenv('OPENAI_API_KEY')

openai_ef = embedding_functions.OpenAIEmbeddingFunction(
    api_key=api_key,
    model_name="text-embedding-3-small"
)

collection = chroma_client.get_or_create_collection(name="products")

def create_vector_and_save(item: str, itemid: str) -> None:
    print(item)
    print(itemid)
    vectors = openai_ef([item])
    
    collection.add(
        documents=[item],
        ids=[itemid],
        embeddings=vectors
    )
    print("done")

