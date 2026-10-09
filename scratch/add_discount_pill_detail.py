import re

def update_detail_view(file_path, is_sales=False):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Find where the PAID/UNPAID badge is.
    # It's inside a Row with mainAxisAlignment: MainAxisAlignment.spaceBetween
    # Right below the productCode text.
    
    if not is_sales:
        badge_pattern = r'(state\.orderProduct!\.productCode,[^\]]+\]\s*\),)(\s*// SOLID PILL BADGE)'
        # Let's insert the discount pill right below that Row
        pill_code = r"""\1
                                          if ((state.orderProduct!.discountPercent ?? 0) > 0)
                                            Padding(
                                              padding: EdgeInsets.only(top: 8.h),
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFFEF3C7),
                                                  borderRadius: BorderRadius.circular(20.w),
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Icon(Icons.local_offer_rounded, size: 12.w, color: const Color(0xFFD97706)),
                                                    SizedBox(width: 4.w),
                                                    Text(
                                                      "Discount: ${state.orderProduct!.discountPercent}% (Max: ${(state.orderProduct!.discountMax ?? 0) / 1000}rb)",
                                                      style: GoogleFonts.inter(
                                                        fontSize: 10.sp,
                                                        fontWeight: AppFontWeight.bold,
                                                        color: const Color(0xFFD97706),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),\2"""
        content = re.sub(badge_pattern, pill_code, content)
    else:
        badge_pattern = r'(state\.salesOrder!\.productCode,[^\]]+\]\s*\),)(\s*// SOLID PILL BADGE)'
        pill_code = r"""\1
                                          if ((state.salesOrder!.discountPercent ?? 0) > 0)
                                            Padding(
                                              padding: EdgeInsets.only(top: 8.h),
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFFEF3C7),
                                                  borderRadius: BorderRadius.circular(20.w),
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Icon(Icons.local_offer_rounded, size: 12.w, color: const Color(0xFFD97706)),
                                                    SizedBox(width: 4.w),
                                                    Text(
                                                      "Discount: ${state.salesOrder!.discountPercent}% (Max: ${(state.salesOrder!.discountMax ?? 0) / 1000}rb)",
                                                      style: GoogleFonts.inter(
                                                        fontSize: 10.sp,
                                                        fontWeight: AppFontWeight.bold,
                                                        color: const Color(0xFFD97706),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),\2"""
        content = re.sub(badge_pattern, pill_code, content)

    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)

update_detail_view(r'd:\Project\Flutter\mierp\lib\features\detail\presentation\detail_product_order\detail_product_order_view.dart', False)
update_detail_view(r'd:\Project\Flutter\mierp\lib\features\detail\presentation\detail_sales_order\detail_sales_order_view.dart', True)

print("Detail views updated with discount pill.")
