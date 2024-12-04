import os
from pymongo import MongoClient
import pandas as pd
from pathlib import Path
from dotenv import load_dotenv
from typing import List
from bson import ObjectId
from langchain_openai import ChatOpenAI
from langchain.prompts import ChatPromptTemplate, MessagesPlaceholder
from langchain.schema.runnable import RunnableParallel, RunnableLambda
from langchain.schema.output_parser import StrOutputParser
from openai import OpenAI

load_dotenv()

openai_key = os.getenv('OPENAI_API_KEY')
mongo_url = os.getenv('MONGO_URL')

openai_client = OpenAI(api_key=openai_key)
model = ChatOpenAI(model="gpt-4")


client = MongoClient(mongo_url)
dbname = str(os.getenv('DB_NAME'))
db = client[dbname] 
productCollection = db['products']

class Utils:
    messages = []

    @staticmethod
    def get_items_from_mongodb(relevant: str) -> list:
        items = []
        
        for line in relevant.split('\n'):
            if line.strip() and line[0].isdigit():
                name = line.split('.')[1].split('-')[0].strip()
                items.append(name)
        return items

    @staticmethod
    def format_response(response):
        template = ChatPromptTemplate.from_messages([
            ("system", "Turn this response into a user friendly response"),
            ("human", "{response}"),
        ])

        formatted_prompt = template.format_prompt(response=response)
        
        return formatted_prompt.to_string()

    @staticmethod
    def figure_out_relevance(query, query_result, display=[], cart=[], model=model):
        if len(cart) > 0 and len(display) > 0:
            print("display if full")
        if len(cart) > 0:
            print("cart is full")
        if len(display) > 0:
            print("display is full")
        else:
            prompt = ChatPromptTemplate.from_messages([
                ("system", """
                    You are an expert grocery data analyst. 
                    Analyze product information to determine which items precisely match the customer's search query, 
                    and tell the user what you found or didn't find considering product names

                    for example: I found some items relevant to your query, then list the unavailable items, by stating, but couldn't find anything relevant to these items

                    however we can source the unavailabke items for you
                """),
                ("user", "What parts of {query_result} are relevant to: {query}")
            ])

            chain = (
                prompt 
                | model
                | StrOutputParser()
            )

            result = chain.invoke({
                "query_result": query_result,
                "query": query
            })

            Utils.messages.append({
               "query": query,
               "result": result
            })

            return result

    @staticmethod
    def excel_to_dict(directory_path, file_name):
        try:
            file_path = Path(directory_path) / file_name
            
            df = pd.read_excel(file_path)
            df.columns = df.columns.astype(str)
            records = df.to_dict('records')
            
            cleaned_records = []
            for record in records:
                cleaned_record = {}
                for key, value in record.items():
                    if pd.isna(value):
                        cleaned_record[key] = None
                    elif isinstance(value, pd.Timestamp):
                        cleaned_record[key] = value.strftime('%Y-%m-%d %H:%M:%S')
                    else:
                        cleaned_record[key] = value
                cleaned_records.append(cleaned_record)
                
            return cleaned_records
            
        except FileNotFoundError:
            raise FileNotFoundError(f"Excel file '{file_name}' not found in directory '{directory_path}'")
        except Exception as e:
            raise Exception(f"Error processing Excel file: {str(e)}")
    
    @staticmethod
    def process_excel_data(exceldb):
        def group_by_name(items):
            groups = {}
            
            for item in items:
                name = item['NAME']
                if name in groups:
                    groups[name].append(item)
                else:
                    groups[name] = [item]
                
            return groups

        def restructure_group(items):
            if not items or len(items) == 0:
                return None
                
            result = {
                'NAME': items[0]['NAME'],
                'PRICE PER UNIT': [],
                'UNIT': [],
                'AVAILABILITY': []
            }
            
            for item in items:
                if item['PRICE PER UNIT'] is not None:
                    cleaned_price = item['PRICE PER UNIT'].replace('₦', '').replace(' ', '').replace(',', '')
                else:
                    cleaned_price = '0'
                    
                result['PRICE PER UNIT'].append(cleaned_price)
                result['UNIT'].append(item['UNIT'].strip() if item['UNIT'] else '')
                result['AVAILABILITY'].append(item['AVAILABILITY'])
                
            return result

        def restructure_all_groups(grouped_items):
            restructured_data = {}
            
            for name, group in grouped_items.items():
                restructured_data[name] = restructure_group(group)
                
            return restructured_data

        grouped_items = group_by_name(exceldb)
        final_data = restructure_all_groups(grouped_items)
        
        return final_data

    @staticmethod
    def create_text_from_data(data: dict) -> str:
        name = data['NAME'].strip()
        units = ', '.join(data['UNIT'])
        
        category = name.split('-')[-1].strip() if '-' in name else ''
        
        data_text = f"product: {name} category: {category} available sizes: {units}"
        
        return data_text

    @staticmethod
    async def get_mongo_items_by_ids(ids: List[str]) -> List[dict]:
        try:
            object_ids = [ObjectId(id_str) for id_str in ids]
            documents = list(productCollection.find({'_id': {'$in': object_ids}}))
            for doc in documents:
                doc['_id'] = str(doc['_id'])
                
            return documents
        except Exception as e:
            print(f"Error fetching documents: {str(e)}")
            return []