import re

def update_summary_view():
    file_path = r'd:\Project\Flutter\mierp\lib\features\summary\presentation\summary_view.dart'
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    target = """                                    child: TextFormField(
                                      controller: TextEditingController(
                                        text: state.keyword,
                                      ),"""

    replacement = """                                    child: TextFormField(
                                      initialValue: state.keyword,"""

    if target in content:
        content = content.replace(target, replacement)
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(content)
        print("Updated summary_view.dart")
    else:
        print("Target not found.")

update_summary_view()
