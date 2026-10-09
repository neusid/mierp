import sys

file_path = r'd:\Project\Flutter\mierp\lib\features\dashboard\presentation\warehouse\dashboard_warehouse_view.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# The old gradient block can have varying indentation depending on where it is in the file.
# We will do a regex or just replace the inner contents.

import re

# Match the old gradient exactly, ignoring leading whitespace.
old_gradient_pattern = r'''gradient: LinearGradient\(\s*colors: \[\s*Color\(0xFF00B2FF\),\s*Color\(0xFF7A00E6\),\s*\],\s*transform: GradientRotation\([^)]+\),\s*\),'''
new_gradient = """gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [Color(0xFF3B82F6), Color(0xFF6D28D9)],
                                      ),"""

# We'll use regex to replace it but keep the indentation of the word 'gradient'
def replacer(match):
    indent = match.group(1)
    # The new gradient string uses 40 spaces for indentation on subsequent lines.
    # We will adjust it to use the matched indent + 2 spaces for the inner properties.
    replacement = f"""gradient: const LinearGradient(
{indent}  begin: Alignment.topLeft,
{indent}  end: Alignment.bottomRight,
{indent}  colors: [Color(0xFF3B82F6), Color(0xFF6D28D9)],
{indent}),"""
    return indent + replacement

# regex to capture leading spaces before "gradient:"
pattern = r'([ \t]*)gradient: LinearGradient\(\s*colors: \[\s*Color\(0xFF00B2FF\),\s*Color\(0xFF7A00E6\),\s*\],\s*transform: GradientRotation\([^)]+\),\s*\),'

new_content = re.sub(pattern, replacer, content)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(new_content)

print(f"Replaced {len(re.findall(pattern, content))} instances.")
