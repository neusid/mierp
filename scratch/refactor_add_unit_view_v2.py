import re

view_path = r"d:\Project\Flutter\mierp\lib\features\add\presentation\add_unit\add_unit_view.dart"
with open(view_path, 'r', encoding='utf-8') as f:
    view_code = f.read()

imports = """import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mierp_apps/core/di/injection_container.dart';
import 'package:mierp_apps/core/models/product.dart';
import 'package:mierp_apps/features/add/presentation/add_unit/bloc/add_unit_bloc.dart';
import 'package:mierp_apps/features/add/presentation/add_unit/bloc/add_unit_event.dart';
import 'package:mierp_apps/features/add/presentation/add_unit/bloc/add_unit_state.dart';"""

class_start_idx = view_code.find("class AddUnitView extends StatelessWidget")

# Combine imports
new_view_code = view_code[:class_start_idx] + imports + "\n\n"

# Remove unused imports
new_view_code = new_view_code.replace("import 'package:mierp_apps/features/add/presentation/add_unit/add_unit_view_model.dart';\n", "")
new_view_code = new_view_code.replace("import 'package:mierp_apps/core/controller/move_page_controller.dart';\n", "")
new_view_code = new_view_code.replace("import 'package:mierp_apps/core/utils/loading_controller.dart';\n", "")

new_class = """class AddUnitView extends StatefulWidget {
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
  XFile? imageFile;
  String categoryProductC = "electronics";

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AddUnitBloc>(),
      child: BlocConsumer<AddUnitBloc, AddUnitState>(
        listener: (context, state) {
          if (state.status == AddUnitStatus.success) {
            Get.snackbar("Success", state.successMessage);
            _resetForm();
          } else if (state.status == AddUnitStatus.failure) {
            Get.snackbar("Failed", state.errorMessage);
          }
        },
        builder: (context, state) {
"""

build_idx = view_code.find("    return Scaffold(")
remaining_code = view_code[build_idx:]

new_view_code += new_class + remaining_code

# Replace properties in the UI
new_view_code = new_view_code.replace("addUnitVM.productCodeC", "productCodeC")
new_view_code = new_view_code.replace("addUnitVM.nameProductC", "nameProductC")
new_view_code = new_view_code.replace("addUnitVM.createdOnC", "createdOnC")
new_view_code = new_view_code.replace("addUnitVM.quantityC", "quantityC")
new_view_code = new_view_code.replace("addUnitVM.unitPriceC", "unitPriceC")
new_view_code = new_view_code.replace("addUnitVM.categoryProductC.value", "categoryProductC")

# Replace showDate
new_view_code = re.sub(
    r"addUnitVM\.showDate\(context\);",
    r"""DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100),
                                      builder: (context, child) => Theme(
                                        data: Theme.of(context).copyWith(
                                          datePickerTheme: DatePickerThemeData(backgroundColor: Colors.white),
                                        ),
                                        child: child!,
                                      ),
                                    );
                                    if (pickedDate != null) {
                                      TimeOfDay? pickedTime = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                        builder: (context, child) => Theme(
                                          data: Theme.of(context).copyWith(
                                            timePickerTheme: TimePickerThemeData(backgroundColor: Colors.white),
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
                                    }""",
    new_view_code
)

# Replace image picker logic
obx_image_regex = r"Obx\(\(\) \{\s*if \(addUnitVM\.imageFile\.value == null\) \{[\s\S]*?\} else \{[\s\S]*?\}\s*\}\),"
new_image = """Builder(builder: (context) {
                                if (imageFile == null) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset("assets/svg/add/image_add.svg", width: 44.w),
                                      SizedBox(height: 7.h),
                                      Text(
                                        "Select Image",
                                        style: GoogleFonts.poppins(
                                          fontSize: 10.sp,
                                          fontWeight: AppFontWeight.regular,
                                          color: AppColors.gray2,
                                        ),
                                      )
                                    ],
                                  );
                                } else {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(10.w),
                                    child: Image.file(
                                      File(imageFile!.path),
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                }
                              }),"""
new_view_code = re.sub(obx_image_regex, new_image, new_view_code)

picker_regex = r"final ImagePicker picker = ImagePicker\(\);\n\s*final XFile\? image = await picker\.pickImage\(source: ImageSource\.gallery\);\n\s*if \(image != null\) \{\n\s*addUnitVM\.imageFile\.value = image;\n\s*\}"
new_picker = """final ImagePicker picker = ImagePicker();
                                  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                                  if (image != null) {
                                    setState(() {
                                      imageFile = image;
                                    });
                                  }"""
new_view_code = re.sub(picker_regex, new_picker, new_view_code)


# Replace submit button
button_regex = r"if \(formKey\.currentState!\.validate\(\)\) \{\n\s*addUnitVM\.requestPostDataProduct\(\);\n\s*\}"
new_view_code = re.sub(button_regex, "_submitData(context);", new_view_code)


# Loading Obx at the end
loading_regex = r"Obx\(\(\) => addUnitVM\.isLoading\.value\s*\? Container\([\s\S]*?:\s*SizedBox\(\),\s*\),"
new_loading = """state.status == AddUnitStatus.loading
                ? Container(
                    color: Colors.black26,
                    child: Center(
                      child: LoadingAnimationWidget.stretchedDots(
                        color: AppColors.softWhite,
                        size: 70.w,
                      ),
                    ),
                  )
                : SizedBox(),"""
new_view_code = re.sub(loading_regex, new_loading, new_view_code)


# Close BlocConsumer and BlocProvider
new_view_code = re.sub(r"\}\);[\s\n]*\}[\s\n]*\}", 
                   "});\n        },\n      ),\n    );\n  }\n}", new_view_code)


with open(view_path, 'w', encoding='utf-8') as f:
    f.write(new_view_code)

print("Add unit view refactored V2")
