import re

def update_model(file_path, is_product=False):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # 1. Add fields to class definition
    if 'int? discountPercent;' not in content:
        content = re.sub(r'int unitPrice;', r'int unitPrice;\n  int? discountPercent;\n  int? discountMax;', content)
    
    # 2. Add to constructor
    if 'this.discountPercent' not in content:
        content = re.sub(r'required this\.unitPrice,', r'required this.unitPrice,\n    this.discountPercent,\n    this.discountMax,', content)

    # 3. Add to fromJson
    if 'discountPercent:' not in content:
        content = re.sub(r'unitPrice: json\["unit_price"\],', r'unitPrice: json["unit_price"],\n    discountPercent: json["discount_percent"],\n    discountMax: json["discount_max"],', content)

    # 4. Add to toJson
    if '"discount_percent":' not in content:
        content = re.sub(r'"unit_price": unitPrice,', r'"unit_price": unitPrice,\n    "discount_percent": discountPercent,\n    "discount_max": discountMax,', content)

    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)

update_model(r'd:\Project\Flutter\mierp\lib\core\models\product.dart', is_product=True)
update_model(r'd:\Project\Flutter\mierp\lib\core\models\order.dart')
update_model(r'd:\Project\Flutter\mierp\lib\core\models\sales_order.dart')

print("Models updated.")
