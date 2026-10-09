import re

def update_add_order(file_path, is_sales=False):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Find the object creation part
    if not is_sales:
        replacement = r'imageProduct: selectedProduct!.imageProduct ?? "",\n        discountPercent: selectedProduct!.discountPercent,\n        discountMax: selectedProduct!.discountMax,'
        content = re.sub(r'imageProduct:\s*selectedProduct!\.imageProduct\s*\?\?\s*"",', replacement, content)
    else:
        # Check sales order view
        replacement = r'imageProduct: selectedProduct!.imageProduct ?? "",\n        discountPercent: selectedProduct!.discountPercent,\n        discountMax: selectedProduct!.discountMax,'
        content = re.sub(r'imageProduct:\s*selectedProduct!\.imageProduct\s*\?\?\s*"",', replacement, content)

    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)

update_add_order(r'd:\Project\Flutter\mierp\lib\features\add\presentation\add_product_order\add_product_order_view.dart')
update_add_order(r'd:\Project\Flutter\mierp\lib\features\add\presentation\add_sales_order\add_sales_order_view.dart', is_sales=True)

print("Add order views updated.")
