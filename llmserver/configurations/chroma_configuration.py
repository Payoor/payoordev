import os
import chromadb
from openai import OpenAI
from chromadb.utils import embedding_functions

from dotenv import load_dotenv

load_dotenv()

api_key = os.getenv("OPENAI_API_KEY")

default_ef = embedding_functions.DefaultEmbeddingFunction()

openai_ef = embedding_functions.OpenAIEmbeddingFunction(
    api_key=api_key,
    model_name="text-embedding-3-small"
)

chroma_client = chromadb.PersistentClient()
