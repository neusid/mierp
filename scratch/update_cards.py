import re

def update_card(file_path, is_sales):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # The existing block starts with `// Rating / Subtitle (Mimicking GoFood style)`
    # and ends with `], \n                    ),\n                    SizedBox(height: 6.h),`
    
    # We can match it using regex.
    pattern = r'// Rating / Subtitle.*?Row\([\s\S]*?Icon\(Icons\.star_rounded[\s\S]*?Expanded\([\s\S]*?Text\([\s\S]*?maxLines:\ 1,[\s\S]*?overflow:\ TextOverflow\.ellipsis,[\s\S]*?\)[\s\S]*?\)[\s\S]*?\)[\s\S]*?\][\s\S]*?\),[\s\S]*?SizedBox\(height:\ 6\.h\),'
    
    if is_sales:
        replacement = r"""// Subtitle: To company and Date
                    Row(
                      children: [
                        Icon(Icons.business_center_outlined, size: 14.w, color: const Color(0xFF6B7280)),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            "To: $nameCustomer • $createdOn",
                            style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              fontWeight: AppFontWeight.medium,
                              color: const Color(0xFF6B7280),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),"""
    else:
        replacement = r"""// Subtitle: By user and Date
                    Row(
                      children: [
                        Icon(Icons.person_outline_rounded, size: 14.w, color: const Color(0xFF6B7280)),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            "By: $nameUser • $createdOn",
                            style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              fontWeight: AppFontWeight.medium,
                              color: const Color(0xFF6B7280),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),"""

    content = re.sub(pattern, replacement, content)

    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)

update_card(r'd:\Project\Flutter\mierp\lib\core\widgets\card_order.dart', False)
update_card(r'd:\Project\Flutter\mierp\lib\core\widgets\card_sales.dart', True)

print("Card orders replaced successfully.")
