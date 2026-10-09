import re

view_path = r"d:\Project\Flutter\mierp\lib\features\detail\presentation\detail_product_order\detail_product_order_view.dart"

with open(view_path, 'r', encoding='utf-8') as f:
    view_code = f.read()

view_code = re.sub(r"detailProductOrderVM[\s\n]*\.orderProducts[\s\n]*\.value!", "state.orderProduct!", view_code)
view_code = re.sub(r"detailProductOrderVM[\s\n]*\.orderProducts![\s\n]*\.value!", "state.orderProduct!", view_code)

# Replace role
view_code = re.sub(r"detailProductOrderVM[\s\n]*\.role[\s\n]*\.value", "state.role", view_code)

# Also fix the final parenthesis error at line 735:
#           state.status == DetailProductOrderStatus.loading
view_code = view_code.replace(
"""          state.status == DetailProductOrderStatus.loading
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
      ),
    );
  }
}""",
"""          state.status == DetailProductOrderStatus.loading
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
}""")

# I need to see what I broke with builder
view_code = re.sub(r"\}\),\s*\),\s*\]\s*,\s*\)\s*,\s*\}\s*,\s*\)\s*,\s*\)\s*;\s*\}\s*\}", "}\n}", view_code)


with open(view_path, 'w', encoding='utf-8') as f:
    f.write(view_code)

print("Fixed3")
