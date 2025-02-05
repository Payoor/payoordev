import numpy as np
from collections import defaultdict
import re
from typing import List, Dict, Tuple
from sklearn.metrics.pairwise import cosine_similarity

class GroceryEmbedding:
    def __init__(self, embedding_dim: int = 50, window_size: int = 3, learning_rate: float = 0.01):
        self.embedding_dim = embedding_dim
        self.window_size = window_size
        self.learning_rate = learning_rate
        self.word2idx: Dict[str, int] = {}
        self.idx2word: Dict[int, str] = {}
        self.vocabulary_size = 0
        self.embeddings = None
        self.category_boost = defaultdict(float)  # Store category boost weights

    def preprocess_text(self, text: str) -> List[str]:
        """Clean and tokenize text with special handling for grocery items."""
        # Convert to lowercase
        text = text.lower()
        # Keep hyphens for compound words like "non-fat"
        text = re.sub(r'[^a-zA-Z\s-]', '', text)
        print("=====")
        print(text.split())
        return text.split()

    def build_vocabulary(self, items: List[str], category_words: Dict[str, List[str]]):
        """
        Build vocabulary from grocery items with category awareness.
        
        Args:
            items: List of grocery item descriptions
            category_words: Dictionary mapping category names to related words
                          e.g., {'fish': ['salmon', 'tuna', 'croaker', ...]}
        """
        word_freq = defaultdict(int)
        
        # Count word frequencies
        for item in items:
            words = self.preprocess_text(item)
            for word in words:
                word_freq[word] += 1
        
        # Create word to index mapping
        for word in word_freq.keys():
            self.word2idx[word] = self.vocabulary_size
            self.idx2word[self.vocabulary_size] = word
            self.vocabulary_size += 1
        
        # Initialize embeddings
        self.embeddings = np.random.randn(self.vocabulary_size, self.embedding_dim) * 0.01
        
        # Set up category boosting
        for category, related_words in category_words.items():
            if category in self.word2idx:
                # Boost the importance of relationships between category word and related terms
                for word in related_words:
                    if word in self.word2idx:
                        self.category_boost[(self.word2idx[category], self.word2idx[word])] = 2.0
                        self.category_boost[(self.word2idx[word], self.word2idx[category])] = 2.0

    def get_context_words(self, words: List[str], target_idx: int) -> List[Tuple[str, float]]:
        """Get context words with their importance weights."""
        start = max(0, target_idx - self.window_size)
        end = min(len(words), target_idx + self.window_size + 1)
        
        context_words = []
        target_word_idx = self.word2idx[words[target_idx]]
        
        for i in range(start, end):
            if i != target_idx and words[i] in self.word2idx:
                context_word_idx = self.word2idx[words[i]]
                # Apply category boost if applicable
                weight = self.category_boost.get((target_word_idx, context_word_idx), 1.0)
                context_words.append((words[i], weight))
        
        return context_words

    def train(self, items: List[str], epochs: int = 50):
        """Train the embeddings with category-aware weighting."""
        for epoch in range(epochs):
            total_loss = 0
            
            for item in items:
                words = self.preprocess_text(item)
                if not words:
                    continue
                
                for i, target_word in enumerate(words):
                    if target_word not in self.word2idx:
                        continue
                    
                    context_pairs = self.get_context_words(words, i)
                    
                    for context_word, weight in context_pairs:
                        loss = self._train_pair(target_word, context_word, weight)
                        total_loss += loss
            
            if (epoch + 1) % 10 == 0:
                print(f"Epoch {epoch + 1}/{epochs}, Loss: {total_loss:.4f}")

    def _train_pair(self, target_word: str, context_word: str, weight: float) -> float:
        """Train on a single word pair with importance weighting."""
        target_idx = self.word2idx[target_word]
        context_idx = self.word2idx[context_word]
        
        # Get current embeddings
        target_vec = self.embeddings[target_idx]
        context_vec = self.embeddings[context_idx]
        
        # Forward pass with weighted learning
        score = np.dot(target_vec, context_vec)
        sigmoid = 1 / (1 + np.exp(-score))
        
        # Compute gradient with importance weighting
        error = (sigmoid - 1) * weight
        grad_target = error * context_vec
        grad_context = error * target_vec
        
        # Update embeddings
        self.embeddings[target_idx] -= self.learning_rate * grad_target
        self.embeddings[context_idx] -= self.learning_rate * grad_context
        
        return -np.log(sigmoid)

    def search(self, query: str, n: int = 5) -> List[Tuple[str, float]]:
        """
        Search for similar terms to the query.
        Handles both exact matches and semantic similarity.

        
        """
        print(f"\nSearching for {query}:")
        query_words = self.preprocess_text(query)
        if not query_words:
            return []
        
        # If query words aren't in vocabulary, return empty results
        query_vectors = []
        for word in query_words:
            if word in self.word2idx:
                query_vectors.append(self.embeddings[self.word2idx[word]])
        
        if not query_vectors:
            return []
        
        # Use average of query word vectors
        query_vector = np.mean(query_vectors, axis=0)
        
        # Calculate similarities
        similarities = []
        for idx, vector in enumerate(self.embeddings):
            similarity = cosine_similarity([query_vector], [vector])[0][0]
            word = self.idx2word[idx]
            similarities.append((word, similarity))
        
        # Sort by similarity and return top n
        return sorted(similarities, key=lambda x: x[1], reverse=True)[:n]

# Example usage
def main():
    # Sample grocery data
    grocery_items = [
        "salmon fish fillet",
        "tuna fish can",
        "croaker fish fresh",
        "cat fish whole",
        "fish stock cubes",
        "cod fish frozen",
        "fish sauce thai",
        "dried fish snacks",
        "fish balls frozen",
        "mackerel fish smoked",
        "fresh vegetables",
        "chicken breast",
        "rice",
        "bread"
    ]
    
    # Define category relationships
    category_words = {
        'fish': ['salmon', 'tuna', 'croaker', 'catfish', 'cod', 'mackerel',
                'stock', 'sauce', 'balls', 'dried', 'fresh', 'frozen', 'smoked']
    }
    
    # Create and train model
    model = GroceryEmbedding(embedding_dim=50, window_size=3, learning_rate=0.01)
    model.build_vocabulary(grocery_items, category_words)
    model.train(grocery_items, epochs=100)
    
    # Test searches
    
    results = model.search('salmon fish fillet')
    for word, score in results:
        print(f"{word}: {score:.4f}")


if __name__ == "__main__":
    main()