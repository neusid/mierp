import re

# 1. Update injection_container.dart
injection_path = r"d:\Project\Flutter\mierp\lib\core\di\injection_container.dart"
with open(injection_path, 'r', encoding='utf-8') as f:
    injection_code = f.read()

import_statement = "import 'package:mierp_apps/features/detail/presentation/detail_sales_order/bloc/detail_sales_order_bloc.dart';"
if import_statement not in injection_code:
    injection_code = injection_code.replace(
        "import 'package:mierp_apps/features/detail/presentation/detail_product_order/bloc/detail_product_order_bloc.dart';",
        "import 'package:mierp_apps/features/detail/presentation/detail_product_order/bloc/detail_product_order_bloc.dart';\n" + import_statement
    )

registration_statement = """  // Detail Sales Order
  sl.registerFactory(() => DetailSalesOrderBloc(
        itemRepository: sl(),
        itemStore: sl(),
        transactionServices: sl(),
        detailSalesOrderRepository: sl(),
        userDataController: sl(),
      ));
  sl.registerLazySingleton(() => DetailSalesOrderRepository());"""
if "DetailSalesOrderBloc" not in injection_code:
    injection_code = injection_code.replace(
        "// AddUnit",
        registration_statement + "\n\n  // AddUnit"
    )

with open(injection_path, 'w', encoding='utf-8') as f:
    f.write(injection_code)


# 2. Update detail_sales_order_view.dart
view_path = r"d:\Project\Flutter\mierp\lib\features\detail\presentation\detail_sales_order\detail_sales_order_view.dart"
with open(view_path, 'r', encoding='utf-8') as f:
    view_code = f.read()

# Add imports
view_code = view_code.replace(
    "import 'package:mierp_apps/features/detail/presentation/detail_sales_order/detail_sales_order_view_model.dart';",
    "import 'package:flutter_bloc/flutter_bloc.dart';\nimport 'package:mierp_apps/core/di/injection_container.dart';\nimport 'package:mierp_apps/features/detail/presentation/detail_sales_order/bloc/detail_sales_order_bloc.dart';\nimport 'package:mierp_apps/features/detail/presentation/detail_sales_order/bloc/detail_sales_order_event.dart';\nimport 'package:mierp_apps/features/detail/presentation/detail_sales_order/bloc/detail_sales_order_state.dart';"
)

# Remove unused imports
view_code = view_code.replace("import 'package:mierp_apps/core/controller/move_page_controller.dart';\n", "")
view_code = view_code.replace("import 'package:mierp_apps/core/utils/loading_controller.dart';\n", "")
view_code = view_code.replace("import 'package:get/get.dart';\n", "import 'package:get/get.dart' as getx;\n")


# Change class signature to Stateful to use id from Getx for now (since we use routing without GoRouter)
# Wait, let's keep it StatelessWidget and take `id` as parameter, just like DetailProductOrderView.
view_code = re.sub(
    r"class DetailSalesOrderView extends StatelessWidget \{\n  DetailSalesOrderView\(\{super.key\}\);",
    "class DetailSalesOrderView extends StatelessWidget {\n  final String id;\n  DetailSalesOrderView({super.key, required this.id});",
    view_code
)

# Replace properties and setup BlocConsumer
properties_regex = r"  final movePageC = Get\.find<MovePageController>\(\);\n  final loadingC = Get\.find<LoadingController>\(\);\n  final detailSalesOrderVM = Get\.find<DetailSalesOrderViewModel>\(\);\n  final convertDollar = ConvertDollar\(\);\n\n  @override\n  Widget build\(BuildContext context\) \{"
new_properties = """  final convertDollar = ConvertDollar();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DetailSalesOrderBloc>()..add(DetailSalesOrderStarted(id)),
      child: BlocConsumer<DetailSalesOrderBloc, DetailSalesOrderState>(
        listener: (context, state) {
          if (state.status == DetailSalesOrderStatus.success && state.successMessage.isNotEmpty) {
            getx.Get.snackbar("Success", state.successMessage);
          } else if (state.status == DetailSalesOrderStatus.deleteSuccess) {
            getx.Get.snackbar("Success", state.successMessage);
            Future.delayed(Duration(seconds: 2), () {
              getx.Get.toNamed("warehouse_main_page");
            });
          } else if (state.status == DetailSalesOrderStatus.failure) {
            getx.Get.snackbar("Failed", state.errorMessage);
          }
        },
        builder: (context, state) {"""

view_code = re.sub(properties_regex, new_properties, view_code)

# Remove GetX ever listeners
listeners_regex = r"    ever\(detailSalesOrderVM\.success, \(callback\) \{[\s\S]*?\}\);\n\n    ever\(detailSalesOrderVM\.errorMessage, \(msg\) \{[\s\S]*?\}\);\n\n    return Scaffold\("
view_code = re.sub(listeners_regex, "    return Scaffold(", view_code)


# Replace Obx with Bloc structure and loading condition
view_code = view_code.replace(
"""          Obx(() {
            if (detailSalesOrderVM.salesOrder.value == null) {""",
"""          Builder(builder: (context) {
            if (state.salesOrder == null) {"""
)

