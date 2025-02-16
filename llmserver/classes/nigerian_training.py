from sentence_transformers import SentenceTransformer
import numpy as np
from typing import List, Dict, Tuple
import os
import json

from classes.load_grocery_data import load_grocery_data

current_dir = os.getcwd()

file_path = os.path.join(current_dir, "excelsheets", "PAYOOR_PRODUCTS.xlsx")

class NigerianGrocerySearch:
    def __init__(self, model_name: str = 'all-MiniLM-L6-v2'):
        self.model = SentenceTransformer(model_name)
        self.items = []
        self.embeddings = None
        
        # Define category relationships based on the complete data
        self.category_words = {
            'grains': {
            'terms': ['rice', 'beans', 'chia seed'],
            'meta': ['grain', 'rice', 'beans'],
            'subcategories': {
                'rice': ['long grain', 'short grain', 'ofada', 'basmati', 'abakaliki'],
                'beans': ['oloyin', 'white beans']
            }
        },
        
        # Proteins
        'proteins': {
            'terms': ['chicken', 'turkey', 'beef', 'fish', 'snail'],
            'meta': ['meat', 'chicken', 'fish', 'protein', 'seafood'],
            'subcategories': {
                'meat': ['chicken', 'turkey', 'goat', 'beef', 'liver', 'ponmo'],
                'fish': ['kote', 'titus', 'hake', 'sawa', 'croaker', 'panla', 'catfish'],
                'dried_fish': ['crayfish', 'stock fish', 'smoked panla'],
                'seafood': ['shrimp', 'prawn', 'periwinkle']
            }
        },
        
        # Soup Ingredients
        'soup_ingredients': {
            'terms': ['ogbono', 'egusi', 'okazi', 'okro', 'ewedu'],
            'meta': ['soups', 'soup'],
            'subcategories': {
                'thickeners': ['ogbono', 'egusi', 'achi'],
                'vegetables': ['okazi', 'okro', 'ewedu', 'ugu', 'uziza'],
                'spices': ['uda', 'ehuru', 'locust beans', 'ogiri']
            }
        },
        
        # Stew Base
        'stew_ingredients': {
            'terms': ['tomato', 'pepper', 'onions'],
            'meta': ['stew', 'tomato', 'pepper'],
            'subcategories': {
                'tomatoes': ['fresh tomato', 'tin tomato', 'paste'],
                'peppers': ['rodo', 'tatase', 'shombo', 'bell pepper'],
                'basics': ['onions', 'garlic', 'ginger']
            }
        },
        
        # Vegetables and Leaves
        'vegetables': {
            'terms': ['ugu', 'ewedu', 'bitter leaf', 'scent leaf', 'green'],
            'meta': ['vegetable', 'vegetables', 'leaves'],
            'subcategories': {
                'leafy': ['ugu', 'ewedu', 'bitter leaf', 'scent leaf'],
                'others': ['cabbage', 'lettuce', 'cucumber', 'carrot'],
                'specialty': ['garden egg', 'sweet corn', 'green peas']
            }
        },
        
        # Fruits
        'fruits': {
            'terms': ['apple', 'orange', 'banana', 'pineapple'],
            'meta': ['fruit'],
            'varieties': {
                'local': ['agbalumo', 'garden egg'],
                'imported': ['apple', 'grape', 'lemon'],
                'tropical': ['pineapple', 'banana', 'watermelon', 'orange']
            }
        },
        
        # Swallow (Solid Foods)
        'swallow': {
            'terms': ['garri', 'amala', 'poundo', 'semovita'],
            'meta': ['swallow'],
            'types': {
                'garri': ['yellow', 'white', 'ijebu'],
                'amala': ['black', 'white'],
                'others': ['poundo', 'semovita']
            }
        },
        
        # Seasonings and Spices
        'seasonings': {
            'terms': ['curry', 'thyme', 'garlic', 'ginger', 'seasoning'],
            'meta': ['seasoning', 'spice'],
            'categories': {
                'powders': ['curry', 'thyme', 'garlic powder', 'ginger powder'],
                'cubes': ['knorr', 'maggi', 'royco'],
                'natural': ['garlic', 'ginger', 'bay leaf']
            }
        },
        
        # Processed Foods
        'processed_foods': {
            'terms': ['noodles', 'spaghetti', 'cornflakes', 'sardine'],
            'meta': ['noodles', 'spaghetti', 'can food', 'cornflakes'],
            'categories': {
                'noodles': ['indomie', 'super pack', 'hungry man'],
                'pasta': ['spaghetti', 'macaroni', 'pasta'],
                'cereals': ['cornflakes', 'golden morn'],
                'canned': ['sardine', 'sweet corn', 'milk']
            }
        },
        
        # Beverages
        'beverages': {
            'terms': ['tea', 'milk', 'bournvita', 'juice'],
            'meta': ['beverage', 'juice', 'milk'],
            'types': {
                'tea': ['lipton', 'top tea'],
                'milk': ['peak', 'hollandia', 'three crown'],
                'drinks': ['bournvita', 'milo', 'ovaltine'],
                'juices': ['capri-sun', 'chi', 'five alive']
            }
        },
        
        # Oils
        'oils': {
            'terms': ['vegetable oil', 'palm oil'],
            'meta': ['oil'],
            'types': {
                'vegetable': ['kings', 'power oil', 'devon kings'],
                'palm': ['local', 'special', 'pure']
            }
        },
        
        # Tubers
        'tubers': {
            'terms': ['yam', 'potato', 'cocoyam'],
            'meta': ['tuber', 'tubers'],
            'varieties': {
                'yam': ['regular', 'water yam'],
                'potato': ['irish', 'sweet potato'],
                'others': ['cocoyam']
            }
        }
    }
        
    def clean_text(self, text: str) -> str:
        """Clean text by removing extra spaces and standardizing format."""
        return ' '.join(text.lower().split())
        
    def load_items(self, items: List[str]):
        """Load and process grocery items."""
        # Clean items and remove duplicates
        self.items = list(set([self.clean_text(item) for item in items]))
        
        # Create embeddings for all items
        self.embeddings = self.model.encode(self.items, show_progress_bar=True)
        print(f"Loaded {len(self.items)} unique items")
        print(self.embeddings)

        embeddings_dict = {
            'items': self.items,
            'vectors': self.embeddings.tolist()  # Convert numpy array to list
        }

        with open('embeddings.json', 'w') as f:
            json.dump(embeddings_dict, f)
        
    def enhance_query(self, query: str) -> str:
        """Enhance search query with category information."""
        query_terms = query.lower().split()
        enhanced_terms = query_terms.copy()
        
        # Add category terms if found
        for term in query_terms:
            print('term')
            print(term)
            print('++++=========')
            for category, related_terms in self.category_words.items():
                if term in related_terms or term == category:
                    enhanced_terms.append(category)
                    enhanced_terms.extend(related_terms)
                    
        return ' '.join(set(enhanced_terms))  # Remove duplicates
        
    def search(self, query: str, top_k: int = 6, threshold: float = 0.3) -> List[Tuple[str, float]]:
        """Search for grocery items using saved embeddings."""
        try:
            # Load saved embeddings if we don't have them in memory
            if not self.items or self.embeddings is None:
                with open('embeddings.json', 'r') as f:
                    loaded_data = json.load(f)
                    self.items = loaded_data['items']
                    self.embeddings = np.array(loaded_data['vectors'])

            if not self.items:
                return []
            
            # Enhance query with category information
            enhanced_query = self.enhance_query(query)
            print(f"Enhanced query: {enhanced_query}")
        
            # Generate embedding for the query
            query_embedding = self.model.encode(enhanced_query)
        
            # Calculate cosine similarities
            similarities = []
            for idx, item_embedding in enumerate(self.embeddings):
                similarity = np.dot(query_embedding, item_embedding) / (
                    np.linalg.norm(query_embedding) * np.linalg.norm(item_embedding)
                )

                if similarity >= threshold:
                    similarities.append((self.items[idx], float(similarity)))
        
            # Sort by similarity and return top k
            return sorted(similarities, key=lambda x: x[1], reverse=True)[:top_k]
        
        except FileNotFoundError:
            print("embeddings.json not found")
            return []
        except Exception as e:
            print(f"Error loading embeddings: {str(e)}")
            return []
        
    def parse_query(self, query: str) -> list:
        items = [item.strip() for item in query.split(",")]
        # Return non-empty items
        return [item for item in items if item]

def main():
    # Your complete list of items
    grocery_items = load_grocery_data(file_path)
    
    # Initialize search engine
    search_engine = NigerianGrocerySearch()
    
    # Load items
    search_engine.load_items(grocery_items)

    query = "i want to get plantain, eggs, rice, chicken, ugu leaves"
    
    # Test searches
    test_queries = search_engine.parse_query(query)
    
    for query in test_queries:
        print(f"\nSearching for {query}:")
        results = search_engine.search(query)
        for item, score in results:
            print(f"{item}: {score:.4f}")

if __name__ == "__main__":
    main()