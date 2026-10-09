import re

def remove_dummy(file_path, is_sales=False):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Revert in DetailProductOrderView
    if not is_sales:
        content = content.replace('// DUMMY DATA FOR TESTING\n                                          if (true)', 'if ((state.orderProduct!.discountPercent ?? 0) > 0)')
        content = content.replace('Discount: ${state.orderProduct!.discountPercent ?? 40}% (Max: ${(state.orderProduct!.discountMax ?? 20000) / 1000}rb)', 'Discount: ${state.orderProduct!.discountPercent}% (Max: ${(state.orderProduct!.discountMax ?? 0) / 1000}rb)')
        content = content.replace('// DUMMY DATA FOR TESTING\n                                    if (true)', 'if ((state.orderProduct!.discountPercent ?? 0) > 0)')
        content = content.replace('_buildDataRow("Discount", "${state.orderProduct!.discountPercent ?? 40}% (Max: ${converDollar.intToDollar(state.orderProduct!.discountMax ?? 20000)})"),', '_buildDataRow("Discount", "${state.orderProduct!.discountPercent}% (Max: ${converDollar.intToDollar(state.orderProduct!.discountMax ?? 0)})"),')

    # Revert in DetailSalesOrderView
    else:
        content = content.replace('// DUMMY DATA FOR TESTING\n                                          if (true)', 'if ((state.salesOrder!.discountPercent ?? 0) > 0)')
        content = content.replace('Discount: ${state.salesOrder!.discountPercent ?? 40}% (Max: ${(state.salesOrder!.discountMax ?? 20000) / 1000}rb)', 'Discount: ${state.salesOrder!.discountPercent}% (Max: ${(state.salesOrder!.discountMax ?? 0) / 1000}rb)')
        content = content.replace('// DUMMY DATA FOR TESTING\n                                    if (true)', 'if ((state.salesOrder!.discountPercent ?? 0) > 0)')
        content = content.replace('_buildDataRow("Discount", "${state.salesOrder!.discountPercent ?? 40}% (Max: ${convertDollar.intToDollar(state.salesOrder!.discountMax ?? 20000)})"),', '_buildDataRow("Discount", "${state.salesOrder!.discountPercent}% (Max: ${convertDollar.intToDollar(state.salesOrder!.discountMax ?? 0)})"),')

    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)

remove_dummy(r'd:\Project\Flutter\mierp\lib\features\detail\presentation\detail_product_order\detail_product_order_view.dart', False)
remove_dummy(r'd:\Project\Flutter\mierp\lib\features\detail\presentation\detail_sales_order\detail_sales_order_view.dart', True)

print("Dummy data reverted.")
