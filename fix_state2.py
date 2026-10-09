import re
file_path = 'lib/features/summary/presentation/summary_view.dart'
with open(file_path, 'r', encoding='utf-8') as f: code = f.read()

# Replace multiline state.filterData
code = re.sub(
    r'state\s*\.\s*filterData\s*\(\s*value,\s*\)',
    r'context.read<SummaryBloc>().add(SummaryFilterChanged(value))',
    code,
    flags=re.DOTALL
)

# Replace multiline state.options.value
code = re.sub(
    r'state\s*\.\s*options\s*\.\s*value',
    r'options',
    code,
    flags=re.DOTALL
)
code = re.sub(
    r'state\s*\.\s*options',
    r'options',
    code,
    flags=re.DOTALL
)

# Replace multiline data.title
code = re.sub(r'data!\.title', r'data["name"] ?? ""', code)
code = re.sub(r'data\s*\.\s*title', r'data["name"] ?? ""', code)

# Replace multiline data.isActive.value
# Actually, the logic was state.selectedTab == data["value"]
code = re.sub(
    r'!\s*data\s*\.\s*isActive\s*\.\s*value',
    r'state.selectedTab != data["value"]',
    code,
    flags=re.DOTALL
)
code = re.sub(
    r'data\s*\.\s*isActive\s*\.\s*value',
    r'state.selectedTab == data["value"]',
    code,
    flags=re.DOTALL
)

# Replace SummaryTabChanged(data) -> SummaryTabChanged(data[\"value\"]!)
code = re.sub(
    r'SummaryTabChanged\s*\(\s*data\s*\)',
    r'SummaryTabChanged(data["value"]!)',
    code,
    flags=re.DOTALL
)

# Replace multiline state.detailProductOrder
code = re.sub(
    r'state\s*\.\s*detailProductOrder\s*\(\s*(.*?)\s*\)',
    r'Get.toNamed("/detail_product_order/" + str(\1))',
    code,
    flags=re.DOTALL
)

with open(file_path, 'w', encoding='utf-8') as f: f.write(code)
