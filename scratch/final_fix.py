import re

def rewrite():
    file_path = r'd:\Project\Flutter\mierp\lib\features\summary\presentation\summary_view.dart'
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    content = content.replace('package:mierp_apps/', 'package:mierp/')
    content = content.replace('summaryVM.', 'state.')
    content = content.replace('getx.Get', 'Get')
    content = content.replace('state.role.value', 'state.role')
    content = content.replace('state.collection.value', 'state.selectedTab')
    content = content.replace('state.tag.value', 'state.tag')
    content = content.replace('state.keyword.value', 'state.keyword')
    content = content.replace('state.options.value', 'state.options')
    content = content.replace('state.filterData', 'context.read<SummaryBloc>().add(SummaryFilterChanged)')
    content = content.replace('state.detailProductOrder(', 'Get.toNamed("/detail_product_order/" + ')
    content = content.replace('state.detailSalesOrder(', 'Get.toNamed("/detail_sales_order/" + ')
    content = content.replace('import \'package:get/get.dart\' as getx;', 'import \'package:get/get.dart\';')
    
    # We must remove Obx
    content = re.sub(r'Obx\(\(\)\s*\{', r'Builder(builder: (context) {', content)
    content = re.sub(r'Obx\(\s*\(\)\s*=>\s*', r'', content)
    
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)
        
rewrite()
