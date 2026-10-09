import re

new_widget = """import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:mierp_apps/core/models/product.dart';

class InputSelectProductOrderWidget extends StatefulWidget {
  final dynamic head, placeholder, necessary, formKey;
  final List<Product?> products;
  final Product? value;
  final Function(Product?) onChanged;
  final double? width;

  const InputSelectProductOrderWidget({
    super.key,
    required this.head,
    required this.placeholder,
    required this.necessary,
    required this.formKey,
    required this.products,
    required this.value,
    required this.onChanged,
    this.width,
  });

  @override
  State<InputSelectProductOrderWidget> createState() =>
      _InputSelectProductOrderWidgetState();
}

class _InputSelectProductOrderWidgetState
    extends State<InputSelectProductOrderWidget> {
  bool hasError = false;
  String dataError = "";
  bool isFocus = false;
  
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void dispose() {
    _closeDropdown();
    super.dispose();
  }

  void _toggleDropdown() {
    if (isFocus) {
      _closeDropdown();
    } else {
      _showDropdown();
    }
  }

  void _showDropdown() {
    if (_overlayEntry != null) return;
    
    setState(() {
      isFocus = true;
    });

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final actualWidth = widget.width ?? 322.w;

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: _closeDropdown,
              behavior: HitTestBehavior.opaque,
              child: Container(color: Colors.transparent),
            ),
          ),
          Positioned(
            width: actualWidth,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, 45.w + 8.w),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  constraints: BoxConstraints(maxHeight: 250.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.w),
                    border: Border.all(color: const Color(0xFFE2E8F0), width: 1.w),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.10),
                        blurRadius: 8.w,
                        offset: Offset(0, 4.w),
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 2.w,
                        offset: Offset(0, 1.w),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.w),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: widget.products.length,
                      itemBuilder: (context, index) {
                        final item = widget.products[index];
                        final isSelected = widget.value?.id == item?.id;
                        return InkWell(
                          onTap: () {
                            widget.onChanged(item);
                            _closeDropdown();
                          },
                          child: Container(
                            color: isSelected ? const Color(0xFFF0FDFA) : Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item?.productName ?? "",
                                    style: GoogleFonts.inter(
                                      fontSize: 13.sp,
                                      fontWeight: isSelected ? AppFontWeight.semiBold : AppFontWeight.regular,
                                      color: isSelected ? const Color(0xFF0D9488) : const Color(0xFF0F172A),
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  Icon(Icons.check_rounded, color: const Color(0xFF0D9488), size: 16.w),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) {
      setState(() {
        isFocus = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? 322.w,
      height: !hasError ? 75.w : 90.w,
      child: Column(
        children: [
          Row(
            children: [
              widget.necessary
                  ? Text(
                      "*",
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: AppFontWeight.medium,
                        color: Colors.red,
                      ),
                    )
                  : SizedBox(),
              Text(
                widget.head,
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: AppFontWeight.medium,
                  color: AppColors.grayTitle,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.w),
          CompositedTransformTarget(
            link: _layerLink,
            child: GestureDetector(
              onTap: _toggleDropdown,
              child: Container(
                width: widget.width ?? 322.w,
                height: 45.w,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  color: isFocus ? const Color(0xFFF0FDFA) : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10.w),
                  border: Border.all(
                    color: isFocus ? const Color(0xFF0D9488) : Colors.transparent,
                    width: 1.5.w,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.value?.productName ?? "-- Select --",
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          fontWeight: AppFontWeight.regular,
                          color: widget.value != null
                              ? (isFocus ? const Color(0xFF0D9488) : const Color(0xFF0F172A))
                              : AppColors.greyPlacholder,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    AnimatedRotation(
                      turns: isFocus ? 0.5 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: isFocus ? const Color(0xFF0D9488) : const Color(0xFF64748B),
                        size: 20.w,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (hasError)
            Column(
              children: [
                SizedBox(height: 5.h),
                Row(
                  children: [
                    Text(
                      dataError,
                      style: GoogleFonts.inter(
                          fontSize: 10.sp,
                          fontWeight: AppFontWeight.regular,
                          height: 1.0,
                          color: Colors.red),
                    ),
                  ],
                ),
              ],
            )
        ],
      ),
    );
  }
}
"""

with open(r'D:\Project\Flutter\mierp\lib\core\widgets\add\add_warehouse_order\input_select_product_order_widget.dart', 'w', encoding='utf-8') as f:
    f.write(new_widget)

print("Dropdown successfully remade!")
