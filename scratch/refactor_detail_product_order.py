import os
import re

view_path = r"d:\Project\Flutter\mierp\lib\features\detail\presentation\detail_product_order\detail_product_order_view.dart"

with open(view_path, 'r', encoding='utf-8') as f:
    view_code = f.read()

view_code = view_code.replace("import 'package:get/get.dart';", "import 'package:get/get.dart' as getx;\nimport 'package:flutter_bloc/flutter_bloc.dart';\nimport 'package:mierp_apps/core/di/injection_container.dart';\nimport 'package:mierp_apps/features/detail/presentation/detail_product_order/bloc/detail_product_order_bloc.dart';")
view_code = view_code.replace("import 'package:mierp_apps/features/detail/presentation/detail_product_order/detail_product_order_view_model.dart';", "")

view_code = re.sub(
    r"class DetailProductOrderView extends StatelessWidget \{[\s\S]*?final converDollar = ConvertDollar\(\);",
    """class DetailProductOrderView extends StatelessWidget {
  final String id;
  DetailProductOrderView({super.key, required this.id});

  final converDollar = ConvertDollar();""",
    view_code
)

# Build method changes
view_code = re.sub(
    r"@override\s+Widget build\(BuildContext context\) \{[\s\S]*?return Scaffold\(",
    """@override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DetailProductOrderBloc>()..add(DetailProductOrderStarted(id)),
      child: BlocConsumer<DetailProductOrderBloc, DetailProductOrderState>(
        listener: (context, state) {
          if (state.status == DetailProductOrderStatus.paySuccess) {
            getx.Get.snackbar("Success", state.successMessage);
          } else if (state.status == DetailProductOrderStatus.deleteSuccess) {
            getx.Get.snackbar("Success", state.successMessage);
            Future.delayed(Duration(seconds: 2), () {
              getx.Get.toNamed("warehouse_main_page");
            });
          } else if (state.status == DetailProductOrderStatus.failure) {
            getx.Get.snackbar("Failed", state.errorMessage);
          }
        },
        builder: (context, state) {
          return Scaffold(""",
    view_code
)

# Obx for order product null
view_code = re.sub(
    r"Obx\(\(\) \{\s*if \(detailProductOrderVM\.orderProducts\.value == null\) \{",
    """Builder(builder: (context) {
            if (state.orderProduct == null) {""",
    view_code
)

view_code = re.sub(
    r"\}\s*return Container\(\s*width: double.infinity,",
    """}
            return Container(
              width: double.infinity,""",
    view_code
)

# Obx inside container
view_code = re.sub(
    r"child: Obx\(\(\) \{\s*return Column\(",
    """child: Column(""",
    view_code
)

view_code = re.sub(
    r"\}\),\s*\),\s*\]",
    """),
                  ),
                ]""",
    view_code
)

# Obx for container
view_code = re.sub(
    r"\}\)\,\s*Column\(",
    """}),
          Column(""",
    view_code
)

view_code = view_code.replace("detailProductOrderVM.orderProducts.value!", "state.orderProduct!")
view_code = view_code.replace("detailProductOrderVM.orderProducts!.value!", "state.orderProduct!")
view_code = view_code.replace("detailProductOrderVM.role.value", "state.role")

# Buttons and actions
view_code = view_code.replace(
    """detailProductOrderVM.requestDeleteProductOrder(
                                                                      state.orderProduct!
                                                                          .id,
                                                                    );""",
    "context.read<DetailProductOrderBloc>().add(DetailProductOrderDeleteRequested(state.orderProduct!.id!));"
)

view_code = view_code.replace(
    """detailProductOrderVM
                                                    .requestPayProductOrder(
                                                      state.orderProduct!
                                                          .id,
                                                      state.orderProduct!
                                                          .productId,
                                                      state.orderProduct!
                                                          .quantity,
                                                    );""",
    "context.read<DetailProductOrderBloc>().add(DetailProductOrderPayRequested(state.orderProduct!.id!, state.orderProduct!.productId ?? '', state.orderProduct!.quantity ?? 0));"
)

# Back button
view_code = view_code.replace(
    """detailProductOrderVM.itemStore
                                        .clearDetailProduct();
                                    Get.back();""",
    "getx.Get.back();"
)

# Loading state
view_code = re.sub(
    r"Obx\(\s*\(\) => detailProductOrderVM\.isLoading\.value == true",
    "state.status == DetailProductOrderStatus.loading",
    view_code
)

# Close BlocProvider
view_code = re.sub(r"}\s*}\s*$", "        },\n      ),\n    );\n  }\n}", view_code)

with open(view_path, 'w', encoding='utf-8') as f:
    f.write(view_code)

print("Done")
