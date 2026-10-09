import re

def rewrite_bottom_sheet():
    file_path = r'd:\Project\Flutter\mierp\lib\features\summary\presentation\summary_view.dart'
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # The block we want to replace starts at:
    # onTap: state.selectedTab != "products" && state.selectedTab != "all_summary" ? () => showBarModalBottomSheet(
    # and ends after the `return Container(...);` and `},`

    # Instead of brittle string matching, we can do a regex that captures everything from `onTap:` down to the closing parenthesis of `showBarModalBottomSheet`.
    # Let's find the exact string to replace.
    
    start_str = """                                          onTap:
                                              state.selectedTab != "products" &&
                                                  state.selectedTab !=
                                                      "all_summary"
                                              ? () => showBarModalBottomSheet("""
    
    # We will just write a custom script to find this block and replace it.
    idx_start = content.find('onTap:')
    # wait, there are multiple onTap. Let's find the one for filter.
    idx_filter = content.find('"assets/icons/filter.svg"')
    idx_ontap = content.find('onTap:', idx_filter)
    
    # We need to extract the entire onTap block.
    # We will balance the parentheses and braces.
    
    pass

