import re

# Fix DetailProductView and DetailProductBloc

# 1. DetailProductState getter
fp1 = r"d:\Project\Flutter\mierp\lib\features\detail\presentation\detail_product\bloc\detail_product_bloc.dart"
with open(fp1, "r", encoding="utf-8") as f: code1 = f.read()
code1 = code1.replace("class DetailProductState extends Equatable {", "class DetailProductState extends Equatable {\n  bool get isLoading => status == DetailProductStatus.loading;")
with open(fp1, "w", encoding="utf-8") as f: f.write(code1)

# 2. DetailProductView
fp2 = r"d:\Project\Flutter\mierp\lib\features\detail\presentation\detail_product\detail_product_view.dart"
with open(fp2, "r", encoding="utf-8") as f: code2 = f.read()
# Fix update single product
old_update = """context.read<DetailProductBloc>().add(
                                DetailProductUpdateRequested(
                                  id: widget.id,
                                  productCode: productCodeC.text,
                                  productName: nameProductC.text,
                                  quantity: int.parse(quantityC.text),
                                  unitPrice: int.parse(unitPriceC.text),
                                ),
                              );"""
new_update = """
                              final updatedProduct = currentProduct.copyWith(
                                productCode: productCodeC.text,
                                productName: nameProductC.text,
                                quantity: int.parse(quantityC.text),
                                unitPrice: int.parse(unitPriceC.text),
                                category: categoryProductC,
                              );
                              context.read<DetailProductBloc>().add(
                                DetailProductUpdateRequested(updatedProduct),
                              );"""
code2 = code2.replace(old_update, new_update)
code2 = code2.replace("import 'package:mierp_apps/core/models/summary_type.dart';", "import 'package:mierp_apps/core/models/product.dart';")

# Ensure Product is imported
if "import 'package:mierp_apps/core/models/product.dart';" not in code2:
    code2 = code2.replace("import 'package:mierp_apps/core/widgets/input_widget.dart';", "import 'package:mierp_apps/core/widgets/input_widget.dart';\nimport 'package:mierp_apps/core/models/product.dart';")

with open(fp2, "w", encoding="utf-8") as f: f.write(code2)

# 3. Fix splash_bloc.dart onboardingViewModel error
fp3 = r"d:\Project\Flutter\mierp\lib\features\splash\presentation\bloc\splash_bloc.dart"
with open(fp3, "r", encoding="utf-8") as f: code3 = f.read()
code3 = re.sub(r'bool statusOnboarding =.*?;\n', r'', code3)
code3 = re.sub(r'if \(statusOnboarding\) \{.*?} else \{.*?}', r'emit(SplashSuccess(route: "/login"));', code3, flags=re.DOTALL)
code3 = code3.replace("bool statusOnboarding = onboardingViewModel.statusOnboarding.value;", "")
with open(fp3, "w", encoding="utf-8") as f: f.write(code3)

print("Fixes 3 applied")
