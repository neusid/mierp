import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';

class InputSelectAuthWidget extends StatefulWidget {
  final String head, placeholder;
  final bool necessary, isPassword;
  final GlobalKey<FormState> formKey;
  final String value;
  final Function(String?) onChanged;

  const InputSelectAuthWidget({
    super.key,
    required this.head,
    required this.placeholder,
    required this.necessary,
    required this.isPassword,
    required this.formKey,
    required this.value,
    required this.onChanged,
  });

  @override
  State<InputSelectAuthWidget> createState() => _InputSelectAuthWidgetState();
}

class _InputSelectAuthWidgetState extends State<InputSelectAuthWidget> {
  bool isFocus = false;
  final FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 322.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (widget.necessary)
                Text(
                  "*",
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: AppFontWeight.medium,
                    color: const Color(0xFFED2736),
                  ),
                ),
              Text(
                widget.head,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: AppFontWeight.medium,
                  color: const Color(0xFF334155),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.w),
          Focus(
            onFocusChange: (value) {
              setState(() {
                isFocus = value;
              });
            },
            child: DropdownButtonFormField<String>(
              value: widget.value,
              onChanged: widget.onChanged,
              focusNode: focusNode,
              icon: Icon(Icons.arrow_drop_down, color: const Color(0xFF64748B)),
              style: GoogleFonts.inter(
                fontSize: 15.sp,
                fontWeight: AppFontWeight.medium,
                color: const Color(0xFF0F172A),
              ),
              items: <String>['warehouse', 'finance']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.w),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(color: const Color(0xFFE2E8F0), width: 1.5.w),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(color: const Color(0xFFE2E8F0), width: 1.5.w),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(color: AppColors.electricBlue, width: 1.5.w),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(color: const Color(0xFFED2736), width: 1.5.w),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(color: const Color(0xFFED2736), width: 1.5.w),
                ),
              ),
            ),
          ),
          SizedBox(height: 16.w),
        ],
      ),
    );
  }
}
