import os
import pandas as pd
from datetime import datetime

from configurations.mongoose_configuration import foodmodelsCollection 
from classes.algolia_class import AlgoliaManager
from classes.logginghandler_class import LoggingHandler
from configurations.chroma_configuration import chroma_client, openai_ef

class PayoorExcelIngredientsProcessor:
    def __init__(self):
        self.logger = LoggingHandler(__name__)

        self.current_dir = os.getcwd()
        self.file_path = os.path.join(self.current_dir, "excelsheets", "PAYOOR_INGREDIENTS.xlsx")
        self.collectionName = "ingredient_collection"
        self.algolia_manager = AlgoliaManager()
        self.collection = chroma_client.get_or_create_collection(name=self.collectionName, embedding_function=openai_ef)

    def add_ingredient_to_mongodb(self, ingredient):
        result = foodmodelsCollection.insert_one(ingredient)
        return result.inserted_id

    def run_data_processing(self):
        print('running fata processing Ingredients')

    def process_excel(self):
        try:
            df = pd.read_excel(self.file_path)

            all_items = []
            
            for row in df.itertuples():
                item = {
                    'nameOfFood': getattr(row, 'Name', "N/A"),
                    'ingredients': getattr(row, 'Ingredient', "N/A"),
                    'estimatedCookingTime': getattr(row, 'CookingTime', "N/A"),
                }

                food_id = self.add_ingredient_to_mongodb(item)
                item["id"] = food_id.__str__()

                all_items.append(item)

            #print(all_items)
            for doc in all_items:
                self.collection.upsert(
                    documents=[doc.get("nameOfFood", "")],
                    ids=doc.get("id", "")
                )
                self.algolia_manager.add_ingredient_to_algolia({
                    'objectID': doc['id'],
                    'ingredients': doc.get("ingredients", "")
                })

                print(doc["nameOfFood"])


        except Exception as e:
            error_message = f"An error occurred during data processing: {str(e)}"
            self.logger.logger.error(error_message)
            return {
                "success": False,
                "message": error_message
            }