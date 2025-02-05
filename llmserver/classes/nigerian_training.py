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
            'rice': [
                'long grain', 'short grain', 'ofada', 'basmati', 'tropical sun', 
                'tilda', 'abakaliki'
            ],
            'fish': [
                'kote', 'titus', 'hake', 'sawa', 'croaker', 'crayfish', 'panla',
                'catfish', 'stock fish', 'sardine', 'sole fish', 'abo'
            ],
            'meat': [
                'chicken', 'turkey', 'goat', 'beef', 'liver', 'lap', 'wings',
                'breast', 'sausage', 'ponmo'
            ],
            'pepper': [
                'rodo', 'tatase', 'shombo', 'cameroun', 'bell pepper', 
                'ata rodo', 'suya pepper', 'negro pepper'
            ],
            'tomato': [
                'fresh tomato', 'gino original', 'gino jollof', 'paste'
            ],
            'garri': [
                'yellow garri', 'white garri', 'ijebu'
            ],
            'oil': [
                'vegetable oil', 'kings', 'power oil', 'palm oil'
            ],
            'noodles': [
                'indomie', 'spaghetti', 'pasta', 'honeywell'
            ],
            'fruits': [
                'apple', 'grape', 'pineapple', 'banana', 'lemon', 'watermelon',
                'orange', 'avocado', 'agbalumo'
            ],
            'vegetables': [
                'ugu', 'ewedu', 'bitter leaf', 'tete', 'garden egg',
                'cucumber', 'carrot', 'cabbage', 'lettuce', 'leaves'
            ],
            'spices': [
                'curry', 'thyme', 'garlic', 'ginger', 'nutmeg',
                'seasoning', 'knorr', 'maggi'
            ],
            'beans': [
                'oloyin', 'white beans'
            ],
            'tubers': [
                'yam', 'potato', 'sweet potato', 'irish potato', 'cocoyam'
            ]
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
            for category, related_terms in self.category_words.items():
                if term in related_terms or term == category:
                    enhanced_terms.append(category)
                    enhanced_terms.extend(related_terms)
                    
        return ' '.join(set(enhanced_terms))  # Remove duplicates
        
    def search(self, query: str, top_k: int = 6, threshold: float = 0.2) -> List[Tuple[str, float]]:
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

'''def main():
    # Your complete list of items
    #grocery_items = load_grocery_data(file_path)
    
    # Initialize search engine
    search_engine = NigerianGrocerySearch()
    
    # Load items
    #search_engine.load_items(grocery_items)

    query = "i want to get plantain, eggs, rice, chicken, ugu leaves"
    
    # Test searches
    test_queries = search_engine.parse_query(query)
    
    for query in test_queries:
        print(f"\nSearching for {query}:")
        results = search_engine.search(query)
        for item, score in results:
            print(f"{item}: {score:.4f}")

if __name__ == "__main__":
    main()'''