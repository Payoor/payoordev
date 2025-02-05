import numpy as np
from collections import defaultdict
import re
import os
import pandas as pd
from typing import List, Dict, Tuple
from sklearn.metrics.pairwise import cosine_similarity

current_dir = os.getcwd()

file_path = os.path.join(current_dir, "excelsheets", "PAYOOR_PRODUCTS.xlsx")
df = pd.read_excel(file_path)


grocery_items = []

for row in df.itertuples():
    grocery_item = getattr(row, 'NAME', "N/A")
    grocery_items.append(grocery_item)

print(grocery_items)

