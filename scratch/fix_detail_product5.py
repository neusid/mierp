fp = r"d:\Project\Flutter\mierp\lib\features\detail\presentation\detail_product\detail_product_view.dart"
with open(fp, "r", encoding="utf-8") as f: code = f.read()

if not code.endswith("}\n}") and not code.strip().endswith("}"):
    code += "\n  }\n}\n"

with open(fp, "w", encoding="utf-8") as f: f.write(code)
