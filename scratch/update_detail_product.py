import re

def update_detail_product_order():
    file_path = r'd:\Project\Flutter\mierp\lib\features\detail\presentation\detail_product_order\detail_product_order_view.dart'
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    target = """                                      _buildDataRow("Quantity", state.orderProduct!.quantity.toString()),
                                      _buildDataRow("Unit Price", converDollar.intToDollar(state.orderProduct!.unitPrice)),
                                      if ((state.orderProduct!.discountPercent ?? 0) > 0)
                                        _buildDataRow("Discount", "${state.orderProduct!.discountPercent}% (Max: ${converDollar.intToDollar(state.orderProduct!.discountMax ?? 0)})"),
                                      Divider(color: const Color(0xFFF1F5F9), height: 24.h, thickness: 1.w),
                                      _buildDataRow("Line Total", converDollar.intToDollar(state.orderProduct!.totalCost), isBold: true),"""

    replacement = """                                      _buildDataRow("Quantity", state.orderProduct!.quantity.toString()),
                                      _buildDataRow("Unit Price", converDollar.intToDollar(state.orderProduct!.unitPrice)),
                                      _buildDataRow("Subtotal", converDollar.intToDollar(state.orderProduct!.quantity * state.orderProduct!.unitPrice)),
                                      if ((state.orderProduct!.quantity * state.orderProduct!.unitPrice) - state.orderProduct!.totalCost > 0)
                                        _buildDataRow("Discount Amount", "-${converDollar.intToDollar((state.orderProduct!.quantity * state.orderProduct!.unitPrice) - state.orderProduct!.totalCost)} (${state.orderProduct!.discountPercent}%)", textColor: Colors.red),
                                      Divider(color: const Color(0xFFF1F5F9), height: 24.h, thickness: 1.w),
                                      _buildDataRow("Line Total", converDollar.intToDollar(state.orderProduct!.totalCost), isBold: true),"""

    if target in content:
        content = content.replace(target, replacement)
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(content)
        print("Updated detail_product_order_view.dart")
    else:
        print("Target not found in detail_product_order_view.dart")

update_detail_product_order()
