from chroma_db import chromaProductCollection
from mongoose import UpdateOne, ObjectId, productCollection
from open_ai import model, ChatPromptTemplate, MessagesPlaceholder, StrOutputParser, RunnableLambda

class DataUse:
    def get_items_from_mongodb_by_id(self, id_array):
        try:
            items = list(productCollection.find({
                "_id": {
                    "$in": [ObjectId(id_str) for id_str in id_array]
                }
            }))
        
            serializable_items = [{**item, '_id': str(item['_id'])} for item in items]
        
            if not serializable_items:
                return [], "No items found"
            
            return serializable_items
        
        except Exception as e:
            return [], f"Error: {str(e)}"

    def generate_prompt_label(self, sentence):
        prompt_template =  ChatPromptTemplate.from_messages([
            ("system", """
                generate a 3 word summary for this sentence {sentence}
            """
            ),
            (
                "user", "{sentence}"
            )
        ])

        chain = (
            prompt_template
            | model | StrOutputParser())
        
        response = chain.invoke({
            "sentence": sentence
        })

        return response

    def convert_numbered_string_to_array(self, text):
        lines = text.split('\n')
   
        prompts_array = []
   
        for line in lines:
            if not line.strip():
                continue
           
            parts = line.split('. ', 1)
            if len(parts) == 2:
                prompts_array.append({"label": self.generate_prompt_label(parts[1]), "text": parts[1]})
           
        return prompts_array

    def clean_up_generated_prompts_list(self, numbered_string):
        suggested_prompts = self.convert_numbered_string_to_array(numbered_string)
    
        return suggested_prompts


    def generate_suggested_prompt(self, query_result):
        
        prompt_template =  ChatPromptTemplate.from_messages([
            ("system", """
                generate a 5 item list of suggested prompts based on this {query_result}
            """
            ),
            (
                "user", "{query_result}"
            )
        ])

        chain = (
            prompt_template
            | model | StrOutputParser())
        
        response = chain.invoke({
            "query_result": query_result
        })

        return response

    def judge_query_relevance(self, query, query_result):
        prompt_template = ChatPromptTemplate.from_messages([
            ("system", """
                You are an AI system designed to evaluate the relevance of this {query_result} to a given query. Your goal is to analyze the relationship between the query and the text and determine how well the text addresses or aligns with the query. 

                for items in the query that are relevant to this {query_result} simply say you found some items that might be relevant

                for items in the query that are not relevant to this {query_result} simply list the query items and ask the user to refine their search

                use this "I found some relevant items for you: rice, eggs, and chicken. However, I couldn’t find anything for beans, iron, shirts, or phones. You might want to adjust your search to focus on available products." as a reference for how your response should look
            """),
            (("user", "{query}"))
        ])

        chain = (
            prompt_template 
            | model | StrOutputParser()) #| RunnableLambda(lambda x: self.format_airesponse_for_user(x)) | model | StrOutputParser()


        response = chain.invoke({
            "query_result": query_result,
            "query": query
        })

        return response
        
        
    def format_chroma_results(self, results):
        formatted_results = []
        
        if not results['documents'] or not results['documents'][0]:
            return formatted_results
            
        documents = results['documents'][0]
        ids = results['ids'][0]
        distances = results['distances'][0] if 'distances' in results else None
        
        for i in range(len(documents)):

            result = {
                'text': documents[i],
                'id': ids[i],
                'similarity_score': distances[i] if distances else None,
                'match_percentage': f"{(1 - (distances[i] / 2)) * 100:.1f}%" if distances else None
            }

            formatted_results.append(result)
            
        return formatted_results

    def query_products_from_chroma(self, query_text, num_results=5, min_similarity=0.5):
        try:
            results_texts = "" 
            results = chromaProductCollection.query(query_texts=[query_text], n_results=num_results)

            formatted_results = self.format_chroma_results(results)

            for i, result in enumerate(formatted_results, 1):
                results_texts += result['text'] + "\n\n"
                
            return True, results, formatted_results, results_texts.strip()  

        except Exception as e:
            print(f"Error querying ChromaDB: {e}")
            return False, []