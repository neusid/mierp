import urllib.request
import urllib.error
import json
import datetime

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
        user_id = auth_res['localId']
        print("Successfully authenticated.")
except urllib.error.HTTPError as e:
    print(f"Auth Error {e.code}: {e.read().decode()}")
    exit(1)

# 2. Setup Firestore Helper
BASE_URL = f"https://firestore.googleapis.com/v1/projects/{PROJECT_ID}/databases/(default)/documents"

def post_doc(collection, data):
    url = f"{BASE_URL}/{collection}"
    req = urllib.request.Request(url, method="POST", data=json.dumps(data).encode('utf-8'))
    req.add_header('Content-Type', 'application/json')
    req.add_header('Authorization', f'Bearer {id_token}')
    try:
        with urllib.request.urlopen(req) as response:
            res = json.loads(response.read().decode())
            print(f"Created in {collection}: {res['name'].split('/')[-1]}")
            return res['name'].split('/')[-1]
    except urllib.error.HTTPError as e:
        print(f"Error {e.code}: {e.read().decode()}")
        return None

def wrap_str(v): return {"stringValue": str(v)}
def wrap_int(v): return {"integerValue": str(v)}
def wrap_bool(v): return {"booleanValue": v}

# 3. Create 2 Products
products = [
    {
        "category": wrap_str("electronics"),
        "created_on": wrap_str(datetime.datetime.now().strftime("%Y-%m-%d")),
        "image_product": wrap_str(""),
        "product_name": wrap_str("Logitech MX Master 3S"),
        "product_code": wrap_str("LOG-MX-3S"),
        "quantity": wrap_int(50),
        "unit_price": wrap_int(1500000),
        "discount_percent": wrap_int(20),
        "discount_max": wrap_int(200000)
    },
    {
        "category": wrap_str("furniture"),
        "created_on": wrap_str(datetime.datetime.now().strftime("%Y-%m-%d")),
        "image_product": wrap_str(""),
        "product_name": wrap_str("ErgoChair Pro"),
        "product_code": wrap_str("FRN-ERG-01"),
        "quantity": wrap_int(20),
        "unit_price": wrap_int(4500000),
        "discount_percent": wrap_int(10),
        "discount_max": wrap_int(300000)
    }
]

product_ids = []
for p in products:
    doc_id = post_doc("products", {"fields": p})
    if doc_id:
        product_ids.append((doc_id, p))

# 4. Create 2 Product Orders
for i, (pid, p_data) in enumerate(product_ids):
    qty = 5
    unit_price = int(p_data["unit_price"]["integerValue"])
    disc_pct = int(p_data["discount_percent"]["integerValue"])
    disc_max = int(p_data["discount_max"]["integerValue"])
    
    subtotal = unit_price * qty
    disc_amount = int(subtotal * (disc_pct / 100))
    if disc_amount > disc_max:
        disc_amount = disc_max
    total_cost = subtotal - disc_amount

    order = {
        "finance_approved": wrap_bool(False),
        "finance_approved_date": wrap_str(""),
        "order_date": wrap_str(datetime.datetime.now().strftime("%Y-%m-%d")),
        "product_id": wrap_str(pid),
        "product_code": p_data["product_code"],
        "product_name": p_data["product_name"],
        "quantity": wrap_int(qty),
        "total_cost": wrap_int(total_cost),
        "unit_price": p_data["unit_price"],
        "discount_percent": p_data["discount_percent"],
        "discount_max": p_data["discount_max"],
        "user_id": wrap_str(user_id),
        "first_name": wrap_str("Oksar (Admin)"),
        "image_product": p_data["image_product"]
    }
    post_doc("warehouse_orders", {"fields": order})

# 5. Create 2 Sales Orders
for i, (pid, p_data) in enumerate(product_ids):
    qty = 2
    unit_price = int(p_data["unit_price"]["integerValue"])
    disc_pct = int(p_data["discount_percent"]["integerValue"])
    disc_max = int(p_data["discount_max"]["integerValue"])
    
    subtotal = unit_price * qty
    disc_amount = int(subtotal * (disc_pct / 100))
    if disc_amount > disc_max:
        disc_amount = disc_max
    total_price = subtotal - disc_amount

    sales_order = {
        "company_name": wrap_str("PT Maju Bersama"),
        "finance_approved": wrap_bool(False),
        "finance_approved_date": wrap_str(""),
        "first_name": wrap_str("Oksar (Admin)"),
        "payment_status": wrap_bool(False),
        "product_code": p_data["product_code"],
        "product_id": wrap_str(pid),
        "product_name": p_data["product_name"],
        "purchased_date": wrap_str(datetime.datetime.now().strftime("%Y-%m-%d")),
        "quantity": wrap_int(qty),
        "total_price": wrap_int(total_price),
        "unit_price": p_data["unit_price"],
        "discount_percent": p_data["discount_percent"],
        "discount_max": p_data["discount_max"],
        "user_id": wrap_str(user_id),
        "image_product": p_data["image_product"]
    }
    post_doc("sales_orders", {"fields": sales_order})

