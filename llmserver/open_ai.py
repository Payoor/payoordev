import os
from openai import OpenAI
from dotenv import load_dotenv
from langchain_openai import ChatOpenAI
from langchain.prompts import ChatPromptTemplate, MessagesPlaceholder
from langchain.schema.runnable import RunnableParallel, RunnableLambda
from langchain.schema.output_parser import StrOutputParser
from langchain.schema.runnable import RunnableParallel, RunnableLambda
from openai import OpenAI

load_dotenv()

openai_key = os.getenv('OPENAI_API_KEY')
openai_client = OpenAI(api_key=openai_key)
model = ChatOpenAI(model="gpt-4o")