import os
import re
from algoliasearch.search.client import SearchClientSync
from dotenv import load_dotenv
from openai import OpenAI

from configurations.chroma_configuration import chroma_client, openai_ef
from classes.algolia_class import AlgoliaManager
from classes.logginghandler_class import LoggingHandler


load_dotenv()

api_key = os.getenv('API_KEY')

openai = OpenAI(api_key=api_key)

class SearchManager:
    def __init__(self):
        load_dotenv()

        self.collectionName = "ingredient_collection"
        self.app_id = os.getenv('ALGOLIA_APP_ID')
        self.app_key = os.getenv('ALGOLIA_APP_KEY')
        self.products_index = os.getenv('ALGOLIA_PRODUCTS_INDEX')
        self.ingredients_index = os.getenv('ALGOLIA_INGREDIENTS_INDEX')
        self.algolia_client = SearchClientSync(self.app_id, self.app_key)
        self.collection = chroma_client.get_or_create_collection(name=self.collectionName, embedding_function=openai_ef)

    def process_search_string(self, user_query):
        char_array = re.split('[,\s]+', user_query.strip())

        return char_array

    def search_using_algolia(self, char_array):
        results_array = []

        for item in char_array:
            results = self.search_algolia_product_index(item)

            if len(results) > 0:
                for result in results:
                    product_item = {
                        '_id': result.object_id,
                        'product_name': result.name,
                        'productImageUrl': result.image
                    }

                    results_array.append(product_item)

        return results_array

    def remove_duplicates_from_results(self, results_array):
        final_result = set()
        unique_products = []
        for product in results_array:
            if product['_id'] not in final_result:
                final_result.add(product['_id'])
                unique_products.append(product)

        print(unique_products)

        return unique_products

    def save_query_to_redis():
        print('saving to redis')

    def search_ingredients_from_chroma(self, query_text, n_results=3):
        try:
            results = self.collection.query(
                query_texts=[query_text],
                n_results=n_results
            )

            print(results)

            return results
        except Exception as e:
            print(f"Error searching recipes: {e}")
            return None

    def enforce_similarity_from_list(self, item_list, user_query):
        try:
            system_prompt = """
                Look through this sentence {user_query} and answer it, strictly using the {item_list} as your knowledge base. 
                Only use information and items found in the provided item list as your knowledge base. If you don't find any item in {item_list} that reasonably 
                shows that you know anything about what is in {user_query} simply say you don't know anything about it at the moment, and suggest they ask for something else.
                If any items in the {item_list} reasonably show that you know simply reply by saying that I found some products that could make good ingredients
            """

            response = openai.chat.completions.create(
                model="gpt-4o-mini",
                messages=[
                    {
                        "role": "system",
                        "content": system_prompt
                    },
                    {
                        "role": "user",
                        "content": f"Item list for reference: {item_list}\nUser query: {user_query}"
                    }
                ],
                temperature=0,
                max_tokens=100
            )

            print(response.choices[0].message.content)
            return response.choices[0].message.content
        except Exception as e:
            print(f"Error searching recipes: {e}")
            return None

    def format_ingredients_response(self, ingredients_result, user_query):
        ingredient_data = {
            'ids': ingredients_result['ids'][0],
            'distances': ingredients_result['distances'][0],
            'documents': ingredients_result['documents'][0],
        }

        print(ingredient_data)
        print('====================')

        if (ingredient_data["distances"][0] > 0.8):
            print('too far show suggestions')
            suggestions = ingredient_data["documents"]
            suggestions_id = ingredient_data["ids"]
            unique_items = list(set(suggestions))
            item_list = ", ".join(unique_items)
            nlp_response = self.enforce_similarity_from_list(item_list, user_query)
            print(suggestions)
            print(suggestions_id)
            response_body = {
                "nlp_response": nlp_response,
                "response_array": []
            }

            return response_body
        else:
            direct_match = {
                'match': ingredient_data["documents"][0],
                'match_id': ingredient_data["ids"][0],
            }

            nlp_response = self.enforce_similarity_from_list(direct_match["match"], user_query)
            response_array = self.search_algolia_ingredient_index_by_ingredient_id(direct_match["match_id"])

            print('show result and suggestions')
            print(direct_match)
            response_body = {
                "nlp_response": nlp_response,
                "response_array": response_array
            }

            return response_body

  
    def infer_intent(self, query_text):
        response = openai.chat.completions.create(
            model = "gpt-4o-mini",
            messages=[
                {
                    "role": "system", "content": '''

                        You are a specialized food query analyzer. Your role is to determine if a user is:
                        1. Searching to purchase specific grocery items (grocery intent)
                        2. Searching to understand ingredients as components of dishes (ingredient intent)

                        For each query, analyze:
                        - Shopping indicators (buy, get, store, shop, price, cost, where)
                        - Component indicators (what's in, made of, ingredients list, contains)
                        - Context (shopping list vs recipe inquiry)
                        - Form of question (where to buy vs what goes into)

                        Return a JSON response with:
                        {
                            "intent": "grocery" or "ingredient",
                            "confidence": 0-1,
                            "primary_item": main food mentioned,
                            "query_type": "direct_search" or "component_inquiry",
                            "extracted_terms": key terms that influenced decision,
                            "follow_up_action": suggested next step
                        }
                
                    '''
                },
                {
                    "role": "user",
                    "content": query_text
                }
            ],
            temperature=0,
            max_tokens=100
        )

        print(response.choices[0].message.content)
        
        return response.choices[0].message.content

    def search_algolia_ingredient_index_by_ingredient_id(self, ingredient_id):
        try:

            print(ingredient_id)
            response = self.algolia_client.get_object(
                index_name=self.ingredients_index,
                object_id=ingredient_id,
                attributes_to_retrieve=[
                    "ingredients",
                ],
            )

            products_query = response["ingredients"]
            char_array = self.process_search_string(products_query)
            results_array = self.search_using_algolia(char_array)
            response_array = self.remove_duplicates_from_results(results_array)
            print(response_array)

            return response_array
        except Exception as e:
            print(f"Error searching recipes: {e}")
            return None

    def search_algolia_product_index(self, search_query):
        try:
            response = self.algolia_client.search(
                search_method_params={
                    "requests": [
                        {
                            "indexName": self.products_index,
                            "typoTolerance": True,
                            "query": search_query,
                            "hitsPerPage": 50,
                        },
                    ],
                },
            )

            if response.results[0].actual_instance.hits and len(response.results[0].actual_instance.hits) > 0:
                return response.results[0].actual_instance.hits
            return []
            
        except Exception as e:
            self.logger.logger.error(f"Error searching products: {str(e)}")
            return []