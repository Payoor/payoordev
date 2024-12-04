from open_ai import model, ChatPromptTemplate, MessagesPlaceholder, StrOutputParser, RunnableLambda

class CartModule:
    def generate_cart_summary(self, cart_data):
        try:
            prompt_template =  ChatPromptTemplate.from_messages([
                ("system", """
                    turn this data to natural language

                    use this example as reference for the structure of your response 

                    Your cart currently contains:
                    
                    Okoro:

                    2 half paints at ₦4,960 each
                    1 half bag (25kg) at ₦50,149

                    Beans:

                    1 half carton (4.5kg) at ₦26,078
                    1 full carton (9kg) at ₦52,019

                    Total cost: ₦138,166

                    Click the pay pill tp proceed with your order
                """
                ),
                (
                "user", "{cart_data}"
                )
            ])

            chain = (
                prompt_template
                | model | StrOutputParser())
        
            response = chain.invoke({
                "cart_data": cart_data
            })

            return response
        except Exception as e:
            return [], f"Error: {str(e)}"