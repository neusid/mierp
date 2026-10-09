import re

def update_order(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    target = """                    // Rating / Subtitle (Mimicking GoFood style)
                    Row(
                      children: [
                        Icon(Icons.star_rounded, size: 16.w, color: const Color(0xFFF57C00)),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            "4.8 (900+) · $nameUser",
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
    
    replacement = """                    // Subtitle: By user and Date
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

    if target in content:
        content = content.replace(target, replacement)
        print("Updated order.")
    else:
        print("Target not found in order.")

    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)


def update_sales(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    target = """                    // Rating / Subtitle (Mimicking GoFood style)
                    Row(
                      children: [
                        Icon(Icons.star_rounded, size: 16.w, color: const Color(0xFFF57C00)),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            "4.8 (900+) · To: $nameCustomer",
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
    
    replacement = """                    // Subtitle: To company and Date
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

    if target in content:
        content = content.replace(target, replacement)
        print("Updated sales.")
    else:
        print("Target not found in sales.")

    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)

update_order(r'd:\Project\Flutter\mierp\lib\core\widgets\card_order.dart')
update_sales(r'd:\Project\Flutter\mierp\lib\core\widgets\card_sales.dart')

