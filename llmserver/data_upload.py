import pandas as pd
from pathlib import Path

from mongoose import productCollection

class DataUpload:
    ALLOWED_EXTENSIONS = {'xlsx', 'xls', 'csv'}
    
    def allowed_file(self, filename: str) -> bool:
        return '.' in filename and \
            filename.rsplit('.', 1)[1].lower() in self.ALLOWED_EXTENSIONS
    
    def excel_to_dict(self, directory_path):
        try:
            file_path = Path(directory_path)
            
            df = pd.read_excel(file_path)
            df.columns = df.columns.astype(str)
            records = df.to_dict('records')
            
            cleaned_records = []
            for record in records:
                cleaned_record = {}
                for key, value in record.items():
                    if pd.isna(value):
                        cleaned_record[key] = None
                    elif isinstance(value, pd.Timestamp):
                        cleaned_record[key] = value.strftime('%Y-%m-%d %H:%M:%S')
                    else:
                        cleaned_record[key] = value
                cleaned_records.append(cleaned_record)
                
            return cleaned_records
            
        except FileNotFoundError:
            raise FileNotFoundError(f"Excel file not found in directory '{directory_path}'")
        except Exception as e:
            raise Exception(f"Error processing Excel file: {str(e)}")

    def convert_to_plaintext(self, grouped_data):
        plaintext_items = {}
    
        for group_name, items in grouped_data.items():
            group_items = []
            for item in items:
                plaintext_item = {}
                for key, value in item.items():
                    if key != 'Column 6' and key != 'Column 1': 
                        if value is None:
                            value = ''
                        elif isinstance(value, str) and '₦' in value:
                            value = value.replace('₦', '').strip()
                    
                        plaintext_item[key] = str(value)
                group_items.append(plaintext_item)
            plaintext_items[group_name] = group_items
    
        return plaintext_items

    def save_to_mongodb_database(self, data_group):
        try:
            failed_items = []
            successful_items = []
        
            for group_name, items in data_group.items():
                try:
                    product_doc = {
                        "product_name": group_name,
                        "data": items
                    }
                
                    existing_product = productCollection.find_one({
                    "product_name": group_name
                    })
                
                    if existing_product:
                        failed_items.append({
                            "product_name": group_name,
                            "reason": "Product already exists"
                        })
                    else:
                        result = productCollection.insert_one(product_doc)
                        if result.acknowledged:
                            successful_items.append(group_name)
                        else:
                            failed_items.append({
                                "product_name": group_name,
                                "reason": "Insert not acknowledged"
                            })
                        
                except Exception as item_error:
                    failed_items.append({
                        "product_name": group_name,
                        "reason": str(item_error)
                    })
        
            if failed_items:
                with open('failed_items.txt', 'w') as f:
                    f.write("Failed Items:\n")
                    for item in failed_items:
                        f.write(f"Product: {item['product_name']}\n")
                        f.write(f"Reason: {item['reason']}\n")
                        f.write("-" * 50 + "\n")
            
                print(f"Failed items have been saved to failed_items.txt")
            
            return True, "Data save completed"
        
        except Exception as e:
            return False, f"Error saving to MongoDB: {str(e)}"