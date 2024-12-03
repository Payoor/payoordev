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


def search_products(products, search_term):
    terms = search_term.lower().split()
    results = {}

    print(terms)
    print()

    for term in terms:
        matching_products = [
            product for product in products 
            if term in product['NAME'].lower()
        ]
        results[term] = matching_products
        print(f"Results for '{term}':")
        for product in matching_products:
            print(f"- {product['NAME']}")
        print()
    
    return results

def format_search_results(results_dict):
    formatted_output = ""
    
    for category, products in results_dict.items():
        formatted_output += f"{category.upper()}\n"
        
        product_groups = {}
        for product in products:
            name = product['NAME']
            if name not in product_groups:
                product_groups[name] = []
            product_groups[name].append(product)
        
        for name, variants in product_groups.items():
            formatted_output += f"\n- {name}\n"
            
            for variant in variants:
                formatted_output += f"  * Unit: {variant['UNIT'].strip()}\n"
                formatted_output += f"  * Price: {variant['PRICE PER UNIT']}\n"
                formatted_output += f"  * Available: {variant['AVAILABILITY']}\n"
                formatted_output += "\n"
                formatted_output += f"  * Image: http://store.com/white-beans.jpg\n"
        
        formatted_output += "-" * 50 + "\n\n"
    
    return formatted_output