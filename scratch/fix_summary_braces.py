import re

fp = r"d:\Project\Flutter\mierp\lib\features\summary\presentation\summary_view.dart"
with open(fp, "r", encoding="utf-8") as f: code = f.read()

old_str = """        ],
      );
    },
    ),
    );
  }
}"""
new_str = """        ],
      ),
      );
    },
    ),
    );
  }
}"""
code = code.replace(old_str, new_str)

with open(fp, "w", encoding="utf-8") as f: f.write(code)

print("Summary view braces fixed!")
