import re

def insert_dummy(file_path, is_sales=False):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # For DetailProductOrderView
    if not is_sales:
        # pill part
        content = re.sub(
            r'if \(\(state\.orderProduct!\.discountPercent \?\? 0\) > 0\)',
            r'// DUMMY DATA FOR TESTING\n                                          if (true)',
            content
        )
        content = re.sub(
            r'Discount: \$\{state\.orderProduct!\.discountPercent\}%\s*\(Max:\s*\$\{\(state\.orderProduct!\.discountMax\s*\?\?\s*0\)\s*/\s*1000\}rb\)',
            r'Discount: ${state.orderProduct!.discountPercent ?? 40}% (Max: ${(state.orderProduct!.discountMax ?? 20000) / 1000}rb)',
            content
        )
        
        # summary part
        content = re.sub(
            r'if \(\(state\.orderProduct!\.discountPercent \?\? 0\) > 0\)',
            r'// DUMMY DATA FOR TESTING\n                                    if (true)',
            content
        )
        content = re.sub(
            r'_buildDataRow\("Discount", "\$\{state\.orderProduct!\.discountPercent\}%\s*\(Max:\s*\$\{converDollar\.intToDollar\(state\.orderProduct!\.discountMax\s*\?\?\s*0\)\}\)"\),',
            r'_buildDataRow("Discount", "${state.orderProduct!.discountPercent ?? 40}% (Max: ${converDollar.intToDollar(state.orderProduct!.discountMax ?? 20000)})"),',
            content
        )

    # For DetailSalesOrderView
    else:
        # pill part
        content = re.sub(
            r'if \(\(state\.salesOrder!\.discountPercent \?\? 0\) > 0\)',
            r'// DUMMY DATA FOR TESTING\n                                          if (true)',
            content
        )
        content = re.sub(
            r'Discount: \$\{state\.salesOrder!\.discountPercent\}%\s*\(Max:\s*\$\{\(state\.salesOrder!\.discountMax\s*\?\?\s*0\)\s*/\s*1000\}rb\)',
            r'Discount: ${state.salesOrder!.discountPercent ?? 40}% (Max: ${(state.salesOrder!.discountMax ?? 20000) / 1000}rb)',
            content
        )
        
        # summary part
        content = re.sub(
            r'if \(\(state\.salesOrder!\.discountPercent \?\? 0\) > 0\)',
            r'// DUMMY DATA FOR TESTING\n                                    if (true)',
            content
        )
        content = re.sub(
            r'_buildDataRow\("Discount", "\$\{state\.salesOrder!\.discountPercent\}%\s*\(Max:\s*\$\{convertDollar\.intToDollar\(state\.salesOrder!\.discountMax\s*\?\?\s*0\)\}\)"\),',
            r'_buildDataRow("Discount", "${state.salesOrder!.discountPercent ?? 40}% (Max: ${convertDollar.intToDollar(state.salesOrder!.discountMax ?? 20000)})"),',
            content
        )

    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)

insert_dummy(r'd:\Project\Flutter\mierp\lib\features\detail\presentation\detail_product_order\detail_product_order_view.dart', False)
insert_dummy(r'd:\Project\Flutter\mierp\lib\features\detail\presentation\detail_sales_order\detail_sales_order_view.dart', True)

print("Dummy data inserted.")
