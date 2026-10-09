import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mierp_apps/features/detail/presentation/detail_product/bloc/detail_product_bloc.dart';
import 'package:mierp_apps/core/di/injection_container.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:mierp_apps/core/widgets/date_picker_widget.dart';
import 'package:mierp_apps/core/widgets/detail/input_select_update_widget.dart';
import 'package:mierp_apps/core/widgets/input_short_widget.dart';
import 'package:mierp_apps/core/widgets/input_widget.dart';
import 'package:mierp_apps/core/models/product.dart';

class DetailProductView extends StatefulWidget {
  final String id;
  const DetailProductView({super.key, required this.id});

  @override
  State<DetailProductView> createState() => _DetailProductViewState();
}

class _DetailProductViewState extends State<DetailProductView> {
  final formKey = GlobalKey<FormState>();
  final productCodeC = TextEditingController();
  final nameProductC = TextEditingController();
  final createdOnC = TextEditingController();
  final quantityC = TextEditingController();
  final unitPriceC = TextEditingController();
  final discountPercentC = TextEditingController();
  final discountMaxC = TextEditingController();
  
  String categoryProductC = "electronics";
  String imageProduct = "";
  dynamic currentProduct;
  late String id;

  @override
  void initState() {
    super.initState();
    id = widget.id;
  }

  @override
  void dispose() {
    productCodeC.dispose();
    nameProductC.dispose();
    createdOnC.dispose();
    quantityC.dispose();
    unitPriceC.dispose();
    discountPercentC.dispose();
    discountMaxC.dispose();
    super.dispose();
  }

