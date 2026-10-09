import re

def update_card_stock(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # 1. Update constructor
    content = content.replace(
        "    required this.image,",
        "    required this.image,\n    this.createdOn,"
    )
    content = content.replace(
        "  final idBarang, namaBarang, quantity, unitPrice, lineTotal, type, image;",
        "  final idBarang, namaBarang, quantity, unitPrice, lineTotal, type, image;\n  final String? createdOn;"
    )

    # 2. Add the "Added: [Tanggal]" Row below idBarang
    target_block = """                Text(
                  idBarang,
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    fontWeight: AppFontWeight.medium,
                    color: const Color(0xFF94A3B8),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),"""
    
    replacement_block = """                Text(
                  idBarang,
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    fontWeight: AppFontWeight.medium,
                    color: const Color(0xFF94A3B8),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                if (createdOn != null && createdOn!.isNotEmpty) ...[
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined, size: 10.w, color: const Color(0xFF64748B)),
                      SizedBox(width: 4.w),
                      Text(
                        "Added: $createdOn",
                        style: GoogleFonts.inter(
                          fontSize: 9.sp,
                          fontWeight: AppFontWeight.medium,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                ],"""
                
    content = content.replace(target_block, replacement_block)

    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)

update_card_stock(r'd:\Project\Flutter\mierp\lib\core\widgets\card_stock.dart')
print("card_stock.dart updated.")
