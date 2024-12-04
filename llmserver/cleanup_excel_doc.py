import pandas as pd
from pathlib import Path

def excel_to_dict(directory_path, file_name):
    try:
        file_path = Path(directory_path) / file_name
        
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
        raise FileNotFoundError(f"Excel file '{file_name}' not found in directory '{directory_path}'")
    except Exception as e:
        raise Exception(f"Error processing Excel file: {str(e)}")
        
def process_excel_data(exceldb):
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

# Usage:
# final_data = process_excel_data(exceldb)