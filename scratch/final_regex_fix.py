import re

def rewrite():
    file_path = r'd:\Project\Flutter\mierp\lib\features\summary\presentation\summary_view.dart'
    with open(file_path, 'r', encoding='utf-8') as f:
        code = f.read()

    code = re.sub(r'summaryVM\.role\.value', 'state.role', code)
    code = re.sub(r'summaryVM\.role', 'state.role', code)
    code = re.sub(r'summaryVM\.keyword\.value', 'state.keyword', code)
    code = re.sub(r'summaryVM\.keyword', 'state.keyword', code)
    code = re.sub(r'summaryVM\.tag\.value', 'state.tag', code)
    code = re.sub(r'summaryVM\.tag', 'state.tag', code)
    code = re.sub(r'summaryVM\.collection\.value', 'state.selectedTab', code)
    code = re.sub(r'summaryVM\.collection', 'state.selectedTab', code)
    code = re.sub(r'summaryVM\.isLoading\.value', 'state.isLoading', code)
    code = re.sub(r'summaryVM\.isLoading', 'state.isLoading', code)
    code = re.sub(r'summaryVM\.options', 'options', code)
    code = re.sub(r'summaryVM\.searchKeyC', 'TextEditingController(text: state.keyword)', code)
    code = re.sub(r'summaryVM\.moveBack\(\)', 'Get.back()', code)
    code = re.sub(r'summaryVM\.filterData\((.*?)\)', r'context.read<SummaryBloc>().add(SummaryFilterChanged(\1))', code)
    code = re.sub(r'summaryVM\.detailProductOrder\((.*?)\);', r'Get.toNamed("/detail_product_order/\1");', code)
    code = re.sub(r'summaryVM\.detailSalesOrder\((.*?)\);', r'Get.toNamed("/detail_sales_order/\1");', code)
    
    # Fix the multiline requestPayInvoiceOrderProduct
    code = re.sub(
        r'summaryVM\s*\.\s*requestPayInvoiceOrderProduct\s*\((.*?),(.*?),(.*?)\)', 
        r'context.read<SummaryBloc>().add(SummaryPayRequested(\1, \2, \3))', 
        code, 
        flags=re.DOTALL
    )
    
    # Fix list accesses
    code = re.sub(r'summaryVM\.filteredSummaries', 'state.listSalesOrder', code)
    code = re.sub(r'summaryVM\.filteredOrders', 'state.listOrder', code)
    code = re.sub(r'summaryVM\.filteredProducts', 'state.listProduct', code)
    code = re.sub(r'summaryVM\.filteredSalesOrders', 'state.listSalesOrder', code)
    
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(code)

rewrite()
