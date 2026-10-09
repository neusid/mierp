import urllib.request
import urllib.error
import json
import random

PROJECT_ID = "mierp-apps"
API_KEY = "AIzaSyCZp1K6dGvQ7GsjNtU-S-8Rt_kMbt5Ez-4"
EMAIL = "admin@mierp.com"
PASSWORD = "password123"

# Unsplash gallery
IMAGES = [
    "https://images.unsplash.com/photo-1517336714731-489689fd1ca8?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80", # Macbook
    "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80", # Headphones
    "https://images.unsplash.com/photo-1516035069371-29a1b244cc32?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80", # Camera
    "https://images.unsplash.com/photo-1523275335684-37898b6baf30?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80", # Smartwatch
    "https://images.unsplash.com/photo-1505843490538-5133c6c7d0e1?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80", # Chair
    "https://images.unsplash.com/photo-1518455027359-f3f8164ba6bd?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80", # Workspace
    "https://images.unsplash.com/photo-1542291026-7eec264c27ff?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80", # Shoes
    "https://images.unsplash.com/photo-1497935586351-b67a49e012bf?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80", # Coffee
    "https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80", # Mouse
    "https://images.unsplash.com/photo-1583394838336-acd977736f90?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80", # Keyboard
]

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

def patch_image(collection, doc_id, image_url):
    url = f"{BASE_URL}/{collection}/{doc_id}?updateMask.fieldPaths=image_product"
    data = {"fields": {"image_product": {"stringValue": image_url}}}
    req = urllib.request.Request(url, method="PATCH", data=json.dumps(data).encode('utf-8'))
    req.add_header('Content-Type', 'application/json')
    req.add_header('Authorization', f'Bearer {id_token}')
    try:
        urllib.request.urlopen(req)
        print(f"Updated {collection}/{doc_id}")
    except urllib.error.HTTPError as e:
        pass # ignore errors on individual patches

print("Fetching collections...")
products = get_collection("products")
warehouse_orders = get_collection("warehouse_orders")
sales_orders = get_collection("sales_orders")

# Map of product_id to image_url
product_image_map = {}
img_idx = 0

for doc in products:
    doc_id = doc["name"].split("/")[-1]
    # Check if existing image is nice
    fields = doc.get("fields", {})
    existing_img = fields.get("image_product", {}).get("stringValue", "")
    
    if "unsplash" not in existing_img:
        new_img = IMAGES[img_idx % len(IMAGES)]
        img_idx += 1
        product_image_map[doc_id] = new_img
        patch_image("products", doc_id, new_img)
    else:
        product_image_map[doc_id] = existing_img

for doc in warehouse_orders:
    doc_id = doc["name"].split("/")[-1]
    fields = doc.get("fields", {})
    existing_img = fields.get("image_product", {}).get("stringValue", "")
    prod_id = fields.get("product_id", {}).get("stringValue", "")
    
    if "unsplash" not in existing_img:
        target_img = product_image_map.get(prod_id, IMAGES[random.randint(0, len(IMAGES)-1)])
        patch_image("warehouse_orders", doc_id, target_img)

for doc in sales_orders:
    doc_id = doc["name"].split("/")[-1]
    fields = doc.get("fields", {})
    existing_img = fields.get("image_product", {}).get("stringValue", "")
    prod_id = fields.get("product_id", {}).get("stringValue", "")
    
    if "unsplash" not in existing_img:
        target_img = product_image_map.get(prod_id, IMAGES[random.randint(0, len(IMAGES)-1)])
        patch_image("sales_orders", doc_id, target_img)

print("Mass update complete!")
