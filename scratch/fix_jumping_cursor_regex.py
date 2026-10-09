import re

def update_summary_view():
    file_path = r'd:\Project\Flutter\mierp\lib\features\summary\presentation\summary_view.dart'
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # The block is:
    # controller: TextEditingController(
    #   text: state.keyword,
    # ),
    
    # Let's replace it with regex
    content = re.sub(
        r'controller:\s*TextEditingController\(\s*text:\s*state\.keyword,\s*\),',
        r'initialValue: state.keyword,',
        content
    )

    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)
    print("Updated summary_view.dart")

update_summary_view()
