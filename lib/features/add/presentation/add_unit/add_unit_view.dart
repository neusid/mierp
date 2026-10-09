import 'package:go_router/go_router.dart';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mierp_apps/core/di/injection_container.dart';
import 'package:mierp_apps/core/models/product.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:mierp_apps/core/widgets/add/add_unit/input_selected_add_unit_widget.dart';
import 'package:mierp_apps/core/widgets/custom_mingda_date_picker.dart';
import 'package:mierp_apps/core/widgets/date_picker_widget.dart';
import 'package:mierp_apps/core/widgets/input_short_widget.dart';
import 'package:mierp_apps/core/widgets/input_widget.dart';
import 'package:mierp_apps/features/add/presentation/add_unit/bloc/add_unit_bloc.dart';
import 'package:mierp_apps/core/widgets/custom_top_snackbar.dart';
import 'package:mierp_apps/features/add/presentation/add_unit/bloc/add_unit_event.dart';
import 'package:mierp_apps/features/add/presentation/add_unit/bloc/add_unit_state.dart';

class AddUnitView extends StatefulWidget {
  const AddUnitView({super.key});

  @override
  State<AddUnitView> createState() => _AddUnitViewState();
}

class _AddUnitViewState extends State<AddUnitView> {
  final formKey = GlobalKey<FormState>();

  final productCodeC = TextEditingController();
  final nameProductC = TextEditingController();
  final createdOnC = TextEditingController();
  final quantityC = TextEditingController();
  final unitPriceC = TextEditingController();
  final discountPercentC = TextEditingController();
  final discountMaxC = TextEditingController();
  XFile? imageFile;
  String categoryProductC = "electronics";

