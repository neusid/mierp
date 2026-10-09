import re

def rewrite():
    file_path = r'd:\Project\Flutter\mierp\lib\features\summary\presentation\summary_view.dart'
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    content = content.replace('package:mierp/', 'package:mierp_apps/')
    
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)
        
rewrite()
