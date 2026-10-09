import re

def update_blanket_mattress():
    file_path = r'd:\Project\Flutter\mierp\lib\core\widgets\dashboard\blanket_mattress_widget.dart'
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # We want to replace the Container rendering the Icon with one that conditionally renders an Image if item['image'] is present
    target_block = """                        Container(
                          width: 44.w,
                          height: 44.w,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(color: const Color(0xFFF1F5F9)),
                          ),
                          child: Icon(
                            Icons.inventory_2_outlined,
                            color: const Color(0xFF64748B),
                            size: 20.w,
                          ),
                        ),"""

    replacement_block = """                        Container(
                          width: 44.w,
                          height: 44.w,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(color: const Color(0xFFF1F5F9)),
                            image: (item['image'] != null && item['image']!.isNotEmpty)
                                ? DecorationImage(
                                    image: NetworkImage(item['image']!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: (item['image'] == null || item['image']!.isEmpty)
                              ? Icon(
                                  Icons.inventory_2_outlined,
                                  color: const Color(0xFF64748B),
                                  size: 20.w,
                                )
                              : null,
                        ),"""

    if target_block in content:
        content = content.replace(target_block, replacement_block)
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(content)
        print("Updated blanket_mattress_widget.dart")
    else:
        print("Target not found in blanket_mattress_widget.dart")

def update_dashboard():
    file_path = r'd:\Project\Flutter\mierp\lib\features\dashboard\presentation\warehouse\dashboard_warehouse_view.dart'
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # We need to add "image": e.imageProduct ?? "" to both maps
    target1 = """                                      "badge": "${e.quantity} Left",
                                    },"""
    replacement1 = """                                      "badge": "${e.quantity} Left",
                                      "image": e.imageProduct ?? "",
                                    },"""
    
    target2 = """                                      "badge": "${e.quantity} Units",
                                    },"""
    replacement2 = """                                      "badge": "${e.quantity} Units",
                                      "image": e.imageProduct ?? "",
                                    },"""

    if target1 in content:
        content = content.replace(target1, replacement1)
    if target2 in content:
        content = content.replace(target2, replacement2)

    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)
    print("Updated dashboard_warehouse_view.dart")

update_blanket_mattress()
update_dashboard()
