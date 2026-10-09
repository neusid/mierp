import urllib.request
import urllib.error
import json

PROJECT_ID = "mierp-apps"
API_KEY = "AIzaSyCZp1K6dGvQ7GsjNtU-S-8Rt_kMbt5Ez-4"
EMAIL = "admin@mierp.com"
PASSWORD = "password123"

# The broken URL
BROKEN_URL = "https://images.unsplash.com/photo-1598327105666-5b89351cb31b?auto=format&fit=crop&w=800&q=80"
# A working smartphone URL
FIXED_URL = "https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80"

auth_url = f"https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key={API_KEY}"
auth_data = json.dumps({"email": EMAIL, "password": PASSWORD, "returnSecureToken": True}).encode('utf-8')
try:
    req = urllib.request.Request(auth_url, data=auth_data, method='POST')
    req.add_header('Content-Type', 'application/json')
    with urllib.request.urlopen(req) as response:
        id_token = json.loads(response.read().decode())['idToken']
except Exception as e:
    exit(1)

BASE_URL = f"https://firestore.googleapis.com/v1/projects/{PROJECT_ID}/databases/(default)/documents"

def get_collection(col):
    url = f"{BASE_URL}/{col}?pageSize=100"
    req = urllib.request.Request(url, method="GET")
    req.add_header('Authorization', f'Bearer {id_token}')
    try:
        with urllib.request.urlopen(req) as response:
            return json.loads(response.read().decode()).get("documents", [])
    except:
        return []

def patch_image(col, doc_id, image_url):
    url = f"{BASE_URL}/{col}/{doc_id}?updateMask.fieldPaths=image_product"
    data = {"fields": {"image_product": {"stringValue": image_url}}}
    req = urllib.request.Request(url, method="PATCH", data=json.dumps(data).encode('utf-8'))
    req.add_header('Content-Type', 'application/json')
    req.add_header('Authorization', f'Bearer {id_token}')
    try:
        urllib.request.urlopen(req)
        print(f"Updated {col}/{doc_id}")
    except:
        pass

for col in ["products", "warehouse_orders", "sales_orders"]:
    docs = get_collection(col)
    for doc in docs:
        doc_id = doc["name"].split("/")[-1]
        fields = doc.get("fields", {})
        img = fields.get("image_product", {}).get("stringValue", "")
        if img == BROKEN_URL:
            patch_image(col, doc_id, FIXED_URL)

print("Finished fixing 404 images.")
