import re

file_path = r"d:\Project\Flutter\mierp\lib\features\add\presentation\add_product_order\add_product_order_view.dart"
with open(file_path, 'r', encoding='utf-8') as f:
    code = f.read()

# Make selectedProduct of type Product?
code = code.replace('String selectedProductName = "";', 'Product? selectedProduct;')

# Fix init state to fetch products
init_state = """
  @override
  void initState() {
    super.initState();
    context.read<AddProductOrderBloc>().add(AddProductOrderLoadProducts());
  }

  void _submitData(BuildContext context) {"""
code = code.replace("  void _submitData(BuildContext context) {", init_state)

# Fix productOrder creation
# ProductOrder fields:
# id, financeApproved, financeApprovedDate, orderDate, productId, productCode, productName, quantity, totalCost, unitPrice, userId, firstName, imageProduct
# Wait, OrderProduct expects all these according to add_product_order_view_model.dart.
# Let me look at OrderProduct model in core/models/order.dart

# Let's use string replace for submitData body first
old_submit = """      final productOrder = ProductOrder(
        id: "", // Assign dynamically in API if necessary
        orderDate: orderDateC.text,
        productName: selectedProductName,
        quantity: int.tryParse(quantityC.text) ?? 0,
      );

      context.read<AddProductOrderBloc>().add(AddProductOrderSubmitted(
        productOrder: productOrder,
      ));"""

new_submit = """      if (selectedProduct == null) {
        getx.Get.snackbar("Failed", "Please select a product");
        return;
      }
      
      final totalCost = selectedProduct!.unitPrice * (int.tryParse(quantityC.text) ?? 0);
      
      final productOrder = OrderProduct(
        id: '',
        financeApproved: false,
        financeApprovedDate: null,
        orderDate: orderDateC.text,
        productId: selectedProduct!.id,
        productCode: selectedProduct!.productCode,
        productName: selectedProduct!.productName,
        quantity: int.tryParse(quantityC.text) ?? 0,
        totalCost: totalCost,
        unitPrice: selectedProduct!.unitPrice,
        userId: '', // AddRepository should handle this or UserDataController
        firstName: '', // AddRepository should handle this
        imageProduct: selectedProduct!.imageProduct ?? "",
      );

      context.read<AddProductOrderBloc>().add(AddProductOrderSubmitted(
        productOrder: productOrder,
      ));"""
code = code.replace(old_submit, new_submit)
code = code.replace("import 'package:mierp_apps/core/models/product_order.dart';", "import 'package:mierp_apps/core/models/order.dart';")

# Fix reset form
old_reset = """    setState(() {
      selectedProductName = "";
    });"""
new_reset = """    setState(() {
      selectedProduct = null;
    });"""
code = code.replace(old_reset, new_reset)

# Fix dropdown usage
old_dropdown = """                                    InputSelectProductOrderWidget(
                                      head: "Name Product",
                                      placeholder: "placeholder",
                                      necessary: true,
                                      formKey: formKey,
                                      value: selectedProductName,
                                      onChanged: (val) {
                                        if (val != null) {
                                          setState(() {
                                            selectedProductName = val;
                                          });
                                        }
                                      },
                                    ),"""
new_dropdown = """                                    InputSelectProductOrderWidget(
                                      head: "Name Product",
                                      placeholder: "placeholder",
                                      necessary: true,
                                      formKey: formKey,
                                      products: state.listProduct,
                                      value: selectedProduct,
                                      onChanged: (val) {
                                        if (val != null) {
                                          setState(() {
                                            selectedProduct = val;
                                          });
                                        }
                                      },
                                    ),"""
code = code.replace(old_dropdown, new_dropdown)


# BlocProvider doesn't know context for initState since we put initState in View State but BlocProvider wraps Scaffold.
# I need to move BlocProvider outside or trigger load event inside BlocProvider cascade `..add(AddProductOrderLoadProducts())`!
# Ah! Since `AddProductOrderView` State needs `context.read`, the `BlocProvider` must be outside `AddProductOrderView`.
# Wait, currently `AddProductOrderView` builds `BlocProvider`. So `initState` cannot use `context.read<AddProductOrderBloc>()`.
# I will change `create: (context) => sl<AddProductOrderBloc>()` to `create: (context) => sl<AddProductOrderBloc>()..add(AddProductOrderLoadProducts())` and remove `initState`.

code = code.replace("create: (context) => sl<AddProductOrderBloc>(),", "create: (context) => sl<AddProductOrderBloc>()..add(AddProductOrderLoadProducts()),")
code = code.replace("""  @override
  void initState() {
    super.initState();
    context.read<AddProductOrderBloc>().add(AddProductOrderLoadProducts());
  }

  void _submitData""", "  void _submitData")

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(code)

print("Fixed add_product_order_view.dart")
