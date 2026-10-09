import re

fp = r"d:\Project\Flutter\mierp\lib\features\summary\presentation\summary_view.dart"
with open(fp, "r", encoding="utf-8") as f: code = f.read()

# Replace GetX controller injections
old_start = """class SummaryView extends StatelessWidget {
  SummaryView({super.key});

  final summaryVM = Get.find<SummaryViewModel>();
  final movePageC = Get.find<MovePageController>();
  final loadingC = Get.find<LoadingController>();
  final convertDollar = ConvertDollar();

  @override
  Widget build(BuildContext context) {
    ever(summaryVM.success, (status) {
      if (status == true) {
        Get.snackbar("Success", ("Success pay invoice"));
        summaryVM.success.value = false;
      }
    });

    ever(summaryVM.errorMessage, (msg) {
      Get.snackbar("Failed", msg);
      summaryVM.errorMessage.value = "";
    });

    return Scaffold("""
new_start = """class SummaryView extends StatelessWidget {
  SummaryView({super.key});

  final convertDollar = ConvertDollar();

  final tabs = [
    {"title": "All Summary", "collection": "all_summary"},
    {"title": "Order", "collection": "warehouse_order"},
    {"title": "Sales Order", "collection": "sales_order"},
    {"title": "Stock", "collection": "products"},
  ];
  final options = ['All', 'Paid', 'Unpaid'];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SummaryBloc>()..add(SummaryStarted()),
      child: BlocConsumer<SummaryBloc, SummaryState>(
        listener: (context, state) {
           if (state.errorMessage.isNotEmpty) {
             getx.Get.snackbar("Error", state.errorMessage);
           }
           if (state.successMessage.isNotEmpty) {
             getx.Get.snackbar("Success", state.successMessage);
           }
        },
        builder: (context, state) {
          return Scaffold("""
code = code.replace(old_start, new_start)

# End tags
code = code.replace("""              : SizedBox(),
        ),
      ],
    );
  }
}""", """              : SizedBox(),
        ],
      );
    }));
  }
}""")

# Obx removal for chips & tabs
# The previous script actually worked for variables, let's just make sure we do it properly
code = code.replace("summaryVM.role.value", "state.role")
code = code.replace("summaryVM.keyword.value", "state.keyword")
code = code.replace("summaryVM.tag.value", "state.tag")
code = code.replace("summaryVM.collection.value", "state.selectedTab")
code = code.replace("summaryVM.isLoading.value", "state.isLoading")
code = code.replace("summaryVM.options", "options")
code = code.replace("summaryVM.searchKeyC", "TextEditingController(text: state.keyword)")
code = code.replace("summaryVM.moveBack()", "getx.Get.back()")

code = code.replace("summaryVM.listProduct", "state.filteredProducts")
code = code.replace("summaryVM.listOrder", "state.filteredOrders")
code = code.replace("summaryVM.listSalesOrder", "state.filteredSalesOrders")
code = code.replace("summaryVM.listAllSummary", "state.filteredSummaries")

code = code.replace("summaryVM.filterData(val)", "context.read<SummaryBloc>().add(SummaryFilterChanged(val))")
code = code.replace("onChanged: (val) {\n                                                        summaryVM.keyword.value = val;\n                                                      },", "onChanged: (val) {\n                                                        context.read<SummaryBloc>().add(SummarySearchChanged(val));\n                                                      },")

tabs_old = """summaryVM.tabs
                              .map(
                                (e) => Obx(() {
                                  final isActive = e.isActive.value;
                                  return GestureDetector(
                                    onTap: () async {
                                      summaryVM.changeTab(e);
                                    },"""
tabs_new = """tabs
                              .map(
                                (e) {
                                  final isActive = state.selectedTab == e['collection'];
                                  return GestureDetector(
                                    onTap: () async {
                                      context.read<SummaryBloc>().add(SummaryTabChanged(e['collection']!));
                                    },"""
code = code.replace(tabs_old, tabs_new)

code = code.replace("""e.title,
                                          style: GoogleFonts.inter(
                                            fontSize: 11.sp,
                                            fontWeight: AppFontWeight.medium,
                                            color: isActive
                                                ? Colors.white
                                                : AppColors.charcoal,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),""", """e['title']!,
                                          style: GoogleFonts.inter(
                                            fontSize: 11.sp,
                                            fontWeight: AppFontWeight.medium,
                                            color: isActive
                                                ? Colors.white
                                                : AppColors.charcoal,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },""")

code = code.replace("Obx(() {\n                              return Material(", "Builder(builder: (context) {\n                              return Material(")
code = code.replace("Obx(() {\n                                                    return ChipsChoice<\n                                                      int", "Builder(builder: (context) {\n                                                    return ChipsChoice<\n                                                      int")
code = code.replace("Obx(() {\n                        return Container(", "Builder(builder: (context) {\n                        return Container(")

code = code.replace("Obx(() {\n                  if (state.selectedTab == \"all_summary\") {", "Builder(builder: (context) {\n                  if (state.selectedTab == \"all_summary\") {")
code = code.replace("} else if (state.selectedTab == \"products\") {", "} else if (state.selectedTab == \"products\") {")

code = code.replace("summaryVM.detailProductOrder(e.data!.id);", "getx.Get.toNamed(\"/detail_product_order/${e.data!.id}\");")
code = code.replace("summaryVM.detailProductOrder(data!.id);", "getx.Get.toNamed(\"/detail_product_order/${data!.id}\");")
code = code.replace("summaryVM.detailSalesOrder(e!.data.id);", "getx.Get.toNamed(\"/detail_sales_order/${e!.data.id}\");")
code = code.replace("summaryVM.detailSalesOrder(e!.id);", "getx.Get.toNamed(\"/detail_sales_order/${e!.id}\");")

# Need to replace Obx for isLoading
loading_old = """Obx(
              () => state.isLoading
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
            ),"""
loading_new = """state.isLoading
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
code = code.replace(loading_old, loading_new)


with open(fp, "w", encoding="utf-8") as f: f.write(code)

print("SummaryView refactored!")
