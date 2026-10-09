import re

def update_views(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Update CardOrder
    # Find idOrder: e.data!.id, or similar and ensure discount fields are passed
    content = re.sub(
        r'(child:\s*CardOrder\([\s\S]*?)idOrder:',
        r'\1discountPercent: e.data!.discountPercent,\n                                                  discountMax: e.data!.discountMax,\n                                                  idOrder:',
        content
    )
    # The above regex might match multiple times or incorrectly if e.data! is not used. Let's be safer.
    # Actually, both views use `e.data!.id` or `e.data.id`.

    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)
        
# A more precise script for dashboard
def update_dashboard():
    file_path = r'd:\Project\Flutter\mierp\lib\features\dashboard\presentation\warehouse\dashboard_warehouse_view.dart'
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # For CardOrder
    content = re.sub(r'(child:\s*CardOrder\([^)]*?idOrder:\s*e\.data!\.id,)', r'\1\n                                                  discountPercent: e.data!.discountPercent,\n                                                  discountMax: e.data!.discountMax,', content)
    
    # For CardSales
    content = re.sub(r'(child:\s*CardSales\([^)]*?idBarang:\s*e\.data!\.productCode,)', r'\1\n                                                  discountPercent: e.data!.discountPercent,\n                                                  discountMax: e.data!.discountMax,', content)
    
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)

# A more precise script for summary
def update_summary():
    file_path = r'd:\Project\Flutter\mierp\lib\features\summary\presentation\summary_view.dart'
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # For CardOrder in All Summary
    content = re.sub(r'(child:\s*CardOrder\([^)]*?idOrder:\s*data\.data\.id,)', r'\1\n                                                  discountPercent: data.data.discountPercent,\n                                                  discountMax: data.data.discountMax,', content)
    # For CardOrder in Orders Tab
    content = re.sub(r'(child:\s*CardOrder\([^)]*?idOrder:\s*data\.id,)', r'\1\n                                            discountPercent: data.discountPercent,\n                                            discountMax: data.discountMax,', content)
    
    # For CardSales in All Summary
    content = re.sub(r'(child:\s*CardSales\([^)]*?idBarang:\s*data\.data\.productCode,)', r'\1\n                                                  discountPercent: data.data.discountPercent,\n                                                  discountMax: data.data.discountMax,', content)
    # For CardSales in Sales Orders Tab
    content = re.sub(r'(child:\s*CardSales\([^)]*?idBarang:\s*data\.productCode,)', r'\1\n                                            discountPercent: data.discountPercent,\n                                            discountMax: data.discountMax,', content)
    
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)

update_dashboard()
update_summary()
print("Views updated.")
