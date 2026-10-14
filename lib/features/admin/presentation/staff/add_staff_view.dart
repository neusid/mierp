import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:mierp_apps/core/widgets/custom_top_snackbar.dart';
import 'package:mierp_apps/features/admin/presentation/cubit/admin_staff_cubit.dart';

class AddStaffView extends StatefulWidget {
  const AddStaffView({super.key});

  @override
  State<AddStaffView> createState() => _AddStaffViewState();
}

class _AddStaffViewState extends State<AddStaffView> {
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

  String _generateSecurePassword() {
    const chars = 'abcdefghjkmnpqrstuvwxyzABCDEFGHJKMNPQRSTUVWXYZ23456789!@#%';
    final rnd = Random();
    return List.generate(8, (_) => chars[rnd.nextInt(chars.length)]).join();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final ok = await context.read<AdminStaffCubit>().createStaff(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          role: _selectedRole,
        );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (ok) {
      CustomTopSnackbar.success(
        context,
        "Akun ${_selectedRole.toUpperCase()} untuk ${_firstNameController.text} berhasil dibuat!",
        title: "Staf Berhasil Ditambahkan",
      );
      context.pop(true);
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
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(68.h),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => context.pop(),
                    borderRadius: BorderRadius.circular(10.r),
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 16.w,
                        color: const Color(0xFF334155),
                      ),
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Tambah Staf Baru",
                          style: GoogleFonts.outfit(
                            fontSize: 17.sp,
                            fontWeight: AppFontWeight.bold,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          "Buatkan kredensial akses untuk tim tenant Anda",
                          style: GoogleFonts.outfit(
                            fontSize: 11.5.sp,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SECTION 1: PERAN & HAK AKSES
                      _buildSectionHeader(
                        number: "1",
                        title: "Pilih Peran & Hak Akses",
                        subtitle: "Tentukan departemen operasional staf",
                      ),
                      SizedBox(height: 10.h),
                      _buildRoleSelectionCards(),
                      SizedBox(height: 10.h),
                      _buildRoleScopePreview(),

                      SizedBox(height: 24.h),

                      // SECTION 2: DATA PRIBADI
                      _buildSectionHeader(
                        number: "2",
                        title: "Informasi Pribadi",
                        subtitle: "Nama lengkap staf untuk identifikasi profil",
                      ),
                      SizedBox(height: 10.h),
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14.r),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller: _firstNameController,
                                label: "Nama Depan",
                                hint: "Contoh: Budi",
                                validator: (v) => v == null || v.trim().isEmpty
                                    ? "Wajib diisi"
                                    : null,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: _buildTextField(
                                controller: _lastNameController,
                                label: "Nama Belakang",
                                hint: "Contoh: Santoso",
                                validator: (v) => v == null || v.trim().isEmpty
                                    ? "Wajib diisi"
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // SECTION 3: KREDENSIAL LOGIN
                      _buildSectionHeader(
                        number: "3",
                        title: "Kredensial Akun",
                        subtitle: "Email dan kata sandi sementara untuk login",
                      ),
                      SizedBox(height: 10.h),
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14.r),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTextField(
                              controller: _emailController,
                              label: "Email Staf",
                              hint: "staf@perusahaan.com",
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return "Email wajib diisi";
                                }
                                if (!v.contains('@') || !v.contains('.')) {
                                  return "Format email tidak valid";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 14.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Password Sementara",
                                  style: GoogleFonts.outfit(
                                    fontSize: 12.5.sp,
                                    fontWeight: AppFontWeight.medium,
                                    color: const Color(0xFF475569),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    final pass = _generateSecurePassword();
                                    _passwordController.text = pass;
                                    _obscurePassword = false;
                                    setState(() {});
                                  },
                                  borderRadius: BorderRadius.circular(6.r),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 6.w, vertical: 2.h),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.autorenew_rounded,
                                          size: 13.w,
                                          color: const Color(0xFF4F46E5),
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          "Buat Password Acak",
                                          style: GoogleFonts.outfit(
                                            fontSize: 11.5.sp,
                                            fontWeight: AppFontWeight.semiBold,
                                            color: const Color(0xFF4F46E5),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 6.h),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              style: GoogleFonts.outfit(
                                fontSize: 14.sp,
                                color: const Color(0xFF0F172A),
                              ),
                              validator: (v) {
                                if (v == null || v.length < 6) {
                                  return "Password minimal 6 karakter";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: "Minimal 6 karakter",
                                hintStyle: GoogleFonts.outfit(
                                  fontSize: 13.sp,
                                  color: const Color(0xFF94A3B8),
                                ),
                                filled: true,
                                fillColor: const Color(0xFFF8FAFC),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: const Color(0xFF94A3B8),
                                    size: 19.w,
                                  ),
                                  onPressed: () => setState(
                                      () => _obscurePassword = !_obscurePassword),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 14.w, vertical: 12.h),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                  borderSide: const BorderSide(
                                      color: Color(0xFFE2E8F0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                  borderSide: const BorderSide(
                                      color: Color(0xFFE2E8F0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF4F46E5),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // STICKY BOTTOM ACTION BAR
            Container(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 14.h),
              decoration: BoxDecoration(
                color: Colors.white,
                border: const Border(top: BorderSide(color: Color(0xFFE2E8F0))),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F172A).withValues(alpha: 0.04),
                    blurRadius: 10.w,
                    offset: Offset(0, -3.h),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 48.h,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.premiumDarkGradient,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2E1052).withValues(alpha: 0.35),
                        blurRadius: 10.w,
                        offset: Offset(0, 4.h),
                      ),
                    ],
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
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.person_add_outlined,
                                color: Colors.white,
                                size: 18.w,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                "Buat Akun Staf",
                                style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required String number,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 22.w,
          height: 22.w,
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Center(
            child: Text(
              number,
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                  letterSpacing: -0.2,
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRoleSelectionCards() {
    return Row(
      children: [
        Expanded(
          child: _buildRoleCard(
            role: 'finance',
            label: 'Finance',
            description: 'Kelola order, pembayaran & transaksi',
            icon: Icons.account_balance_wallet_outlined,
            activeColor: const Color(0xFF4F46E5),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildRoleCard(
            role: 'warehouse',
            label: 'Warehouse',
            description: 'Kelola stok, restock & SKU produk',
            icon: Icons.warehouse_outlined,
            activeColor: const Color(0xFF0D9488),
          ),
        ),
      ],
    );
  }

  Widget _buildRoleCard({
    required String role,
    required String label,
    required String description,
    required IconData icon,
    required Color activeColor,
  }) {
    final isSelected = _selectedRole == role;

    return InkWell(
      onTap: () => setState(() => _selectedRole = role),
      borderRadius: BorderRadius.circular(14.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isSelected ? activeColor : const Color(0xFFE2E8F0),
            width: isSelected ? 1.8 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: activeColor.withValues(alpha: 0.12),
                    blurRadius: 8.w,
                    offset: Offset(0, 3.h),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 34.w,
                  height: 34.w,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? activeColor.withValues(alpha: 0.10)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(9.r),
                    border: Border.all(
                      color: isSelected
                          ? activeColor.withValues(alpha: 0.3)
                          : const Color(0xFFE2E8F0),
                      width: 1.w,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      size: 18.w,
                      color: isSelected ? activeColor : const Color(0xFF64748B),
                    ),
                  ),
                ),
                Container(
                  width: 18.w,
                  height: 18.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? activeColor : const Color(0xFFCBD5E1),
                      width: isSelected ? 5.5 : 1.5,
                    ),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14.5.sp,
                fontWeight: FontWeight.w700,
                color: isSelected ? const Color(0xFF0F172A) : const Color(0xFF475569),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              description,
              style: GoogleFonts.inter(
                fontSize: 10.5.sp,
                color: const Color(0xFF64748B),
                height: 1.25,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleScopePreview() {
    final isFinance = _selectedRole == 'finance';
    final accentColor =
        isFinance ? const Color(0xFF4F46E5) : const Color(0xFF0D9488);
    final bgColor =
        isFinance ? const Color(0xFFEEF2FF) : const Color(0xFFF0FDFA);
    final borderColor =
        isFinance ? const Color(0xFFC7D2FE) : const Color(0xFFCCFBF1);

    final items = isFinance
        ? [
            "Akses laporan grafis analitik penjualan & omzet",
            "Verifikasi & persetujuan pembayaran pesanan (Sales Order)",
            "Menerima notifikasi otomatis saat pesanan dibuat oleh gudang",
          ]
        : [
            "Akses inventaris katalog produk, SKU, & kuantitas stok",
            "Penerbitan pesanan restock barang masuk (Product Order)",
            "Menerima notifikasi otomatis saat pesanan disetujui finance",
          ];

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: borderColor, width: 1.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shield_outlined, size: 14.w, color: accentColor),
              SizedBox(width: 6.w),
              Text(
                "Cakupan Hak Akses Role ${isFinance ? 'Finance' : 'Warehouse'}:",
                style: GoogleFonts.inter(
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w600,
                  color: accentColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          ...items.map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: 3.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 2.h),
                    child: Icon(
                      Icons.check_circle_outline_rounded,
                      size: 12.w,
                      color: accentColor,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      item,
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        color: const Color(0xFF334155),
                        height: 1.25,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 12.5.sp,
            fontWeight: AppFontWeight.medium,
            color: const Color(0xFF475569),
          ),
        ),
        SizedBox(height: 6.h),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
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
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(
                color: Color(0xFF4F46E5),
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
