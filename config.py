from dotenv import load_dotenv
import os

load_dotenv(override=True)

SERVER = os.getenv("SERVER")
DATABASE = os.getenv("DATABASE")
USERNAME = os.getenv("USERNAME")
PASSWORD = os.getenv("PASSWORD")
DRIVER = os.getenv("DRIVER")
