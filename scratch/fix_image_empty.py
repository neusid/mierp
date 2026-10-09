import re

def fix_image_null_check(file_path, var_name="imageProduct"):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # We want to replace `imageProduct == null` with `imageProduct == null || imageProduct.toString().isEmpty`
    # Or just `imageProduct == null || imageProduct == ""`
    
    pattern = rf'{var_name} == null'
    replacement = f'({var_name} == null || {var_name}.toString().isEmpty)'
    
    content = re.sub(pattern, replacement, content)

    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)

fix_image_null_check(r'd:\Project\Flutter\mierp\lib\core\widgets\card_sales.dart', 'imageProduct')
fix_image_null_check(r'd:\Project\Flutter\mierp\lib\core\widgets\card_order.dart', 'imageProduct')
fix_image_null_check(r'd:\Project\Flutter\mierp\lib\core\widgets\card_stock.dart', 'image')

print("Image null checks fixed.")
