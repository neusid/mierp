import re

view_path = r"d:\Project\Flutter\mierp\lib\features\detail\presentation\detail_sales_order\detail_sales_order_view.dart"
with open(view_path, 'r', encoding='utf-8') as f:
    view_code = f.read()

view_code = view_code.replace("getx.getx.Get.snackbar", "getx.Get.snackbar")
view_code = view_code.replace("getx.getx.Get.toNamed", "getx.Get.toNamed")
view_code = view_code.replace("state.status == DetailSalesOrderStatus.loading = true;\n", "")
view_code = view_code.replace("                                    detailSalesOrderVM.resetVariable();\n", "")

view_code = view_code.replace(
"""          Obx(
            () => state.status == DetailSalesOrderStatus.loading
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
          ),
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
}""")

with open(view_path, 'w', encoding='utf-8') as f:
    f.write(view_code)

print("Fixed detail sales order view end")
