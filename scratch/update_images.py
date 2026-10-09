import urllib.request
import urllib.error
import json

PROJECT_ID = "mierp-apps"
API_KEY = "AIzaSyCZp1K6dGvQ7GsjNtU-S-8Rt_kMbt5Ez-4"
EMAIL = "admin@mierp.com"
PASSWORD = "password123"

# 1. Authenticate
auth_url = f"https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key={API_KEY}"
auth_data = json.dumps({
    "email": EMAIL,
    "password": PASSWORD,
    "returnSecureToken": True
}).encode('utf-8')

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

def patch_image(collection, doc_id, image_url):
    url = f"{BASE_URL}/{collection}/{doc_id}?updateMask.fieldPaths=image_product"
    data = {
        "fields": {
            "image_product": {"stringValue": image_url}
        }
    }
    req = urllib.request.Request(url, method="PATCH", data=json.dumps(data).encode('utf-8'))
    req.add_header('Content-Type', 'application/json')
    req.add_header('Authorization', f'Bearer {id_token}')
    try:
        with urllib.request.urlopen(req) as response:
            print(f"Updated {collection}/{doc_id}")
    except urllib.error.HTTPError as e:
        print(f"Error {e.code} on {collection}/{doc_id}: {e.read().decode()}")

mouse_url = "https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80"
chair_url = "https://images.unsplash.com/photo-1505843490538-5133c6c7d0e1?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80"

# Product 1
patch_image("products", "WJqgUcW3VgSlpKt57u4m", mouse_url)
patch_image("warehouse_orders", "Pi1SfLWVlTtH4hXN2bBA", mouse_url)
patch_image("sales_orders", "F1nQxqlsdKcHwK2d6l6w", mouse_url)

# Product 2
patch_image("products", "2rqNijoayIPsBV1fR3CJ", chair_url)
patch_image("warehouse_orders", "WDnusOI3ansXNXU73veD", chair_url)
patch_image("sales_orders", "j7N2O3i1HbSQ66Nhi9Hc", chair_url)