  Future<void> showDate(BuildContext context) async {
    DateTime? pickedDate = await showDialog<DateTime>(
      context: context,
      builder: (context) => CustomMingdaDatePicker(
        initialDate: DateTime.now(),
      ),
    );
    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) => Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.blueLine,
              onPrimary: Colors.white,
              onSurface: AppColors.charcoal,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.blueLine,
              ),
            ),
            timePickerTheme: const TimePickerThemeData(backgroundColor: Colors.white),
          ),
          child: child!,
        ),
      );
      if (pickedTime != null) {
        final dateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        final formatDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
        setState(() {
          createdOnC.text = formatDateTime;
        });
      }
    }
  }

  void _submitData(BuildContext context) {
    if (formKey.currentState!.validate()) {
      final product = Product(
        id: "",
        category: categoryProductC,
        createdOn: createdOnC.text,
        imageProduct: "",
        productName: nameProductC.text,
        productCode: productCodeC.text,
        quantity: int.tryParse(quantityC.text) ?? 0,
        unitPrice: int.tryParse(unitPriceC.text) ?? 0,
        discountPercent: int.tryParse(discountPercentC.text),
        discountMax: int.tryParse(discountMaxC.text),
      );

      context.read<AddUnitBloc>().add(AddUnitSubmitted(
        product: product,
        imageFile: imageFile,
      ));
    }
  }

  void _resetForm() {
    productCodeC.clear();
    nameProductC.clear();
    createdOnC.clear();
    quantityC.clear();
    unitPriceC.clear();
    discountPercentC.clear();
    discountMaxC.clear();
    setState(() {
      categoryProductC = "electronics";
      imageFile = null;
    });
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AddUnitBloc>(),
      child: BlocConsumer<AddUnitBloc, AddUnitState>(
        listener: (context, state) {
          if (state.status == AddUnitStatus.success) {
            CustomTopSnackbar.show(context, state.successMessage, isError: false);
            _resetForm();
          } else if (state.status == AddUnitStatus.failure) {
            CustomTopSnackbar.show(context, state.errorMessage, isError: true);
          }
        },
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: AppColors.bgColor,
            body: Form(
              key: formKey,
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 145.h),
                          Container(
                            width: 322.w,
                            child: Column(
                              spacing: 16.h,
                              children: [
                                InputWidget(
                                  head: "Code Product",
                                  controller: productCodeC,
                                  placeholder: "placeholder",
                                  necessary: true,
                                  formKey: formKey,
                                ),
                                InputWidget(
                                  head: "Name Product",
                                  controller: nameProductC,
                                  placeholder: "placeholder",
                                  necessary: true,
                                  formKey: formKey,
                                ),
                                InputSelectAddUnitWidget(
                                  head: "Category Product",
                                  placeholder: "placeholder",
                                  necessary: true,
                                  formKey: formKey,
                                  value: categoryProductC,
                                  onChanged: (val) {
                                    if (val != null) {
                                      setState(() {
                                        categoryProductC = val;
                                      });
                                    }
                                  },
                                ),
                                InkWell(
                                  onTap: () {
                                    showDate(context);
                                  },
                                  child: IgnorePointer(
                                    child: DatePickerWidget(
                                      head: "Created On",
                                      controller: createdOnC,
                                      placeholder: "placeholder",
                                      necessary: true,
                                      formKey: formKey,
                                      isShort: false,
                                      feature: "add_unit",
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    InputShortWidget(
                                      head: "Quantity",
                                      controller: quantityC,
                                      placeholder: "placeholder",
                                      necessary: true,
                                      formKey: formKey,
                                    ),
                                    InputShortWidget(
                                      head: "Unit Price",
                                      controller: unitPriceC,
                                      placeholder: "placeholder",
                                      necessary: true,
                                      formKey: formKey,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    InputShortWidget(
                                      head: "Discount (%)",
                                      controller: discountPercentC,
                                      placeholder: "40",
                                      necessary: false,
                                      formKey: formKey,
                                    ),
                                    InputShortWidget(
                                      head: "Max Discount",
                                      controller: discountMaxC,
                                      placeholder: "200000",
                                      necessary: false,
                                      formKey: formKey,
                                    ),
                                  ],
                                ),

                                Container(
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "Upload Image",
                                              style: GoogleFonts.poppins(
                                                fontSize: 16.sp,
                                                color: AppColors.grayTitle,
                                                fontWeight: AppFontWeight.semiBold,
                                              ),
                                            ),
                                            TextSpan(
                                              text: " *",
                                              style: GoogleFonts.poppins(
                                                fontSize: 16.sp,
                                                color: Colors.red,
                                                fontWeight: AppFontWeight.semiBold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 7.h),
                                      Text(
                                        "Please upload the image of product.",
                                        style: GoogleFonts.poppins(
                                          fontSize: 10.sp,
                                          color: AppColors.grayTitle,
                                          fontWeight: AppFontWeight.regular,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () async {
                                      final ImagePicker picker = ImagePicker();
                                      XFile? image = await picker.pickImage(
                                        source: ImageSource.gallery,
                                      );
                                      if (image != null) {
                                        setState(() {
                                          imageFile = image;
                                        });
                                      }
                                    },
                                    child: Ink(
                                      width: 331.w,
                                      height: 183.h,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10.w),
                                      ),
                                      child: DottedBorder(
                                        options: RoundedRectDottedBorderOptions(
                                          radius: Radius.circular(10.w),
                                          color: AppColors.coolGray,
                                          dashPattern: [10, 10],
                                          strokeWidth: 2.w,
                                        ),
                                        child: Center(
                                          child: imageFile != null
                                              ? ClipRRect(
                                                  borderRadius: BorderRadius.circular(10.w),
                                                  child: Image.file(
                                                    File(imageFile!.path),
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                    fit: BoxFit.contain,
                                                  ),
                                                )
                                              : Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                      "assets/images/galery_add.png",
                                                      width: 48.w,
                                                      height: 48.h,
                                                    ),
                                                  ],
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 140.h),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 393.w,
                        height: 106.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.white54, Colors.white],
                            begin: AlignmentGeometry.topCenter,
                            end: AlignmentGeometry.bottomCenter,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: 55.w,
                              height: 55.h,
                              child: ElevatedButton(
                                onPressed: () {
                                  _resetForm();
                                },
                                child: SvgPicture.asset(
                                  "assets/icons/delete.svg",
                                  width: 32.w,
                                  height: 32.h,
                                  fit: BoxFit.contain,
                                ),
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.w),
                                  ),
                                  backgroundColor: Colors.white,
                                ),
                              ),
                            ),
                            Container(
                              width: 261.w,
                              height: 55.h,
                              decoration: BoxDecoration(
                                gradient: AppColors.premiumDarkGradient,
                                borderRadius: BorderRadius.circular(10.w),
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  _submitData(context);
                                },
                                child: Text(
                                  "Kirim",
                                  style: GoogleFonts.roboto(
                                    fontWeight: AppFontWeight.regular,
                                    fontSize: 20.sp,
                                    color: Colors.white,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.w),
                                  ),
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 112.h,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 4),
                                    blurRadius: 14.2.w,
                                    spreadRadius: 0,
                                    color: AppColors.appBarShadow,
                                  ),
                                ],
                                color: Colors.white,
                              ),
                              child: Column(
                                children: [
                                  SizedBox(height: 63.h),
                                  Container(
                                    padding: EdgeInsets.only(left: 30.w),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            context.pop();
                                          },
                                          child: Icon(Icons.close, size: 24.w),
                                        ),
                                        SizedBox(width: 19.w),
                                        Text(
                                          "Back To Summary",
                                          style: GoogleFonts.poppins(
                                            fontSize: 16.sp,
                                            fontWeight: AppFontWeight.medium,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  state.status == AddUnitStatus.loading
                      ? Container(
                          color: Colors.black26,
                          child: Center(
                            child: LoadingAnimationWidget.stretchedDots(
                              color: AppColors.softWhite,
                              size: 70.w,
                            ),
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
