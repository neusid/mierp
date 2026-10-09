import re

def update_detail_product_order():
    file_path = r'd:\Project\Flutter\mierp\lib\features\detail\presentation\detail_product_order\detail_product_order_view.dart'
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Find where it has _buildDataRow("Quantity"...) and up to Line Total
    # And replace with Subtotal + Discount
    
    # We can match: _buildDataRow("Quantity", state.orderProduct!.quantity.toString()),
    # up to: _buildDataRow("Line Total", converDollar.intToDollar(state.orderProduct!.totalCost), isBold: true),
    
    pattern = re.compile(
        r'_buildDataRow\("Quantity", state\.orderProduct!\.quantity\.toString\(\)\),\s*'
        r'_buildDataRow\("Unit Price", converDollar\.intToDollar\(state\.orderProduct!\.unitPrice\)\),\s*'
        r'(?:if\s*\(\(state\.orderProduct!\.discountPercent\s*\?\?\s*0\)\s*>\s*0\)\s*'
        r'_buildDataRow\("Discount", ".*?\"\),\s*)?'
        r'Divider\(color: const Color\(0xFFF1F5F9\), height: 24\.h, thickness: 1\.w\),\s*'
        r'_buildDataRow\("Line Total", converDollar\.intToDollar\(state\.orderProduct!\.totalCost\), isBold: true\),'
    )
    
    replacement = """_buildDataRow("Quantity", state.orderProduct!.quantity.toString()),
                                      _buildDataRow("Unit Price", converDollar.intToDollar(state.orderProduct!.unitPrice)),
                                      _buildDataRow("Subtotal", converDollar.intToDollar(state.orderProduct!.quantity * state.orderProduct!.unitPrice)),
                                      if (((state.orderProduct!.quantity * state.orderProduct!.unitPrice) - state.orderProduct!.totalCost) > 0)
                                        _buildDataRow("Discount", "-${converDollar.intToDollar((state.orderProduct!.quantity * state.orderProduct!.unitPrice) - state.orderProduct!.totalCost)} (${state.orderProduct!.discountPercent}%)"),
                                      Divider(color: const Color(0xFFF1F5F9), height: 24.h, thickness: 1.w),
                                      _buildDataRow("Line Total", converDollar.intToDollar(state.orderProduct!.totalCost), isBold: true),"""
                                      
    content = pattern.sub(replacement, content)
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)

def update_detail_sales_order():
    file_path = r'd:\Project\Flutter\mierp\lib\features\detail\presentation\detail_sales_order\detail_sales_order_view.dart'
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    pattern = re.compile(
        r'_buildDataRow\("Quantity", state\.salesOrder!\.quantity\.toString\(\)\),\s*'
        r'_buildDataRow\("Unit Price", convertDollar\.intToDollar\(state\.salesOrder!\.unitPrice\)\),\s*'
        r'(?:if\s*\(\(state\.salesOrder!\.discountPercent\s*\?\?\s*0\)\s*>\s*0\)\s*'
        r'_buildDataRow\("Discount", ".*?\"\),\s*)?'
        r'Divider\(color: const Color\(0xFFF1F5F9\), height: 24\.h, thickness: 1\.w\),\s*'
        r'_buildDataRow\("Line Total", convertDollar\.intToDollar\(state\.salesOrder!\.totalPrice\), isBold: true\),'
    )
    
    replacement = """_buildDataRow("Quantity", state.salesOrder!.quantity.toString()),
                                      _buildDataRow("Unit Price", convertDollar.intToDollar(state.salesOrder!.unitPrice)),
                                      _buildDataRow("Subtotal", convertDollar.intToDollar(state.salesOrder!.quantity * state.salesOrder!.unitPrice)),
                                      if (((state.salesOrder!.quantity * state.salesOrder!.unitPrice) - state.salesOrder!.totalPrice) > 0)
                                        _buildDataRow("Discount", "-${convertDollar.intToDollar((state.salesOrder!.quantity * state.salesOrder!.unitPrice) - state.salesOrder!.totalPrice)} (${state.salesOrder!.discountPercent}%)"),
                                      Divider(color: const Color(0xFFF1F5F9), height: 24.h, thickness: 1.w),
                                      _buildDataRow("Line Total", convertDollar.intToDollar(state.salesOrder!.totalPrice), isBold: true),"""
                                      
    content = pattern.sub(replacement, content)
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)

update_detail_product_order()
update_detail_sales_order()
print("Done")
