import re

file_path = r'd:\Project\Flutter\mierp\lib\core\models\product.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

copy_with_code = """
  Product copyWith({
    String? id,
    String? category,
    String? createdOn,
    String? imageProduct,
    String? productName,
    String? productCode,
    int? quantity,
    int? unitPrice,
    int? discountPercent,
    int? discountMax,
  }) {
    return Product(
      id: id ?? this.id,
      category: category ?? this.category,
      createdOn: createdOn ?? this.createdOn,
      imageProduct: imageProduct ?? this.imageProduct,
      productName: productName ?? this.productName,
      productCode: productCode ?? this.productCode,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      discountPercent: discountPercent ?? this.discountPercent,
      discountMax: discountMax ?? this.discountMax,
    );
  }
"""

if 'copyWith' not in content:
    content = re.sub(r'\}\s*$', copy_with_code + '}\n', content)
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)
    print("Added copyWith to Product.")
else:
    print("copyWith already exists.")
