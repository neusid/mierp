import re

def fix_summary_view():
    path = r'D:\Project\Flutter\mierp\lib\features\summary\presentation\summary_view.dart'
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Replace spacing: 5, with spacing: 4.h,
    content = re.sub(r'spacing:\s*5,', r'spacing: 4.h,', content)
    # Replace spacing: 5.w, with spacing: 4.h,
    content = re.sub(r'spacing:\s*5\.w,', r'spacing: 4.h,', content)

    with open(path, 'w', encoding='utf-8') as f:
        f.write(content)

def fix_dashboard():
    path = r'D:\Project\Flutter\mierp\lib\features\dashboard\presentation\warehouse\dashboard_warehouse_view.dart'
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()

    # We want to replace spacing: 10.w, that are in the summary lists. 
    # Not the one at 336: spacing: 16.h,
    # The summary lists are under state.selectedTab.
    # Lines 534, 622, 660, 693.
    # Let's replace spacing: 10.w, with spacing: 4.h, globally but carefully.
    
    # Wait, spacing: 10.w, is only used in those lists in dashboard
    content = re.sub(r'spacing:\s*10\.w,', r'spacing: 4.h,', content)

    with open(path, 'w', encoding='utf-8') as f:
        f.write(content)

fix_summary_view()
fix_dashboard()
print("Spacing updated successfully.")
