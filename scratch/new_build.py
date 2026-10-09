import sys
import re

new_build = """  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AddProductOrderBloc>()..add(AddProductOrderLoadProducts()),
      child: BlocConsumer<AddProductOrderBloc, AddProductOrderState>(
        listener: (context, state) {
          if (state.status == AddProductOrderStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Berhasil menyimpan data!")));
            context.pop();
          } else if (state.status == AddProductOrderStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage)));
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.bgColor,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: false,
              leading: IconButton(
                icon: Icon(Icons.close_rounded, color: const Color(0xFF0F172A)),
                onPressed: () => context.pop(),
              ),
              title: Text(
                "Add Product Order",
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: AppFontWeight.bold,
                  color: const Color(0xFF0F172A),
                  letterSpacing: -0.3,
                ),
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(1.0),
                child: Container(
                  color: const Color(0xFFE2E8F0),
                  height: 1.0,
                ),
              ),
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                  child: Column(
                    children: [
                      // The "Selimut" Card
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.w),
                          border: Border.all(color: Colors.white, width: 1.5.w),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10.w,
                              offset: Offset(0, 4.h),
                            ),
                          ],
                        ),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InputSelectProductOrderWidget(
                                head: "Name Product",
                                placeholder: "Select Product",
                                necessary: true,
                                formKey: formKey,
                                products: state.listProduct,
                                value: selectedProduct,
                                width: double.infinity,
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() {
                                      selectedProduct = val;
                                    });
                                  }
                                },
                              ),
                              SizedBox(height: 16.h),
                              if (selectedProduct != null && (selectedProduct!.discountPercent ?? 0) > 0)
                                Container(
                                  margin: EdgeInsets.only(bottom: 16.h),
                                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFEF3C7),
                                    borderRadius: BorderRadius.circular(8.w),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.local_offer_rounded, size: 16.w, color: const Color(0xFFB45309)),
                                      SizedBox(width: 8.w),
                                      Expanded(
                                        child: Text(
                                          "Discount Applied: ${selectedProduct!.discountPercent}% (Max: ${(selectedProduct!.discountMax ?? 0) / 1000}rb)",
                                          style: GoogleFonts.inter(
                                            fontSize: 12.sp,
                                            fontWeight: AppFontWeight.bold,
                                            color: const Color(0xFFB45309),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: DatePickerWidget(
                                      head: "Order Date",
                                      controller: orderDateC,
                                      placeholder: "Select Date",
                                      necessary: true,
                                      formKey: formKey,
                                      width: double.infinity,
                                    ),
                                  ),
                                  SizedBox(width: 16.w),
                                  Expanded(
                                    child: InputShortWidget(
                                      head: "Quantity",
                                      controller: quantityC,
                                      placeholder: "0",
                                      iconAsset: "box.svg",
                                      necessary: true,
                                      formKey: formKey,
                                      width: double.infinity,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 100.h), // Extra padding for safe area
                    ],
                  ),
                ),
                if (state.status == AddProductOrderStatus.loading)
                  Container(
                    color: Colors.black26,
                    child: Center(
                      child: LoadingAnimationWidget.stretchedDots(
                        color: AppColors.softWhite,
                        size: 70.w,
                      ),
                    ),
                  ),
              ],
            ),
            bottomNavigationBar: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10.w,
                    offset: Offset(0, -4.h),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Container(
                      width: 52.w,
                      height: 52.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.w),
                        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5.w),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.refresh_rounded, color: const Color(0xFF64748B)),
                        onPressed: _resetForm,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Container(
                        height: 52.w,
                        decoration: BoxDecoration(
                          gradient: AppColors.premiumDarkGradient,
                          borderRadius: BorderRadius.circular(10.w),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.premiumDark.withOpacity(0.2),
                              blurRadius: 8.w,
                              offset: Offset(0, 4.w),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () => _submitData(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.w),
                            ),
                          ),
                          child: Text(
                            "Kirim",
                            style: GoogleFonts.inter(
                              fontWeight: AppFontWeight.semiBold,
                              fontSize: 16.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}"""

with open(r'D:\Project\Flutter\mierp\lib\features\add\presentation\add_product_order\add_product_order_view.dart', 'r', encoding='utf-8') as f:
    text = f.read()

old_text = re.sub(r'  @override\n  Widget build\(BuildContext context\) \{.*', new_build, text, flags=re.DOTALL)

with open(r'D:\Project\Flutter\mierp\lib\features\add\presentation\add_product_order\add_product_order_view.dart', 'w', encoding='utf-8') as f:
    f.write(old_text)

print("Updated view")
