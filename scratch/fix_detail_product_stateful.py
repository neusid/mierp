import re

fp = r"d:\Project\Flutter\mierp\lib\features\detail\presentation\detail_product\detail_product_view.dart"
with open(fp, "r", encoding="utf-8") as f: code = f.read()

# Change StatelessWidget to StatefulWidget
old_class = """class DetailProductView extends StatelessWidget {
  DetailProductView({super.key});

  
  
  
  final formKey = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {"""

new_class = """class DetailProductView extends StatefulWidget {
  DetailProductView({super.key});

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
  
  String categoryProductC = "electronics";
  String imageProduct = "";
  dynamic currentProduct;
  late String id;

  @override
  void initState() {
    super.initState();
    id = getx.Get.parameters['id']!;
  }

  @override
  void dispose() {
    productCodeC.dispose();
    nameProductC.dispose();
    createdOnC.dispose();
    quantityC.dispose();
    unitPriceC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {"""
code = code.replace(old_class, new_class)

# Replace widget.id with just id
code = code.replace("widget.id", "id")

# Remove remaining detailProductViewVM prefix
code = code.replace("detailProductViewVM.productCodeC", "productCodeC")
code = code.replace("detailProductViewVM.nameProductC", "nameProductC")
code = code.replace("detailProductViewVM.createdOnC", "createdOnC")
code = code.replace("detailProductViewVM.quantityC", "quantityC")
code = code.replace("detailProductViewVM.unitPriceC", "unitPriceC")
code = code.replace("detailProductViewVM.categoryProductC.value =", "setState(() => categoryProductC =")
code = code.replace("detailProductViewVM.categoryProductC.value", "categoryProductC")

# Handle the specific case of image change if it exists
code = code.replace("detailProductViewVM.changeImage();", "setState(() { /* Implement image change */ });")

with open(fp, "w", encoding="utf-8") as f: f.write(code)

print("DetailProductView converted to StatefulWidget")
