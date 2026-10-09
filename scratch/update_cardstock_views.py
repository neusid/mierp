import re

def update_views(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # We want to replace `image: <something>,` with `image: <something>,\n                                                    createdOn: <something>.createdOn,`
    
    # 1. `e!.data.imageProduct`
    content = content.replace(
        "image: e!.data.imageProduct,",
        "image: e!.data.imageProduct,\n                                                    createdOn: e!.data.createdOn,"
    )
    
    # 2. `product!.imageProduct`
    content = content.replace(
        "image: product!.imageProduct,",
        "image: product!.imageProduct,\n                                                    createdOn: product!.createdOn,"
    )

    # 3. `data!.imageProduct`
    content = content.replace(
        "image: data!.imageProduct,",
        "image: data!.imageProduct,\n                                                createdOn: data!.createdOn,"
    )

    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)

update_views(r'd:\Project\Flutter\mierp\lib\features\dashboard\presentation\warehouse\dashboard_warehouse_view.dart')
update_views(r'd:\Project\Flutter\mierp\lib\features\summary\presentation\summary_view.dart')

print("Views updated with createdOn.")
