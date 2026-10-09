import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';


class InputSelectUpdateWidget extends StatefulWidget {
  final String head, placeholder;
  final bool necessary;
  final GlobalKey<FormState> formKey;
  final String value;
  final ValueChanged<String?> onChanged;
  final List<String> items;

  const InputSelectUpdateWidget({
    super.key,
    required this.head,
    required this.placeholder,
    required this.necessary,
    required this.formKey,
    required this.value,
    required this.onChanged,
    this.items = const ['electronics', 'automotive'],
  });

  @override
  State<InputSelectUpdateWidget> createState() =>
      _InputSelectUpdateWidgetState();
}

class _InputSelectUpdateWidgetState extends State<InputSelectUpdateWidget> {
  bool hasError = false;
  String dataError = "";
  bool isFocus = false;
  
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
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

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    setState(() {
      isFocus = true;
    });

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
            width: size.width,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, 45.w + 4.w),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.w),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 16.w,
                        offset: Offset(0, 4.w),
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 4.w,
                        offset: Offset(0, 2.w),
                      ),
                    ],
                    border: Border.all(color: const Color(0xFFE2E8F0), width: 1.w),
                  ),
                  constraints: BoxConstraints(
                    maxHeight: 250.h,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.w),
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: widget.items.length,
                      separatorBuilder: (context, index) => Divider(height: 1.w, color: const Color(0xFFF1F5F9)),
                      itemBuilder: (context, index) {
                        final item = widget.items[index];
                        final isSelected = widget.value == item;
                        return InkWell(
                          onTap: () {
                            widget.onChanged(item);
                            _closeDropdown();
                          },
                          child: Container(
                            color: isSelected ? AppColors.purpleTransparent : Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item,
                                    style: GoogleFonts.inter(
                                      fontSize: 13.sp,
                                      fontWeight: isSelected ? AppFontWeight.semiBold : AppFontWeight.regular,
                                      color: isSelected ? AppColors.vividPurple : const Color(0xFF0F172A),
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  Icon(Icons.check_rounded, color: AppColors.vividPurple, size: 16.w),
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
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                width: double.infinity,
                height: 45.w,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  color: isFocus ? AppColors.purpleTransparent : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10.w),
                  border: Border.all(
                    color: isFocus ? AppColors.vividPurple : Colors.transparent,
                    width: 1.5.w,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.value.isNotEmpty ? widget.value : widget.placeholder,
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          fontWeight: AppFontWeight.regular,
                          color: widget.value.isNotEmpty
                              ? (isFocus ? AppColors.vividPurple : const Color(0xFF0F172A))
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
                        color: isFocus ? AppColors.vividPurple : const Color(0xFF64748B),
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
            ),
        ],
      ),
    );
  }
}
