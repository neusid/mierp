def find_mismatch(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        text = f.read()

    stack = []
    pairs = {')': '(', ']': '[', '}': '{'}
    
    line_num = 1
    col_num = 1
    
    in_string = False
    string_char = ''
    in_comment = False
    in_multiline_comment = False
    
    i = 0
    while i < len(text):
        c = text[i]
        
        if c == '\n':
            line_num += 1
            col_num = 1
            if in_comment:
                in_comment = False
            i += 1
            continue
            
        if not in_string and not in_comment and not in_multiline_comment:
            if c == '/' and i + 1 < len(text) and text[i+1] == '/':
                in_comment = True
                i += 2
                col_num += 2
                continue
            if c == '/' and i + 1 < len(text) and text[i+1] == '*':
                in_multiline_comment = True
                i += 2
                col_num += 2
                continue
            if c in '"\'':
                in_string = True
                string_char = c
            elif c in '([{':
                stack.append((c, line_num, col_num))
            elif c in ')]}':
                if not stack:
                    print(f"Unmatched closing {c} at line {line_num}, col {col_num}")
                    return
                top, t_line, t_col = stack.pop()
                if top != pairs[c]:
                    print(f"Mismatch: found {c} at line {line_num}, col {col_num}, but expected closing for {top} from line {t_line}, col {t_col}")
                    return
        elif in_string:
            if c == '\\':
                i += 2
                col_num += 2
                continue
            if c == string_char:
                in_string = False
        elif in_multiline_comment:
            if c == '*' and i + 1 < len(text) and text[i+1] == '/':
                in_multiline_comment = False
                i += 2
                col_num += 2
                continue
                
        i += 1
        col_num += 1

    if stack:
        print("Unclosed brackets:")
        for bracket, line, col in stack:
            print(f"  {bracket} at line {line}, col {col}")
    else:
        print("All matched!")

find_mismatch(r'd:\Project\Flutter\mierp\lib\features\summary\presentation\summary_view.dart')
