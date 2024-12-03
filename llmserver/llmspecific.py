from enum import Enum
from typing import List, Dict, Tuple
from dotenv import load_dotenv
from langchain_openai import ChatOpenAI
from langchain.prompts import ChatPromptTemplate, MessagesPlaceholder
import os
from openai import OpenAI

from mongodb_module import productCollection

load_dotenv()

api_key = os.getenv('API_KEY')

openai = OpenAI(api_key=api_key)

class InputType(Enum):
    SEARCH = "search"
    QUESTION = "question"

class InputClassifier:
    def __init__(self):
         self.classification_prompt = """Determine if this input is a product search query or a question about existing items.

            Current items in view: {items}
            User input: "{user_input}"

            Think step by step:
            1. Is this phrased as a question about specific items? Look for:
                - Question words (what, which, how, can, does)
                - References to shown items (this, these, they, it)
                - Comparisons between items
            2. Is this a search for new items? Look for:
                - Product categories
                - Specifications
                - Keywords typical in search

            Respond only with either "search" or "question"."""

    async def classify_and_route(
        self,
        user_input: str,
        current_items: List[Dict]
    ) -> Tuple[InputType, str]:
        formatted_prompt = self.classification_prompt.format(
            items=self._format_items(current_items),
            user_input=user_input
        )

        classification = await self._get_llm_classification(formatted_prompt)

        input_type = InputType(classification)

        if input_type == InputType.SEARCH:
            return input_type, await self._handle_search(user_input)
        else:
            return input_type, await self._handle_question(user_input, current_items)

    async def search_products(self, query: str) -> str:
        return await self._handle_search(query)


    async def _get_llm_classification(self, prompt: str) -> str:
        response = openai.chat.completions.create(
            model = "gpt-4o-mini",
            messages=[{
                "role": "user",
                "content": prompt
            }],
            temperature=0,
            max_tokens=10
        )
        
        return response.choices[0].message.content

    async def _handle_search(self, query: str) -> str:
        products = productCollection.find({"data.NAME": {"$regex": query, "$options": "i"}})
        print("======query=====")
        print(query)
        print(list(products))
        return list(products)

    async def _handle_question(self, question: str, items: List[Dict]) -> str:
        # Implement LLM Q&A about items
        # Return answer
        pass

    def _format_items(self, items: List[str]) -> str:
        return "\n".join(f"- {item}" for item in items)
