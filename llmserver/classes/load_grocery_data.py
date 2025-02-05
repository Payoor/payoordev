import os
import pandas as pd
from typing import List, Dict, Tuple

def load_grocery_data(excel_path: str) -> List[str]:
   try:
        # Read Excel file
        df = pd.read_excel(excel_path)
        
        # Get items from NAME column
        grocery_items = []
        for row in df.itertuples():
            grocery_item = getattr(row, 'NAME', "N/A")
            if grocery_item != "N/A":  # Only add valid names
                grocery_items.append(grocery_item)
                
        print(f"Successfully loaded {len(grocery_items)} items from Excel")
        return grocery_items
        
   except Exception as e:
        print(f"Error loading Excel file: {str(e)}")
        return []


