import logging
import os
from logging import Handler, Formatter
import json
import requests

from datetime import datetime
from dotenv import load_dotenv

from configurations.redis_configuration import redis_client

load_dotenv()

ERROR_SERVER_HOST = os.getenv('ERROR_SERVER_HOST')
ERROR_SERVER_PORT = int(os.getenv('ERROR_SERVER_PORT')) 

class LoggingHandler(Handler):
    def __init__(self, module_name=__name__):
        super().__init__()
        self.redis_client = redis_client
        self.logger = logging.getLogger(module_name)
        self.logger.setLevel(logging.INFO)

        formatter = Formatter('%(asctime)s - %(name)s - %(levelname)s - %(filename)s:%(lineno)d - %(message)s')
        self.setFormatter(formatter)

        self.logger.addHandler(self)

    def emit(self, record): 
        log_entry = self.format(record)
        log_map = self.parse_log_to_map(log_entry)
        self.save_to_redisdb(log_map)
        print(log_map)

    def parse_log_to_map(self, log_message):
        parts = log_message.split(' - ')
    
        log_map = log_map = {
            'timestamp': parts[0],
            'module': parts[1],
            'level': parts[2],
            'location': parts[3], 
            'message': parts[4],  
            'createdAt': datetime.utcnow(),
            'updatedAt': datetime.utcnow()
        }
    
        return log_map

    def save_to_redisdb(self, log_map):
        try:
            json_log_map = log_map.copy()
        
            for key, value in json_log_map.items():
                if isinstance(value, datetime):
                    json_log_map[key] = value.isoformat()

            response = requests.post(
                f'{ERROR_SERVER_HOST}:{ERROR_SERVER_PORT}/log/flask',
                json=json_log_map 
            ) 

            if response.status_code == 200:
                print("Log saved successfully")
            else:
                print(f"Failed to save log. Status: {response.status_code}")

        except requests.exceptions.RequestException as e:
            print(f"Request failed: {e}")

