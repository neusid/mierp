import sys

file_path = r'd:\Project\Flutter\mierp\lib\features\dashboard\presentation\warehouse\dashboard_warehouse_view.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# 1. Remove getx import
content = content.replace("import 'package:get/get.dart' as getx;", "")

# 2. Fix the duplicated Container in the header
bad_header = """              Stack(
                children: [
                  Container(
                    width: 1.sw,
              Container("""
good_header = """              Stack(
                children: [
              Container("""
content = content.replace(bad_header, good_header)

# 3. Fix BlanketMattressWidget missing parameters
low_stock_old = """                    BlanketMattressWidget(
                      title: "Low Stock Products",
                      subtitle: "Needs immediate attention",
                      themeBgColor: const Color(0xFFFFF1F2),"""
low_stock_new = """                    BlanketMattressWidget(
                      title: "Low Stock Products",
                      subtitle: "Needs immediate attention",
                      count: state.totalLowStock,
                      rightTitle: "Action Req.",
                      rightSubtitle: "Order soon",
                      progress: 0.8,
                      themeColor: const Color(0xFFEF4444),
                      themeBgColor: const Color(0xFFFFF1F2),"""
content = content.replace(low_stock_old, low_stock_new)

incoming_old = """                    BlanketMattressWidget(
                      title: "Incoming Stock",
                      subtitle: "Expected today",
                      themeBgColor: const Color(0xFFEEF2FF),"""
incoming_new = """                    BlanketMattressWidget(
                      title: "Incoming Stock",
                      subtitle: "Expected today",
                      count: state.totalUpcomingStock,
                      rightTitle: "On Track",
                      rightSubtitle: "Arriving",
                      progress: 0.5,
                      themeColor: const Color(0xFF3B82F6),
                      themeBgColor: const Color(0xFFEEF2FF),"""
content = content.replace(incoming_old, incoming_new)

# 4. Fix Obx at the bottom
obx_old = """        Obx(
          () => warehouseVM.isLoading.value
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
    }));"""
obx_new = """        if (state.isLoading)
          Container(
            color: Colors.black26,
            child: Center(
              child: LoadingAnimationWidget.stretchedDots(
                color: AppColors.softWhite,
                size: 70.w,
              ),
            ),
          )
      ],
    );
  },
),
);"""
content = content.replace(obx_old, obx_new)

# Let's also verify that there is no `getx.context`
content = content.replace("getx.context.push", "context.push")

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)

# Fix quick_add_card.dart
quick_card_path = r'd:\Project\Flutter\mierp\lib\core\widgets\dashboard\quick_add_card.dart'
with open(quick_card_path, 'r', encoding='utf-8') as f:
    qc_content = f.read()

qc_content = qc_content.replace("import 'package:mierp_apps/core/utils/colors.dart';", "import 'package:mierp_apps/core/theme/app_colors.dart';")

with open(quick_card_path, 'w', encoding='utf-8') as f:
    f.write(qc_content)

print("Fixes applied.")
