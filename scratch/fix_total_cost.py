import re

def fix_total_cost(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    calc_pattern = r'final totalCost = selectedProduct!\.unitPrice \* \(int\.tryParse\(quantityC\.text\) \?\? 0\);'
    
    new_calc = r"""int quantity = int.tryParse(quantityC.text) ?? 0;
      int subtotal = selectedProduct!.unitPrice * quantity;
      int totalCost = subtotal;

      if ((selectedProduct!.discountPercent ?? 0) > 0) {
        double discountAmount = subtotal * (selectedProduct!.discountPercent! / 100);
        if (selectedProduct!.discountMax != null && discountAmount > selectedProduct!.discountMax!) {
          discountAmount = selectedProduct!.discountMax!.toDouble();
        }
        totalCost = subtotal - discountAmount.toInt();
      }"""

    content = re.sub(calc_pattern, new_calc, content)

    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)

fix_total_cost(r'd:\Project\Flutter\mierp\lib\features\add\presentation\add_product_order\add_product_order_view.dart')
fix_total_cost(r'd:\Project\Flutter\mierp\lib\features\add\presentation\add_sales_order\add_sales_order_view.dart')

print("Total cost calculations fixed.")
