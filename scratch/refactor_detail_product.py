import re

# Refactoring DetailProductView safely

fp = r"d:\Project\Flutter\mierp\lib\features\detail\presentation\detail_product\detail_product_view.dart"
with open(fp, "r", encoding="utf-8") as f: code = f.read()

# 1. Imports
code = code.replace("import 'package:get/get.dart';", "import 'package:flutter_bloc/flutter_bloc.dart';\nimport 'package:mierp_apps/features/detail/presentation/detail_product/bloc/detail_product_bloc.dart';\nimport 'package:mierp_apps/core/di/injection_container.dart';\nimport 'package:get/get.dart' as getx;")

code = code.replace("import 'package:mierp_apps/features/detail/presentation/detail_product/detail_product_view_model.dart';", "")

# 2. View Model instantiations
code = code.replace("final detailProductViewVM = Get.find<DetailProductViewModel>();", "")
code = code.replace("final movePageC = Get.find<MovePageController>();", "")
code = code.replace("final loadingC = Get.find<LoadingController>();", "")

# 3. BlocProvider wrap
old_build = """  @override
  Widget build(BuildContext context) {
    return Scaffold("""

new_build = """  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DetailProductBloc>()..add(DetailProductStarted(widget.id)),
      child: BlocConsumer<DetailProductBloc, DetailProductState>(
        listener: (context, state) {
          if (state.status == DetailProductStatus.success && state.product != null) {
            currentProduct = state.product;
            productCodeC.text = state.product!.productCode;
            nameProductC.text = state.product!.productName;
            createdOnC.text = state.product!.createdOn;
            quantityC.text = state.product!.quantity.toString();
            unitPriceC.text = state.product!.unitPrice.toString();
            setState(() {
                imageProduct = state.product!.imageProduct ?? "";
                categoryProductC = state.product!.category ?? "electronics";
            });
            if (state.successMessage.isNotEmpty) {
              getx.Get.snackbar("Success", state.successMessage);
            }
          } else if (state.status == DetailProductStatus.deleteSuccess) {
            getx.Get.snackbar("Success", state.successMessage);
            Future.delayed(Duration(seconds: 2), () {
               getx.Get.toNamed("warehouse_main_page");
            });
          } else if (state.status == DetailProductStatus.failure) {
            getx.Get.snackbar("Failed", state.errorMessage);
          }
        },
        builder: (context, state) {
    return Scaffold("""
code = code.replace(old_build, new_build)

# 4. Replace GetX controller method calls
code = code.replace("detailProductViewVM.delete();", "context.read<DetailProductBloc>().add(DetailProductDeleteRequested(widget.id));")
code = code.replace("detailProductViewVM.updateProduct(", "context.read<DetailProductBloc>().add(DetailProductUpdateRequested(")

# 5. Remove Obx for loading
old_obx = """        Obx(
          () => detailProductViewVM.isLoading.value
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
        ),
      ],
    );
  }
}"""
new_obx = """        state.isLoading
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
    );
        },
      ),
    );
  }
}"""
code = code.replace(old_obx, new_obx)
code = code.replace("movePageC.moveToPage(4);", "getx.Get.back();")

with open(fp, "w", encoding="utf-8") as f:
    f.write(code)

print("DetailProductView safely refactored")
