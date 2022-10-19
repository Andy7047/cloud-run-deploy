import argparse
from io import BytesIO
import os
import traceback
from smart_open import open
import zipfile

env = os.environ["Environment"]
s3_source = os.environ["S3Source"]

parser = argparse.ArgumentParser(description="Initialize Exec container")
parser.add_argument("--notebooks-path", required=True, type=str, help="Directory for notebooks.")
args = parser.parse_args()
notebooks_path = args.notebooks_path

try:
    notebooks_key = f"s3://{s3_source}/{env}/notebooks/notebooks.zip"
    notebooks_tmp = f"{notebooks_path}/notebooks.zip"

    os.makedirs(notebooks_path, exist_ok=True)

    print(f"Importing {notebooks_key} to {notebooks_path}")
    notebooks_tmp = BytesIO()
    with open(notebooks_key, "rb") as z: 
        notebooks_tmp.write(z.read())
    notebooks_tmp.seek(0)
    zip_ref = zipfile.ZipFile(notebooks_tmp, "r")
    zip_ref.extractall(notebooks_path)
    print(f"Import complete")

except Exception as e:
    print(e)
    print(traceback.format_tb(e.__traceback__))
    print("Import failed")
    raise ValueError("InitializationError")