# Fix inner Obx
view_code = view_code.replace("                    child: Obx(() {", "                    child: Builder(builder: (context) {")

# Replace variables
view_code = re.sub(r"detailSalesOrderVM[\s\n]*\.salesOrder[\s\n]*\.value!", "state.salesOrder!", view_code)
view_code = re.sub(r"detailSalesOrderVM[\s\n]*\.salesOrder[\s\n]*\.value", "state.salesOrder", view_code)

# Replace role
view_code = re.sub(r"detailSalesOrderVM[\s\n]*\.role[\s\n]*\.value", "state.role", view_code)


# Replace methods
# 1. requestDeleteSalesOrder
delete_req_regex = r"detailSalesOrderVM\s*\.requestDeleteSalesOrder\(\s*state\.salesOrder!\s*\.id,\s*\);"
view_code = re.sub(delete_req_regex, "context.read<DetailSalesOrderBloc>().add(DetailSalesOrderDeleteRequested(state.salesOrder!.id!));", view_code)

# 2. requestPaySalesOrder
pay_req_regex = r"detailSalesOrderVM\s*\.requestPaySalesOrder\(\s*state\.salesOrder!\s*\.id,\s*state\.salesOrder!\s*\.productId,\s*state\.salesOrder!\s*\.quantity,\s*\);"
view_code = re.sub(pay_req_regex, """context.read<DetailSalesOrderBloc>().add(DetailSalesOrderPayRequested(
                                                  state.salesOrder!.id!,
                                                  state.salesOrder!.productId ?? '',
                                                  state.salesOrder!.quantity ?? 0,
                                                ));""", view_code)

# Handle the end of the file
# Finding the end of Stack:
#                     ),
#                   )
#                 : SizedBox(),
#         ],
#       ),
#     );
#   }
# }

# We must replace Obx closing tags.
view_code = re.sub(r"\}\),\s*\),\s*\]\s*,\s*\)\s*,\s*\}\s*,\s*\)\s*,\s*\)\s*;\s*\}\s*\}", "}\n}", view_code)

view_code = view_code.replace(
"""          state.status == DetailSalesOrderStatus.loading
                ? Container(
                    color: Colors.black26,
                    child: Center(
                      child: LoadingAnimationWidget.stretchedDots(
                        color: AppColors.softWhite,
                        size: 70.w,
                      ),
                    ),
                  )
                : SizedBox(),
        ],
      ),
    );
  }
}""",
"""          state.status == DetailSalesOrderStatus.loading
                ? Container(
                    color: Colors.black26,
                    child: Center(
                      child: LoadingAnimationWidget.stretchedDots(
                        color: AppColors.softWhite,
                        size: 70.w,
                      ),
                    ),
                  )
                : SizedBox(),
        ],
      ),
    );
          },
        ),
      );
  }
}"""
)

# And if state.status check is not there, we'll replace the Obx closing brace at the bottom
end_regex = r"              \);[\s\n]*\}\),[\s\n]*\),[\s\n]*\],[\s\n]*\),[\s\n]*\);[\s\n]*\}[\s\n]*\}"
new_end = """              );
            }),
          Column(
            children: [
              Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 112.h,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 4),
                            blurRadius: 14.2.w,
                            spreadRadius: 0,
                            color: AppColors.appBarShadow,
                          ),
                        ],
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 63.h),
                          Container(
                            padding: EdgeInsets.only(left: 30.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    getx.Get.back();
                                  },
                                  child: Icon(Icons.close, size: 24.w),
                                ),
                                SizedBox(width: 19.w),
                                Text(
                                  "Back To Summary",
                                  style: GoogleFonts.poppins(
                                    fontSize: 16.sp,
                                    fontWeight: AppFontWeight.medium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          state.status == DetailSalesOrderStatus.loading
                ? Container(
                    color: Colors.black26,
                    child: Center(
                      child: LoadingAnimationWidget.stretchedDots(
                        color: AppColors.softWhite,
                        size: 70.w,
                      ),
                    ),
                  )
                : SizedBox(),
        ],
      ),
    );
          },
        ),
      );
  }
}"""

# Wait, detail_sales_order_view already has the back button column!
# Let me just fix the Obx closing properly.
# detail_sales_order_view_model.dart had `isLoading.value = true`. So in view it was using detailSalesOrderVM.isLoading.value

loading_regex = r"detailSalesOrderVM\.isLoading\.value"
view_code = re.sub(loading_regex, "state.status == DetailSalesOrderStatus.loading", view_code)

# Since I just replaced Obx with Builder, `}),` -> `}),` is fine, but the first one was at `Obx(() { if (state.salesOrder == null)`
# Let's run a robust python replacer for the end of file:
view_code = re.sub(r"\}\);[\s\n]*\}\),[\s\n]*\),[\s\n]*\],[\s\n]*\),[\s\n]*\);[\s\n]*\}[\s\n]*\}", 
                   "});\n        },\n      ),\n    );\n  }\n}", view_code)

view_code = view_code.replace("Get.back()", "getx.Get.back()")
view_code = view_code.replace("Get.snackbar", "getx.Get.snackbar")

with open(view_path, 'w', encoding='utf-8') as f:
    f.write(view_code)

print("Updated view and injection")
