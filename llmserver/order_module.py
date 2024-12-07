from open_ai import model, ChatPromptTemplate, MessagesPlaceholder, StrOutputParser, RunnableLambda
from mongoose import UpdateOne, productCollection, orderCollection

class OrderModule:
    def get_order_by_reference(self, order_reference):
        try:
            orders = list(orderCollection.find({"reference": order_reference}))
            order = orders[0]

            if not order:
                return {"status": "error", "message": "No orders found"}

            return order

        except Exception as e:
            print(f"Error getting orders: {str(e)}")
            return {"status": "error", "message": str(e)}

    def get_order_summary(self, order):
        try:
            items_summary = []
        
            for item in order["items"]:
                units_summary = {}
            
       
                for unit_type, details in item["product_units"].items():
                    units_summary[unit_type] = {
                        "price": details["price"],
                        "quantity": details["quantity"]
                    }
            
                item_details = {
                    "product_name": item["product_name"],
                    "product_id": item["product_id"],
                    "unit_details": units_summary
                }
            
                items_summary.append(item_details)
        
            summary = {
                "order_id": str(order["_id"]),
                "status": order["status"],
                "total": order["total"],
                "reference": order.get("reference", "No reference"),
                "created_at": order["createdAt"],
                "items": items_summary
            }
        
            return summary
        
        except Exception as e:
            print(f"Error getting order summary: {str(e)}")
        
            return {
                "status": "error",
                "message": str(e)
            }

    def get_order_summary_natural_language(self, order):
        try:
            items_text = []
        
            formatted_order = self.get_order_summary(order)
        
            for item in formatted_order["items"]:
                for unit_type, details in item["unit_details"].items():
                    quantity = details["quantity"]
                    price = details["price"]
                    items_text.append(f"- {quantity}x {item['product_name']} at {price}")
        
            order_date = formatted_order["created_at"].strftime("%B %d, %Y at %I:%M %p")
        
            summary = f"""Your order with reference #{formatted_order['reference']} is being processed. Here's your order summary:

                    Order contains:
                    {chr(10).join(items_text)}

                    Total amount: {formatted_order['total']}
                    Status: {formatted_order['status'].title()}"""

            return summary
        
        except Exception as e:
            print(f"Error creating order summary: {str(e)}")
            return {
            "status": "error",
            "message": str(e)
        }