  // Ultra-Soft White Card Wrapper Helper
  Widget _buildCardWrapper({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.w),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8.w,
            offset: Offset(0, 2.w),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: AppFontWeight.semiBold,
              color: const Color(0xFF1E293B),
            ),
          ),
          Divider(color: const Color(0xFFF1F5F9), height: 24.h, thickness: 1.w),
          child,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DetailProductBloc>()..add(DetailProductStarted(id)),
      child: BlocConsumer<DetailProductBloc, DetailProductState>(
        listener: (context, state) {
          if (state.status == DetailProductStatus.success && state.product != null) {
            currentProduct = state.product;
            productCodeC.text = state.product!.productCode;
            nameProductC.text = state.product!.productName;
            createdOnC.text = state.product!.createdOn;
            quantityC.text = state.product!.quantity.toString();
            unitPriceC.text = state.product!.unitPrice.toString();
            discountPercentC.text = (state.product!.discountPercent ?? 0).toString();
            discountMaxC.text = (state.product!.discountMax ?? 0).toString();
            setState(() {
                imageProduct = state.product!.imageProduct ?? "";
                categoryProductC = state.product!.category ?? "electronics";
            });
            if (state.successMessage.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.successMessage)));
            }
          } else if (state.status == DetailProductStatus.deleteSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.successMessage)));
            Future.delayed(Duration(seconds: 2), () {
               context.push("warehouse_main_page");
            });
          } else if (state.status == DetailProductStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage)));
          }
        },
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: const Color(0xFFF8FAFC), // Soft off-white background
            body: Form(
              key: formKey,
              child: Stack(
                children: [
                  Column(
                    children: [
                      // CLEAN APP BAR
                      Container(
                        width: double.infinity,
                        height: 100.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(bottom: BorderSide(color: const Color(0xFFE2E8F0), width: 1.w)),
                        ),
                        padding: EdgeInsets.only(top: 40.h, left: 20.w, right: 20.w),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () => context.pop(),
                              child: Container(
                                padding: EdgeInsets.all(8.w),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(8.w),
                                ),
                                child: Icon(Icons.arrow_back_ios_new_rounded, size: 16.w, color: const Color(0xFF334155)),
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Text(
                              "Detail Product",
                              style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                fontWeight: AppFontWeight.semiBold,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // SCROLLABLE CONTENT
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.only(top: 16.h, left: 16.w, right: 16.w, bottom: 120.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              _buildCardWrapper(
                                title: "Product Identification",
                                child: Column(
                                  spacing: 16.h,
                                  children: [
                                    InputWidget(
                                      head: "Code Product",
                                      controller: productCodeC,
                                      placeholder: "e.g. PRD-001",
                                      necessary: true,
                                      formKey: formKey,
                                    ),
                                    InputWidget(
                                      head: "Name Product",
                                      controller: nameProductC,
                                      placeholder: "e.g. MacBook Pro",
                                      necessary: true,
                                      formKey: formKey,
                                    ),
                                    InputSelectUpdateWidget(
                                      head: "Category",
                                      placeholder: "Select Category",
                                      necessary: true,
                                      formKey: formKey,
                                      value: categoryProductC,
                                      onChanged: (val) {
                                        setState(() {
                                          categoryProductC = val.toString();
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),

                              _buildCardWrapper(
                                title: "Inventory & Pricing",
                                child: Column(
                                  spacing: 16.h,
                                  children: [
                                    DatePickerWidget(
                                      head: "Created On",
                                      controller: createdOnC,
                                      placeholder: "Select Date",
                                      necessary: true,
                                      formKey: formKey,
                                      isShort: false,
                                      feature: "add_unit",
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: InputShortWidget(
                                            head: "Quantity",
                                            controller: quantityC,
                                            placeholder: "0",
                                            iconAsset: "box.svg",
                                            necessary: true,
                                            formKey: formKey,
                                          ),
                                        ),
                                        SizedBox(width: 12.w),
                                        Expanded(
                                          child: InputShortWidget(
                                            head: "Unit Price",
                                            controller: unitPriceC,
                                            placeholder: "0",
                                            iconAsset: "price_tag.svg",
                                            necessary: true,
                                            formKey: formKey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: InputShortWidget(
                                            head: "Discount (%)",
                                            controller: discountPercentC,
                                            placeholder: "0",
                                            iconAsset: "price_tag.svg",
                                            necessary: false,
                                            formKey: formKey,
                                          ),
                                        ),
                                        SizedBox(width: 12.w),
                                        Expanded(
                                          child: InputShortWidget(
                                            head: "Max Discount",
                                            controller: discountMaxC,
                                            placeholder: "0",
                                            iconAsset: "price_tag.svg",
                                            necessary: false,
                                            formKey: formKey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              _buildCardWrapper(
                                title: "Product Image",
                                child: Container(
                                  width: double.infinity,
                                  height: 180.h,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8FAFC),
                                    borderRadius: BorderRadius.circular(10.w),
                                    border: Border.all(color: const Color(0xFFE2E8F0), width: 1.w),
                                    image: DecorationImage(
                                      image: imageProduct.isEmpty
                                          ? const AssetImage("assets/images/dummy_item.jpg")
                                          : NetworkImage(imageProduct) as ImageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  // BOTTOM ACTION BAR
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(top: BorderSide(color: const Color(0xFFE2E8F0), width: 1.w)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10.w,
                            offset: const Offset(0, -4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Minimalist Delete Button
                          GestureDetector(
                            onTap: () {
                              context.read<DetailProductBloc>().add(DetailProductDeleteRequested(id));
                            },
                            child: Container(
                              width: 52.w,
                              height: 52.h,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF2F2),
                                borderRadius: BorderRadius.circular(10.w),
                                border: Border.all(color: const Color(0xFFFECACA), width: 1.w),
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  "assets/icons/delete.svg",
                                  width: 24.w,
                                  height: 24.h,
                                  colorFilter: const ColorFilter.mode(Color(0xFFEF4444), BlendMode.srcIn),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          // Primary Gradient Update Button
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (formKey.currentState!.validate()) {
                                  FocusScope.of(context).unfocus();
                                  final updatedProduct = currentProduct.copyWith(
                                    productCode: productCodeC.text,
                                    productName: nameProductC.text,
                                    quantity: int.parse(quantityC.text),
                                    unitPrice: int.parse(unitPriceC.text),
                                    discountPercent: int.tryParse(discountPercentC.text),
                                    discountMax: int.tryParse(discountMaxC.text),
                                    category: categoryProductC,
                                  );
                                  context.read<DetailProductBloc>().add(
                                    DetailProductUpdateRequested(updatedProduct),
                                  );
                                }
                              },
                              child: Container(
                                height: 52.h,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF3B82F6), Color(0xFF6D28D9)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(10.w),
                                ),
                                child: Center(
                                  child: Text(
                                    "Save Changes",
                                    style: GoogleFonts.inter(
                                      fontWeight: AppFontWeight.bold,
                                      fontSize: 16.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // LOADING OVERLAY
                  if (state.isLoading)
                    Container(
                      color: Colors.black.withOpacity(0.3),
                      child: Center(
                        child: LoadingAnimationWidget.stretchedDots(
                          color: Colors.white,
                          size: 70.w,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}