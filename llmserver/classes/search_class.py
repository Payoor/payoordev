import os
import re
import json
from typing import List, Dict
from algoliasearch.search.client import SearchClientSync
from dotenv import load_dotenv
from openai import OpenAI

from configurations.chroma_configuration import chroma_client, openai_ef
from configurations.mongoose_configuration import productCollection
from classes.algolia_class import AlgoliaManager
from classes.logginghandler_class import LoggingHandler

load_dotenv()

api_key = os.getenv('API_KEY')

openai = OpenAI(api_key=api_key)

class SearchManager:
    def __init__(self):
        load_dotenv()

        self.chromaIngredientsCollectionName = "ingredient_collection"
        self.chromaProductsCollectionName = "product_collection"
        self.app_id = os.getenv('ALGOLIA_APP_ID')
        self.app_key = os.getenv('ALGOLIA_APP_KEY')
        self.products_index = os.getenv('ALGOLIA_PRODUCTS_INDEX')
        self.ingredients_index = os.getenv('ALGOLIA_INGREDIENTS_INDEX')
        self.algolia_client = SearchClientSync(self.app_id, self.app_key)
        self.chromaIngredientsCollection = chroma_client.get_or_create_collection(name=self.chromaIngredientsCollectionName, embedding_function=openai_ef)
        self.chromaProductsCollection = chroma_client.get_or_create_collection(name=self.chromaProductsCollectionName, embedding_function=openai_ef)

    def process_search_string(self, user_query):
        char_array = re.split('[,\s]+', user_query.strip())

        return char_array

    def search_product_in_mongodb(self, product_name):
        try:
            product = productCollection.find_one({
                "name": product_name
            })
        
            if product:
                #print(product)
                return product
            else:
                print('none here')
                print(product_name)
                return None
            
            
        except Exception as e:
            print(f"Error searching for product: {e}")
            return None

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

        print("========")
        print(results)
        print("===========")

        return results_array

    def search_algolia_product_index(self, search_terms: List[str]) -> List[Dict]:
        """
        Search Algolia with the extracted terms.
        """
        try:
            #search_query = " ".join(search_terms)
            print(search_terms)
            response = self.algolia_client.search(
                search_method_params={
                    "requests": [
                        {
                            "indexName": self.products_index,
                            "typoTolerance": True,
                            "query": search_terms,
                            "hitsPerPage": 50,
                            "queryType": "prefixLast", 
                            "removeWordsIfNoResults": "allOptional",
                            # Optional: Add relevance settings
                            "distinct": True,  # Avoid duplicates
                            "attributesToRetrieve": [
                                "object_id",
                                "name",
                                "image"
                            ]
                        },
                    ],
                },
            )

            print(response.results[0])

            if response.results[0].actual_instance.hits:
                return self._process_results(response.results[0].actual_instance.hits)
            return []

        except Exception as e:
            print(f"Error searching Algolia: {str(e)}")
            return []

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
        

    def search_products_from_chroma(self, query_text, n_results=2, ingredients=False):
        try:
            # Split the query text by both commas and spaces
            query_terms = [term.strip() for term in query_text.replace(',', ' ').split()]

            if ingredients:
                query_terms = [term.strip() for term in query_text.split(',')]
        
            all_product_names = []
            all_product_ids = []
            response_array = []
        
            # Search for each term
            for term in query_terms:
                results = self.chromaProductsCollection.query(
                    query_texts=[term],
                    n_results=n_results
                )
            
                product_names = results["documents"][0]
                product_ids = results["ids"][0]
                all_product_names.extend(product_names)
                all_product_ids.extend(product_ids)

                #print(product_names)
                #print(product_ids)
                print(term)
        
            print("==========================")
            #print(all_product_names)
            #print(all_product_ids)
            print("==========================")
            unique_pairs = list(set(zip(all_product_names, all_product_ids)))
            unique_items, unique_ids = zip(*unique_pairs)

            products = [{"product_name": name, "_id": id} for name, id in zip(unique_items, unique_ids)]

            for product in products:
                product['productImageUrl'] = ""
                print(product)
                response_array.append(product)
        
            return response_array
        except Exception as e:
            print(f"Error searching recipes: {e}")
            return None

    def search_ingredients_from_chroma(self, query_text, n_results=3):
        try:
            results = self.chromaIngredientsCollection.query(
                query_texts=[query_text],
                n_results=n_results
            )

            print(results["metadatas"][0])
            print(results["documents"][0])

            return {
                "ingredients_array": results["metadatas"][0],
                "documents_array": results["documents"][0]
            }
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

    def find_food_words(self, query_text):
        response = openai.chat.completions.create(
            model = "gpt-4o-mini",
            messages=[
                {
                     "role": "system", "content": '''
                        Your task is to list the words in {query_text} that pass for food items and then simply return them in a list that can be used as a query
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

        content = response.choices[0].message.content
        #print(content)
        return content

    def analyze_text(self, text: str) -> Dict:
        """
        Use GPT-4 to analyze word types in the given text.
        """
        response = openai.chat.completions.create(
            model="gpt-4",
            messages=[
                {
                    "role": "system",
                    "content": """
                    You are a specialized word analyzer. Your role is to determine:
                    1. Function words (grammatical words like i, some, you, an, in, on, was, have, is, for, to, and, etc.)
                    2. Action words (verbs like want, buy, etc.)
                    3. Other words (nouns and content words)

                    For each query, analyze:
                    - Function word indicators (prepositions, articles, conjunctions)
                    - Action word indicators (verbs and their forms)
                    - Context of usage
                    - Correct any perceived mispellings

                    Return a JSON response with:
                    {   
                        "other_words": "remaining words"
                        "function_words": {
                            "words": [list of function words found]
                        },
                        "action_words": {
                            "words": [list of action words found]
                        }
                    }
                    """
                },
                {
                    "role": "user",
                    "content": text
                }
            ],
            temperature=0,
            max_tokens=150
        )
        
        try:
            content = response.choices[0].message.content
            match = re.search(r'\{.*\}', content, re.DOTALL)
            if match:
                json_part = match.group(0)
                analysis = json.loads(json_part)
                print(analysis)

            return analysis
        except Exception as e:
            print(f"Error during analysis: {str(e)}")
            return {"error": str(e)}

    def format_results(self, analysis: Dict) -> str:
        """Format the analysis results into readable text."""
        output = []
        
        if "function_words" in analysis:
            output.append("Function Words:")
            for word, word_type in analysis["function_words"]["types"].items():
                output.append(f"  {word}: {word_type}")
        
        if "action_words" in analysis:
            output.append("\nAction Words:")
            for word, word_type in analysis["action_words"]["types"].items():
                output.append(f"  {word}: {word_type}")
        
        if "other_words" in analysis:
            output.append("\nOther Words:")
            output.append("  " + ", ".join(analysis["other_words"]))
        
        return "\n".join(output)
        

    def infer_intent(self, query_text):
        response = openai.chat.completions.create(
            model = "gpt-4o-mini",
            messages=[
                {
                    "role": "system", "content": '''

                        You are a specialized food query analyzer. Your role is to determine if a user is:
                        1. Searching to purchase specific grocery items (grocery intent)
                        2. Searching to understand ingredients as components of dishes (ingredient intent)
                        3. Quering using a list (list intent)

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

    '''def search_algolia_product_index(self, search_query):
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

            print(response)

            if response.results[0].actual_instance.hits and len(response.results[0].actual_instance.hits) > 0:
                return response.results[0].actual_instance.hits
            return []
            
        except Exception as e:
            self.logger.logger.error(f"Error searching products: {str(e)}")
            return []'''