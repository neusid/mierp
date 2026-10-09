import sys
import re

file_path = r'd:\Project\Flutter\mierp\lib\features\dashboard\presentation\warehouse\dashboard_warehouse_view.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# 1. Replace the Header PNG with Native Gradient
old_header = """                  Container(
                    width: 394.w,
                    height: 158.h,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/warehouse_card.png"),
                        fit: BoxFit.cover,
                        alignment: AlignmentGeometry.directional(0, 0.5),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF7A00E6),
                          Color(0xFF4B3FEB),
                          Color(0xFF29B1FF),
                        ],
                        transform: GradientRotation(0.35.sw),
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(60.w),
                      ),
                    ),"""

new_header = """                  Container(
                    width: 1.sw,
                    height: 140.h,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF3B82F6), Color(0xFF6D28D9)],
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(60.w),
                      ),
                    ),"""
content = content.replace(old_header, new_header)

# 2. Add TopMetrics Row (we replaced the top cards previously)
# Wait, let's just make the whole TopMetrics row.

# 3. Replace all "getx.Get.toNamed" with "context.push"
content = content.replace("getx.Get.toNamed", "context.push")
if "import 'package:go_router/go_router.dart';" not in content:
    content = content.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport 'package:go_router/go_router.dart';")

# 4. Use QuickAddCard for the add buttons
# The original code has the 3 cards. We will find them and replace them.
# Look for 'Padding(' and 'Text("Add New Unit")'
# Actually I'll just write a clean python string replace for those

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)

print("Partial restoration done.")
