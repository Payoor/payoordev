import pandas as pd
from pathlib import Path
from datetime import datetime

from mongoose import productCollection

class DataUpload:
    ALLOWED_EXTENSIONS = {'xlsx', 'xls', 'csv'}

    def process_excel_data(self, exceldb):
        def group_by_name(items):
            groups = {}
            
            for item in items:
                name = item['NAME']
                if name in groups:
                    groups[name].append(item)
                else:
                    groups[name] = [item]
                
            return groups

        def restructure_group(items):
            if not items or len(items) == 0:
                return None
                
            result = {
                'NAME': items[0]['NAME'],
                'PRICE PER UNIT': [],
                'UNIT': [],
                'AVAILABILITY': []
            }
            
            for item in items:
                if item['PRICE PER UNIT'] is not None:
                    cleaned_price = item['PRICE PER UNIT'].replace('₦', '').replace(' ', '').replace(',', '')
                else:
                    cleaned_price = '0'
                    
                result['PRICE PER UNIT'].append(cleaned_price)
                result['UNIT'].append(item['UNIT'].strip() if item['UNIT'] else '')
                result['AVAILABILITY'].append(item['AVAILABILITY'])
                
            return result

        def restructure_all_groups(grouped_items):
            restructured_data = {}
            
            for name, group in grouped_items.items():
                restructured_data[name] = restructure_group(group)
                
            return restructured_data

        grouped_items = group_by_name(exceldb)
        final_data = restructure_all_groups(grouped_items)
        
        return final_data
    
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
        if isinstance(grouped_data, str):
            try:
                import ast
                grouped_data = ast.literal_eval(grouped_data)
            except (ValueError, SyntaxError) as e:
                raise ValueError(f"Could not parse string into dictionary: {e}")

        plaintext_items = {}
    
        for group_name, group_data in grouped_data.items():
            item = {}

            for key, values in group_data.items():
                if isinstance(values, list):
                    cleaned_values = []
                    for value in values:
                        if value is None:
                            cleaned_values.append('')
                        elif isinstance(value, str) and '₦' in value:
                            cleaned_values.append(value.replace('₦', '').strip())
                        else:
                            cleaned_values.append(str(value))
                    item[key] = cleaned_values
                else:
                    item[key] = str(values)
            plaintext_items[group_name] = item

        return plaintext_items

    def save_to_mongodb_database(self, data_group):
        try:
            failed_items = []
            successful_items = []
        
            for group_name, items in data_group.items():
                try:
               
                    variants = []
                    for i in range(len(items['UNIT'])):
                        variant = {
                            'unit': items['UNIT'][i],
                            'price': items['PRICE PER UNIT'][i],
                            'availability': items['AVAILABILITY'][i]
                        }
                        variants.append(variant)

                    product_doc = {
                        "product_name": group_name,
                        "data": variants
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
                try:
                    with open('failed_items.txt', 'a') as f:
                        f.write(f"\nFailed Items ({datetime.now()}):\n")
                        for item in failed_items:
                            f.write(f"Product: {item['product_name']}\n")
                            f.write(f"Reason: {item['reason']}\n")
                            f.write("-" * 50 + "\n")
                
                    print(f"Failed items have been saved to failed_items.txt")
                except IOError as file_error:
                    print(f"Warning: Could not write to failed_items.txt: {str(file_error)}")
        
            total_items = len(data_group)
            if len(failed_items) == 0:
                return True, f"All {total_items} items saved successfully"
            elif len(successful_items) == 0:
                return False, f"All {total_items} items failed to save"
            else:
                return True, f"Partially successful: {len(successful_items)} saved, {len(failed_items)} failed"
        
        except Exception as e:
            return False, f"Error saving to MongoDB: {str(e)}"