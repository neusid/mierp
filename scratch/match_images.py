import urllib.request
import urllib.error
import json

PROJECT_ID = "mierp-apps"
API_KEY = "AIzaSyCZp1K6dGvQ7GsjNtU-S-8Rt_kMbt5Ez-4"
EMAIL = "admin@mierp.com"
PASSWORD = "password123"

# Extremely plain, minimalist, studio-background Unsplash images mapped to product names
IMAGE_MAP = {
    "ergochair": "https://images.unsplash.com/photo-1505843490538-5133c6c7d0e1?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80", # Office chair on plain bg
    "logitech": "https://images.unsplash.com/photo-1615663245857-ac93bb7c3c9c?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80", # Mouse on plain white
    "xiaomi": "https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80", # Minimalist phone on white
    "legion": "https://images.unsplash.com/photo-1593640408182-31c70c8268f5?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80", # Laptop on clean studio bg
    "iphone": "https://images.unsplash.com/photo-1616348436168-de43ad0db179?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80", # iPhone on plain white
    "apple watch": "https://images.unsplash.com/photo-1434493789847-2f02dc6ca35d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80", # Apple watch on plain white
    "asus": "https://images.unsplash.com/photo-1496181133206-80ce9b88a853?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80", # Clean laptop on white desk
    "sss": "https://images.unsplash.com/photo-1523275335684-37898b6baf30?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80" # Minimalist watch/gadget
}

print("Authenticating...")
auth_url = f"https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key={API_KEY}"
auth_data = json.dumps({"email": EMAIL, "password": PASSWORD, "returnSecureToken": True}).encode('utf-8')
try:
    req = urllib.request.Request(auth_url, data=auth_data, method='POST')
    req.add_header('Content-Type', 'application/json')
    with urllib.request.urlopen(req) as response:
        id_token = json.loads(response.read().decode())['idToken']
except Exception as e:
    print("Auth failed", e)
    exit(1)

BASE_URL = f"https://firestore.googleapis.com/v1/projects/{PROJECT_ID}/databases/(default)/documents"

def get_collection(col):
    url = f"{BASE_URL}/{col}?pageSize=100"
    req = urllib.request.Request(url, method="GET")
    req.add_header('Authorization', f'Bearer {id_token}')
    try:
        with urllib.request.urlopen(req) as response:
            return json.loads(response.read().decode()).get("documents", [])
    except Exception as e:
        print("Failed to fetch", col, e)
        return []

def patch_image(col, doc_id, image_url):
    url = f"{BASE_URL}/{col}/{doc_id}?updateMask.fieldPaths=image_product"
    data = {"fields": {"image_product": {"stringValue": image_url}}}
    req = urllib.request.Request(url, method="PATCH", data=json.dumps(data).encode('utf-8'))
    req.add_header('Content-Type', 'application/json')
    req.add_header('Authorization', f'Bearer {id_token}')
    try:
        urllib.request.urlopen(req)
        print(f"Updated {col}/{doc_id} with plain matching image")
    except Exception as e:
        print(f"Failed to update {col}/{doc_id}", e)

print("Fetching and updating...")
for col in ["products", "warehouse_orders", "sales_orders"]:
    docs = get_collection(col)
    for doc in docs:
        doc_id = doc["name"].split("/")[-1]
        fields = doc.get("fields", {})
        name = fields.get("product_name", {}).get("stringValue", "").lower()
        
        # Find matching image
        matched = False
        for key, url in IMAGE_MAP.items():
            if key in name:
                patch_image(col, doc_id, url)
                matched = True
                break
        
        if not matched and name:
            # Fallback for anything else: just use a plain gadget/laptop image
            patch_image(col, doc_id, "https://images.unsplash.com/photo-1517336714731-489689fd1ca8?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80")

print("Done! All specific products matched to plain studio backgrounds.")
