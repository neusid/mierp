import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:mierp_apps/core/widgets/custom_top_snackbar.dart';
import 'package:mierp_apps/features/admin/presentation/cubit/admin_staff_cubit.dart';

class AddStaffModal extends StatefulWidget {
  final AdminStaffCubit cubit;

  const AddStaffModal({super.key, required this.cubit});

  static Future<void> show(BuildContext context, AdminStaffCubit cubit) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddStaffModal(cubit: cubit),
    );
  }

  @override
  State<AddStaffModal> createState() => _AddStaffModalState();
}

class _AddStaffModalState extends State<AddStaffModal> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String _selectedRole = 'finance'; // 'finance' | 'warehouse'
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final ok = await widget.cubit.createStaff(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      role: _selectedRole,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (ok) {
      Navigator.pop(context);
      CustomTopSnackbar.success(
        context,
        "Akun ${_selectedRole.toUpperCase()} untuk ${_firstNameController.text} berhasil dibuat!",
        title: "Staf Berhasil Ditambahkan",
      );
    } else {
      CustomTopSnackbar.error(
        context,
        "Gagal membuat akun staf. Pastikan email belum pernah terdaftar.",
        title: "Gagal Menambah Staf",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 20.h,
        bottom: 24.h + bottomInset,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Grab handle
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: 16.h),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),

              // Title header
              Row(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: const Color(0xFFE2E8F0), width: 1.w),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.person_add_outlined,
                        color: const Color(0xFF475569),
                        size: 20.w,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tambah Staf Baru",
                        style: GoogleFonts.outfit(
                          fontSize: 18.sp,
                          fontWeight: AppFontWeight.bold,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                      Text(
                        "Buatkan akun tim Finance atau Warehouse",
                        style: GoogleFonts.outfit(
                          fontSize: 12.sp,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 20.h),

              // Role Selector Pills
              Text(
                "Pilih Peran (Role)",
                style: GoogleFonts.outfit(
                  fontSize: 13.sp,
                  fontWeight: AppFontWeight.semiBold,
                  color: const Color(0xFF334155),
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Expanded(
                    child: _buildRoleChip(
                      role: 'finance',
                      label: 'Finance',
                      icon: Icons.account_balance_wallet_outlined,
                      activeColor: const Color(0xFF4F46E5),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildRoleChip(
                      role: 'warehouse',
                      label: 'Warehouse',
                      icon: Icons.warehouse_outlined,
                      activeColor: const Color(0xFF0D9488),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              // First & Last Name
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _firstNameController,
                      label: "Nama Depan",
                      hint: "Misal: Budi",
                      validator: (v) =>
                          v == null || v.isEmpty ? "Wajib diisi" : null,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildTextField(
                      controller: _lastNameController,
                      label: "Nama Belakang",
                      hint: "Misal: Santoso",
                      validator: (v) =>
                          v == null || v.isEmpty ? "Wajib diisi" : null,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 14.h),

              // Email
              _buildTextField(
                controller: _emailController,
                label: "Email Staf",
                hint: "nama@perusahaan.com",
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.isEmpty) return "Email wajib diisi";
                  if (!v.contains('@')) return "Format email tidak valid";
                  return null;
                },
              ),

              SizedBox(height: 14.h),

              // Password
              _buildTextField(
                controller: _passwordController,
                label: "Password Sementara",
                hint: "Minimal 6 karakter",
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: const Color(0xFF94A3B8),
                    size: 20.w,
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
                validator: (v) {
                  if (v == null || v.length < 6) {
                    return "Password minimal 6 karakter";
                  }
                  return null;
                },
              ),

              SizedBox(height: 24.h),

              // Submit Button
              Container(
                width: double.infinity,
                height: 48.h,
                decoration: BoxDecoration(
                  gradient: AppColors.premiumDarkGradient,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? SizedBox(
                          width: 22.w,
                          height: 22.w,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          "Buat Akun Staf",
                          style: GoogleFonts.outfit(
                            fontSize: 15.sp,
                            fontWeight: AppFontWeight.semiBold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleChip({
    required String role,
    required String label,
    required IconData icon,
    required Color activeColor,
  }) {
    final isSelected = _selectedRole == role;
    return InkWell(
      onTap: () => setState(() => _selectedRole = role),
      borderRadius: BorderRadius.circular(12.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withValues(alpha: 0.08) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? activeColor : const Color(0xFFE2E8F0),
            width: isSelected ? 1.5.w : 1.w,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18.w,
              color: isSelected ? activeColor : const Color(0xFF64748B),
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 14.sp,
                fontWeight:
                    isSelected ? AppFontWeight.bold : AppFontWeight.medium,
                color: isSelected ? activeColor : const Color(0xFF475569),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 12.sp,
            fontWeight: AppFontWeight.medium,
            color: const Color(0xFF475569),
          ),
        ),
        SizedBox(height: 6.h),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          style: GoogleFonts.outfit(
            fontSize: 14.sp,
            color: const Color(0xFF0F172A),
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.outfit(
              fontSize: 13.sp,
              color: const Color(0xFF94A3B8),
            ),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide:
                  const BorderSide(color: AppColors.premiumDarkSolid, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
