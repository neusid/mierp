import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';

class InputAuthWidget extends StatefulWidget {
  final dynamic head, controller, placeholder, isPassword, necessary, formKey;

  const InputAuthWidget({
    super.key,
    required this.head,
    required this.controller,
    required this.placeholder,
    required this.isPassword,
    required this.necessary,
    required this.formKey,
  });

  @override
  State<InputAuthWidget> createState() => _InputAuthWidgetState();
}

class _InputAuthWidgetState extends State<InputAuthWidget> {
  bool isNotVisible = true;
  bool isFocus = false;
  final FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  void toggleVisibility() {
    setState(() {
      isNotVisible = !isNotVisible;
    });
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
            child: TextFormField(
              controller: widget.controller,
              obscureText: widget.isPassword ? isNotVisible : false,
              keyboardType: widget.isPassword ? TextInputType.text : TextInputType.emailAddress,
              focusNode: focusNode,
              style: GoogleFonts.inter(
                fontSize: 15.sp,
                fontWeight: AppFontWeight.medium,
                color: const Color(0xFF0F172A),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "${widget.head} wajib diisi";
                }
                if (widget.isPassword && value.length <= 8) {
                  return "Password harus lebih dari 8 karakter";
                }
                if (!widget.isPassword && (!value.contains('@') || !value.contains('.'))) {
                  return "Format email salah";
                }
                return null;
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: widget.placeholder == "" ? "Enter ${widget.head.toString().toLowerCase()}" : widget.placeholder,
                hintStyle: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: AppFontWeight.regular,
                  color: const Color(0xFF94A3B8),
                ),
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
                suffixIcon: widget.isPassword
                    ? IconButton(
                        icon: Icon(
                          isNotVisible ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                          color: const Color(0xFF64748B),
                        ),
                        onPressed: toggleVisibility,
                      )
                    : null,
              ),
            ),
          ),
          SizedBox(height: 16.w),
        ],
      ),
    );
  }
}
