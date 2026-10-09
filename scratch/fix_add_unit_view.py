import re

view_path = r"d:\Project\Flutter\mierp\lib\features\add\presentation\add_unit\add_unit_view.dart"
with open(view_path, 'r', encoding='utf-8') as f:
    view_code = f.read()

# Fix remaining addUnitVM
view_code = view_code.replace("addUnitVM.showDate(context)", "showDate(context)")
view_code = view_code.replace("addUnitVM.resetControllerInput()", "_resetForm()")
view_code = re.sub(r"addUnitVM\.[\s\S]*?isLoading\.value", "state.status == AddUnitStatus.loading", view_code)

# Check if there is any other addUnitVM
view_code = re.sub(r"addUnitVM\.", "", view_code)


with open(view_path, 'w', encoding='utf-8') as f:
    f.write(view_code)

print("Fixed addUnitVM references")
