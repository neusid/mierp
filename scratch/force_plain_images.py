import urllib.request
import urllib.error
import json
import random

PROJECT_ID = "mierp-apps"
API_KEY = "AIzaSyCZp1K6dGvQ7GsjNtU-S-8Rt_kMbt5Ez-4"
EMAIL = "admin@mierp.com"
PASSWORD = "password123"

# Extremely plain, minimalist, studio-background Unsplash images
PLAIN_IMAGES = [
    "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80", # Headphones on plain white
    "https://images.unsplash.com/photo-1523275335684-37898b6baf30?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80", # Watch on plain white
    "https://images.unsplash.com/photo-1523293115678-d2902641f993?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80", # Minimalist bottle on plain bg
    "https://images.unsplash.com/photo-1485955900006-10f4d324d411?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80", # Minimalist plant on white
    "https://images.unsplash.com/photo-1507473885765-e6ed057f782c?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80", # Minimalist lamp on white
    "https://images.unsplash.com/photo-1583394838336-acd977736f90?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80", # Keyboard on white
    "https://images.unsplash.com/photo-1517336714731-489689fd1ca8?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80", # Macbook on white
    "https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80", # Mouse on white
    "https://images.unsplash.com/photo-1627384113743-6bd5a479fffd?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80", # Clean white sneakers
]

print("Authenticating...")
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

def patch_image(collection, doc_id, image_url):
    url = f"{BASE_URL}/{collection}/{doc_id}?updateMask.fieldPaths=image_product"
    data = {"fields": {"image_product": {"stringValue": image_url}}}
    req = urllib.request.Request(url, method="PATCH", data=json.dumps(data).encode('utf-8'))
    req.add_header('Content-Type', 'application/json')
    req.add_header('Authorization', f'Bearer {id_token}')
    try:
        urllib.request.urlopen(req)
        print(f"Updated {collection}/{doc_id} to plain image")
    except urllib.error.HTTPError as e:
        print(f"Failed to update {collection}/{doc_id}")

print("Fetching collections...")
products = get_collection("products")
warehouse_orders = get_collection("warehouse_orders")
sales_orders = get_collection("sales_orders")

# Map of product_id to image_url
product_image_map = {}
img_idx = 0

print("Updating products...")
for doc in products:
    doc_id = doc["name"].split("/")[-1]
    new_img = PLAIN_IMAGES[img_idx % len(PLAIN_IMAGES)]
    img_idx += 1
    product_image_map[doc_id] = new_img
    patch_image("products", doc_id, new_img)

print("Updating warehouse orders...")
for doc in warehouse_orders:
    doc_id = doc["name"].split("/")[-1]
    fields = doc.get("fields", {})
    prod_id = fields.get("product_id", {}).get("stringValue", "")
    
    target_img = product_image_map.get(prod_id, PLAIN_IMAGES[random.randint(0, len(PLAIN_IMAGES)-1)])
    patch_image("warehouse_orders", doc_id, target_img)

print("Updating sales orders...")
for doc in sales_orders:
    doc_id = doc["name"].split("/")[-1]
    fields = doc.get("fields", {})
    prod_id = fields.get("product_id", {}).get("stringValue", "")
    
    target_img = product_image_map.get(prod_id, PLAIN_IMAGES[random.randint(0, len(PLAIN_IMAGES)-1)])
    patch_image("sales_orders", doc_id, target_img)

print("All images forcefully updated to plain/minimalist backgrounds!")
