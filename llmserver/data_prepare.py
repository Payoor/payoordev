from pymongo import MongoClient, UpdateOne
from mongoose import UpdateOne, productCollection
from chroma_db import chromaProductCollection
from open_ai import model, ChatPromptTemplate, MessagesPlaceholder, StrOutputParser
import datetime

class DataPrepare:
   def get_items_without_description(self, limit=60):
       try:
           query = {
               "$or": [
                   {"generatedDescription": ""},
                   {"generatedDescription": {"$exists": False}}
               ]
           }
           items = list(productCollection.find(query).limit(limit))
           
           if not items:
               return [], "No items found without description"
               
               
           return items, f"Successfully retrieved first {limit} items without description"
           
       except Exception as e:
           return [], f"Error getting items: {str(e)}"

   def turn_details_to_plain_text(self, items):
    try:
        description_templates = []

        for item in items:
            description_template = ""
            
            for unit_data in item['data']:
                description_template += "-----------------\n"
                for key, value in unit_data.items():
                    if value is not None and value != '':
                        description_template += f"{key}: {value}\n"
                description_template += "-----------------\n"

            description_templates.append({
                "_id": item["_id"],
                "description_template": description_template,
            })

        return description_templates
    except Exception as e:
        return False, []

   def generate_description(self, unprocessed_descriptions):
    prompt = ChatPromptTemplate.from_messages([
                ("system", """
                    You are a professional inventory assistant. Your task is to process product information and convert it into a concise natural language format. Include all details clearly and accurately, maintaining a polished and professional tone.

                    For example:

                    input:
                        -----------------
                        NAME: Rice (long grain)
                        UNIT: De rica
                        PRICE PER UNIT: 1,919.00
                        AVAILABILITY: YES
                        -----------------
                        -----------------
                        NAME: Rice (long grain)
                        UNIT: half paint
                        PRICE PER UNIT: 4,960.00
                        AVAILABILITY: YES
                        -----------------

                        Output:
                        Long-grain rice is available in De rica for ₦1,919 and half paint for ₦4,960. Both sizes are in stock.

                """),
                ("user", unprocessed_descriptions)
            ])

    try:
        chain = (
        prompt 
        | model
        | StrOutputParser())

        result = chain.invoke({})
    
        return result
    except:
        return ""


   def generate_plaintext_description(self, items):
    items_array = []
    failed_items = [] 
   
    for item in items:
       try:
           product_data = {
               "_id": item["_id"],
               "natural_language_description": self.generate_description(item["description_template"]),
           }
           
           items_array.append(product_data)
       except Exception as e:
           print(e)
           failed_items.append({
               "_id": item["_id"],
               "error": str(e),
               "stage": "description_generation"
           })
           
    if not items_array:
       print("No items processed")
       self._save_failed_items(failed_items)
       return []
           
    try:
       documents = [item["natural_language_description"] for item in items_array]
       ids = [str(item["_id"]) for item in items_array]
       
       chromaProductCollection.upsert(
           documents=documents,
           ids=ids
       )
       print(f"Saved {len(documents)} descriptions to ChromaDB")
       
       bulk_operations = [
           UpdateOne(
               {"_id": item["_id"]},
               {"$set": {"generatedDescription": item["natural_language_description"]}}
           ) for item in items_array
       ]
       
       if bulk_operations:
           result = productCollection.bulk_write(bulk_operations)
           print(f"MongoDB bulk update: {result.modified_count} documents modified")
           
    except Exception as e:
       print(f"Error in database operations: {e}")
       for item in items_array:
           failed_items.append({
               "_id": item["_id"],
               "error": str(e),
               "stage": "database_operations"
           })
   
    if failed_items:
       self._save_failed_items(failed_items)
   
    return items_array

   def _save_failed_items(self, failed_items):
    try:
       timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
       filename = f"failed_items_{timestamp}.txt"
       
       with open(filename, 'w') as f:
           f.write("Failed Items Report\n")
           f.write("=================\n\n")
           
           for item in failed_items:
               f.write(f"ID: {item['_id']}\n")
               f.write(f"Error: {item['error']}\n")
               f.write(f"Stage: {item['stage']}\n")
               f.write("-" * 50 + "\n")
               
       print(f"Failed items saved to {filename}")
       
    except Exception as e:
       print(f"Error saving failed items to file: {e}")