import urllib.request
import urllib.error
import json

PROJECT_ID = "mierp-apps"
API_KEY = "AIzaSyCZp1K6dGvQ7GsjNtU-S-8Rt_kMbt5Ez-4"
EMAIL = "admin@mierp.com"
PASSWORD = "password123"

IMAGE_MAP = {
    "ergochair": "https://images.unsplash.com/photo-1505843490538-5133c6c7d0e1?auto=format&fit=crop&w=800&q=80",
    "logitech": "https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?auto=format&fit=crop&w=800&q=80",
    "xiaomi": "https://images.unsplash.com/photo-1598327105666-5b89351cb31b?auto=format&fit=crop&w=800&q=80",
    "legion": "https://images.unsplash.com/photo-1603302576837-37561b2e2302?auto=format&fit=crop&w=800&q=80",
    "iphone": "https://images.unsplash.com/photo-1510557880182-3d4d3cba35a5?auto=format&fit=crop&w=800&q=80",
    "apple watch": "https://images.unsplash.com/photo-1434493789847-2f02dc6ca35d?auto=format&fit=crop&w=800&q=80",
    "asus": "https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=800&q=80",
    "sss": "https://images.unsplash.com/photo-1557672172-298e090bd0f1?auto=format&fit=crop&w=800&q=80"
}

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
        name = fields.get("product_name", {}).get("stringValue", "").lower()
        for key, url in IMAGE_MAP.items():
            if key in name:
                patch_image(col, doc_id, url)
                break
