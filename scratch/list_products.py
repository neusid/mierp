import urllib.request
import urllib.error
import json

PROJECT_ID = "mierp-apps"
API_KEY = "AIzaSyCZp1K6dGvQ7GsjNtU-S-8Rt_kMbt5Ez-4"
EMAIL = "admin@mierp.com"
PASSWORD = "password123"

# 1. Authenticate
auth_url = f"https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key={API_KEY}"
auth_data = json.dumps({"email": EMAIL, "password": PASSWORD, "returnSecureToken": True}).encode('utf-8')
try:
    req = urllib.request.Request(auth_url, data=auth_data, method='POST')
    req.add_header('Content-Type', 'application/json')
    with urllib.request.urlopen(req) as response:
        auth_res = json.loads(response.read().decode())
        id_token = auth_res['idToken']
except urllib.error.HTTPError as e:
    print(f"Auth Error {e.code}: {e.read().decode()}")
    exit(1)

BASE_URL = f"https://firestore.googleapis.com/v1/projects/{PROJECT_ID}/databases/(default)/documents"

def get_collection(collection):
    url = f"{BASE_URL}/{collection}?pageSize=100"
    req = urllib.request.Request(url, method="GET")
    req.add_header('Authorization', f'Bearer {id_token}')
    try:
        with urllib.request.urlopen(req) as response:
            return json.loads(response.read().decode()).get("documents", [])
    except Exception as e:
        print(f"Error fetching {collection}: {e}")
        return []

products = get_collection("products")
for doc in products:
    doc_id = doc["name"].split("/")[-1]
    fields = doc.get("fields", {})
    name = fields.get("product_name", {}).get("stringValue", "")
    print(f"ID: {doc_id} | Name: {name}")

