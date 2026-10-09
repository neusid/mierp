import re

def update_detail_order(file_path, is_sales=False):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    if not is_sales:
        target = r'_buildDataRow\("Unit Price", converDollar\.intToDollar\(state\.orderProduct!\.unitPrice\)\),'
        replacement = r'_buildDataRow("Unit Price", converDollar.intToDollar(state.orderProduct!.unitPrice)),\n                                    if ((state.orderProduct!.discountPercent ?? 0) > 0)\n                                      _buildDataRow("Discount", "${state.orderProduct!.discountPercent}% (Max: ${converDollar.intToDollar(state.orderProduct!.discountMax ?? 0)})"),'
    else:
        target = r'_buildDataRow\("Unit Price", convertDollar\.intToDollar\(state\.salesOrder!\.unitPrice\)\),'
        replacement = r'_buildDataRow("Unit Price", convertDollar.intToDollar(state.salesOrder!.unitPrice)),\n                                    if ((state.salesOrder!.discountPercent ?? 0) > 0)\n                                      _buildDataRow("Discount", "${state.salesOrder!.discountPercent}% (Max: ${convertDollar.intToDollar(state.salesOrder!.discountMax ?? 0)})"),'

    content = re.sub(target, replacement, content)

    # Also fix empty string image crash if it's there
    if not is_sales:
        img_target = r'state\.orderProduct!\.imageProduct\.isEmpty'
        img_replacement = r'(state.orderProduct!.imageProduct == null || state.orderProduct!.imageProduct.isEmpty)'
        content = re.sub(img_target, img_replacement, content)
    else:
        img_target = r'state\.salesOrder!\.imageProduct\.isEmpty'
        img_replacement = r'(state.salesOrder!.imageProduct == null || state.salesOrder!.imageProduct.isEmpty)'
        content = re.sub(img_target, img_replacement, content)

    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)

update_detail_order(r'd:\Project\Flutter\mierp\lib\features\detail\presentation\detail_product_order\detail_product_order_view.dart')
update_detail_order(r'd:\Project\Flutter\mierp\lib\features\detail\presentation\detail_sales_order\detail_sales_order_view.dart', is_sales=True)

print("Detail orders updated.")
