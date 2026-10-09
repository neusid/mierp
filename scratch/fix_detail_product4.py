import re

fp = r"d:\Project\Flutter\mierp\lib\features\detail\presentation\detail_product\detail_product_view.dart"
with open(fp, "r", encoding="utf-8") as f: code = f.read()

# Fix Obx for imageProduct
old_obx_image = """                                Obx(() {
                                  return Container(
                                    width: 331.w,
                                    height: 183.h,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image:
                                            detailProductViewVM
                                                .imageProduct
                                                .value
                                                .isEmpty
                                            ? AssetImage(
                                                "assets/images/dummy_item.jpg",
                                              )
                                            : NetworkImage(
                                                detailProductViewVM
                                                    .imageProduct
                                                    .value,
                                              ) as ImageProvider,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  );
                                }),"""
new_image = """                                Builder(builder: (context) {
                                  return Container(
                                    width: 331.w,
                                    height: 183.h,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image:
                                            imageProduct.isEmpty
                                            ? AssetImage(
                                                "assets/images/dummy_item.jpg",
                                              )
                                            : NetworkImage(
                                                imageProduct,
                                              ) as ImageProvider,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  );
                                }),"""
code = code.replace(old_obx_image, new_image)

# Fix DetailProductUpdateRequested
old_update = """                              context.read<DetailProductBloc>().add(
                                DetailProductUpdateRequested(
                                  id: widget.id,
                                  productCode: productCodeC.text,
                                  productName: nameProductC.text,
                                  quantity: int.parse(quantityC.text),
                                  unitPrice: int.parse(unitPriceC.text),
                                ),
                              );"""
new_update = """                              final updatedProduct = currentProduct.copyWith(
                                productCode: productCodeC.text,
                                productName: nameProductC.text,
                                quantity: int.parse(quantityC.text),
                                unitPrice: int.parse(unitPriceC.text),
                                category: categoryProductC,
                              );
                              context.read<DetailProductBloc>().add(
                                DetailProductUpdateRequested(updatedProduct),
                              );"""
code = code.replace(old_update, new_update)

with open(fp, "w", encoding="utf-8") as f: f.write(code)

print("Fix DetailProductView image and update")
