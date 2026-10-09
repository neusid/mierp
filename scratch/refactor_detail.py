import os
import re

view_path = r"d:\Project\Flutter\mierp\lib\features\detail\presentation\detail_product\detail_product_view.dart"
widget_path = r"d:\Project\Flutter\mierp\lib\core\widgets\detail\input_select_update_widget.dart"

# 1. Update InputSelectUpdateWidget
with open(widget_path, 'r', encoding='utf-8') as f:
    widget_code = f.read()

widget_code = widget_code.replace("import 'package:get/get.dart';", "import 'package:get/get.dart' as getx;")
widget_code = widget_code.replace("import 'package:mierp_apps/features/detail/presentation/detail_product/detail_product_view_model.dart';", "")

widget_code = re.sub(
    r"class InputSelectUpdateWidget extends StatelessWidget \{[\s\S]*?final head, placeholder, necessary, formKey;",
    """class InputSelectUpdateWidget extends StatelessWidget {
  InputSelectUpdateWidget({
    super.key,
    required this.head,
    required this.placeholder,
    required this.necessary,
    required this.formKey,
    required this.value,
    required this.onChanged,
  });

  final String head, placeholder;
  final bool necessary;
  final GlobalKey<FormState> formKey;
  final String value;
  final ValueChanged<String?> onChanged;""",
    widget_code
)

widget_code = re.sub(r"final detailProductVM = Get\.find<DetailProductViewModel>\(\);", "", widget_code)

widget_code = widget_code.replace("value: detailProductVM.categoryProductC.value,", "value: value,")
widget_code = widget_code.replace("detailProductVM.categoryProductC.value = value!;", "if (value != null) onChanged(value);")
widget_code = widget_code.replace("RxBool hasError = false.obs;", "bool hasError = false;")
widget_code = widget_code.replace("RxString dataError = \"\".obs;", "String dataError = \"\";")
widget_code = widget_code.replace("!hasError.value", "!hasError")
widget_code = widget_code.replace("hasError.value", "hasError")
widget_code = widget_code.replace("dataError.value", "dataError")
widget_code = widget_code.replace("return Obx(() {", "return Builder(builder: (context) {")

with open(widget_path, 'w', encoding='utf-8') as f:
    f.write(widget_code)


# 2. Update DetailProductView
with open(view_path, 'r', encoding='utf-8') as f:
    view_code = f.read()

view_code = view_code.replace("import 'package:get/get.dart';", "import 'package:get/get.dart' as getx;\nimport 'package:flutter_bloc/flutter_bloc.dart';\nimport 'package:mierp_apps/features/detail/presentation/detail_product/bloc/detail_product_bloc.dart';\nimport 'package:mierp_apps/core/di/injection_container.dart';\nimport 'package:mierp_apps/core/models/product.dart';")
view_code = view_code.replace("import 'package:mierp_apps/features/detail/presentation/detail_product/detail_product_view_model.dart';", "")

# Change to StatefulWidget
view_code = re.sub(
    r"class DetailProductView extends StatelessWidget \{[\s\S]*?final detailProductViewVM = Get\.find<DetailProductViewModel>\(\);[\s\S]*?TextEditingController controller = TextEditingController\(\);",
    """class DetailProductView extends StatefulWidget {
  final String id;
  const DetailProductView({super.key, required this.id});

  @override
  State<DetailProductView> createState() => _DetailProductViewState();
}

class _DetailProductViewState extends State<DetailProductView> {
  final movePageC = getx.Get.find<MovePageController>();
  final loadingC = getx.Get.find<LoadingController>();
  final formKey = GlobalKey<FormState>();
  
  final productCodeC = TextEditingController();
  final nameProductC = TextEditingController();
  final createdOnC = TextEditingController();
  final quantityC = TextEditingController();
  final unitPriceC = TextEditingController();
  String categoryProductC = "electronics";
  String imageProduct = "";
  Product? currentProduct;

  @override
  void dispose() {
    productCodeC.dispose();
    nameProductC.dispose();
    createdOnC.dispose();
    quantityC.dispose();
    unitPriceC.dispose();
    super.dispose();
  }
""",
    view_code
)

# Replace Build method signature
view_code = re.sub(
    r"@override\s+Widget build\(BuildContext context\) {",
    """@override
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
        builder: (context, state) {""",
    view_code
)

# Close BlocProvider and Consumer
view_code = re.sub(r"}\s*}\s*$", "        },\n      ),\n    );\n  }\n}", view_code)

# Replace controllers
view_code = view_code.replace("detailProductViewVM.productCodeC", "productCodeC")
view_code = view_code.replace("detailProductViewVM.nameProductC", "nameProductC")
view_code = view_code.replace("detailProductViewVM.createdOnC", "createdOnC")
view_code = view_code.replace("detailProductViewVM.quantityC", "quantityC")
view_code = view_code.replace("detailProductViewVM.unitPriceC", "unitPriceC")

# Replace input select widget
view_code = re.sub(
    r"InputSelectUpdateWidget\([\s\S]*?formKey: formKey,\s*\),",
    """InputSelectUpdateWidget(
                            head: "Category Product",
                            placeholder: "placeholder",
                            necessary: true,
                            formKey: formKey,
                            value: categoryProductC,
                            onChanged: (val) {
                              setState(() {
                                categoryProductC = val ?? "electronics";
                              });
                            },
                          ),""",
    view_code
)

# Replace image view
view_code = re.sub(
    r"Obx\(\(\) \{\s*return Container\(\s*width: 331\.w,[\s\S]*?image:[\s\S]*?detailProductViewVM\s*\.imageProduct\s*\.value\s*\.isEmpty[\s\S]*?child: Center\(child: Column\(\)\),\s*\);\s*\}\),",
    """Container(
                                    width: 331.w,
                                    height: 183.h,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProduct.isEmpty
                                            ? AssetImage("assets/images/dummy_item.jpg") as ImageProvider
                                            : NetworkImage(imageProduct),
                                      ),
                                      borderRadius: BorderRadius.circular(10.w),
                                    ),
                                    child: DottedBorder(
                                      options: RoundedRectDottedBorderOptions(
                                        radius: Radius.circular(10.w),
                                        color: AppColors.coolGray,
                                        dashPattern: [10, 10],
                                        strokeWidth: 2.w,
                                      ),
                                      child: Center(child: Column()),
                                    ),
                                  ),""",
    view_code
)

# Buttons
view_code = view_code.replace("detailProductViewVM.delete();", "context.read<DetailProductBloc>().add(DetailProductDeleteRequested(widget.id));")
view_code = re.sub(
    r"detailProductViewVM\.updateSingleProduct\(\);",
    """if (currentProduct != null) {
                                context.read<DetailProductBloc>().add(DetailProductUpdateRequested(
                                  Product(
                                    id: currentProduct!.id,
                                    category: categoryProductC,
                                    createdOn: createdOnC.text,
                                    imageProduct: imageProduct,
                                    productName: nameProductC.text,
                                    productCode: productCodeC.text,
                                    quantity: int.tryParse(quantityC.text) ?? 0,
                                    unitPrice: int.tryParse(unitPriceC.text) ?? 0,
                                  )
                                ));
                              }""",
    view_code
)

view_code = view_code.replace("detailProductViewVM.moveBack();", "getx.Get.back();")

view_code = re.sub(
    r"Obx\(\s*\(\) => detailProductViewVM\.isLoading\.value",
    "state.status == DetailProductStatus.loading",
    view_code
)

with open(view_path, 'w', encoding='utf-8') as f:
    f.write(view_code)

print("Done")
