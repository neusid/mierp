import re

view_path = r"d:\Project\Flutter\mierp\lib\features\detail\presentation\detail_product_order\detail_product_order_view.dart"

with open(view_path, 'r', encoding='utf-8') as f:
    view_code = f.read()

view_code = view_code.replace("detailProductOrderVM.orderProducts!.value!.financeApproved!", "state.orderProduct!.financeApproved!")
view_code = view_code.replace("detailProductOrderVM.orderProducts.value!.financeApproved!", "state.orderProduct!.financeApproved!")
view_code = view_code.replace("detailProductOrderVM.orderProducts.value!.financeApproved!", "state.orderProduct!.financeApproved!")

# Fix the stray closing parenthesis from Obx at the bottom
view_code = view_code.replace(
"""                : SizedBox(),
          ),
        ],
      ),
    );
          },
        ),
      ),
    );
  }
}""",
"""                : SizedBox(),
        ],
      ),
    );
          },
        ),
      ),
    );
  }
}"""
)

# And fix line 675 which has `);`
# It's currently:
#                           ),
#                         ],
#                       );
#                     ),
#                   ),
#                 ],
# Let's see:
view_code = re.sub(r"\);\s*}\),\s*\),\s*\]", ");\n                    },\n                  ),\n                ]", view_code)
# Actually, the original was:
#                       );
#                     }),
#                   ),
#                 ],
view_code = view_code.replace("});\n                    ),\n                  ),", "}\n                    ),\n                  ),")
view_code = view_code.replace(");\n                    ),\n                  ),", ")\n                    ),\n                  ),")
view_code = view_code.replace("                      );\n                    ),\n                  ),\n                ],", "                      );\n                    }),\n                  ),\n                ],")

with open(view_path, 'w', encoding='utf-8') as f:
    f.write(view_code)

print("Fixed")
