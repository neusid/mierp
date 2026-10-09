import re

def update_add_order(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # We want to add the discount info banner right after InputSelectProductOrderWidget
    # It ends with:
    #                                       },
    #                                     ),
    #                                     Row(

    banner_code = r"""                                     ),
                                    if (selectedProduct != null && (selectedProduct!.discountPercent ?? 0) > 0)
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFEF3C7),
                                          borderRadius: BorderRadius.circular(8.w),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(Icons.local_offer_rounded, size: 16.w, color: const Color(0xFFB45309)),
                                            SizedBox(width: 8.w),
                                            Text(
                                              "Discount Applied: ${selectedProduct!.discountPercent}% (Max: ${(selectedProduct!.discountMax ?? 0) / 1000}rb)",
                                              style: GoogleFonts.inter(
                                                fontSize: 12.sp,
                                                fontWeight: AppFontWeight.bold,
                                                color: const Color(0xFFB45309),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    Row("""

    # The regex targets the space between the end of InputSelectProductOrderWidget and Row(
    content = re.sub(r'\s*\),\s*Row\(', banner_code, content, count=1)

    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)

update_add_order(r'd:\Project\Flutter\mierp\lib\features\add\presentation\add_product_order\add_product_order_view.dart')
update_add_order(r'd:\Project\Flutter\mierp\lib\features\add\presentation\add_sales_order\add_sales_order_view.dart')

print("Add order views updated with discount banner.")
