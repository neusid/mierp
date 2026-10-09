import re

files = [
    r"d:\Project\Flutter\mierp\lib\features\main_page\warehouse\warehouse_main_page_view.dart",
    r"d:\Project\Flutter\mierp\lib\features\main_page\finance\finance_main_page_view.dart"
]

for file_path in files:
    with open(file_path, 'r', encoding='utf-8') as f:
        code = f.read()

    # Replace `controller.currentIndex.value = 0;` with `context.read<MainPageCubit>().changeIndex(0);`
    # (actually for search it's index 1, scan index 2, profile index 3)
    # Let me just replace the exact matches
    code = code.replace("controller.currentIndex.value = 0;", "context.read<MainPageCubit>().changeIndex(0);")
    code = code.replace("controller.currentIndex.value = 1;", "context.read<MainPageCubit>().changeIndex(1);")
    code = code.replace("controller.currentIndex.value = 2;", "context.read<MainPageCubit>().changeIndex(2);")
    code = code.replace("controller.currentIndex.value = 3;", "context.read<MainPageCubit>().changeIndex(3);")

    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(code)

print("Main page views fixed")
