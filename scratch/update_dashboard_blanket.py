import re

def update_dashboard():
    file_path = r'd:\Project\Flutter\mierp\lib\features\dashboard\presentation\warehouse\dashboard_warehouse_view.dart'
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Find the pattern for Low Stock map
    content = re.sub(
        r'("badge": "\$\{e\.quantity\} Left",\s*)',
        r'\g<1>"image": e.imageProduct ?? "",\n                                      ',
        content
    )

    # Find the pattern for Incoming Stock map
    content = re.sub(
        r'("badge": "\$\{e\.quantity\} Units",\s*)',
        r'\g<1>"image": e.imageProduct ?? "",\n                                      ',
        content
    )

    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)

update_dashboard()
print("Updated dashboard with image maps.")
