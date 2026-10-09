import json
import re

transcript_path = r'C:\Users\oksar\.gemini\antigravity-ide\brain\99daa9c9-2cfa-46e3-b827-7227919008d8\.system_generated\logs\transcript_full.jsonl'
target_file = 'dashboard_warehouse_view.dart'

best_lines = []
highest_line_num = 0

with open(transcript_path, 'r', encoding='utf-8') as f:
    for line in f:
        try:
            data = json.loads(line)
            if data.get('type') == 'TOOL_RESPONSE':
                content = data.get('content', '')
                if target_file in content and "Showing lines" in content:
                    # Extract the viewed lines
                    lines_match = re.search(r'Showing lines (\d+) to (\d+)', content)
                    if lines_match:
                        start_line = int(lines_match.group(1))
                        end_line = int(lines_match.group(2))
                        
                        # We want to find the largest chunk that starts at 1, or just collect all viewed blocks
                        # Wait, we can parse the line numbers in the output!
                        # The output is like:
                        # 1: import 'package:flutter/material.dart';
                        # 2: ...
                        code_lines = {}
                        for c_line in content.splitlines():
                            match = re.match(r'^(\d+): (.*)$', c_line)
                            if match:
                                line_num = int(match.group(1))
                                line_content = match.group(2)
                                code_lines[line_num] = line_content
                        
                        if code_lines:
                            max_k = max(code_lines.keys())
                            if max_k > highest_line_num:
                                highest_line_num = max_k
                            
                            # Just print if we found a good chunk
                            if start_line == 1 and max_k > 800:
                                print(f"Found large chunk! Lines {start_line} to {max_k}")
        except:
            pass

print(f"Highest line number seen: {highest_line_num}")
