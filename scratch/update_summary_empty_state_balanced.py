import re

file_path = 'lib/features/summary/presentation/summary_view.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    code = f.read()

# We need to replace the Center widget that contains 'assets/lottie/empty_ghost.json'
# Since we have 4 occurrences, we'll find them one by one.

def find_balanced_parenthesis(text, start_index):
    count = 0
    for i in range(start_index, len(text)):
        if text[i] == '(':
            count += 1
        elif text[i] == ')':
            count -= 1
            if count == 0:
                return i
    return -1

for _ in range(4):
    lottie_idx = code.find('assets/lottie/empty_ghost.json')
    if lottie_idx == -1:
        break
    
    # Search backwards for the nearest 'Center(' before the lottie
    center_idx = code.rfind('Center(', 0, lottie_idx)
    if center_idx == -1:
        print("Could not find Center( for lottie")
        break
        
    end_idx = find_balanced_parenthesis(code, center_idx + 6)
    if end_idx == -1:
        print("Could not find matching ) for Center(")
        break
        
    # Replace that slice with _buildEmptyState()
    code = code[:center_idx] + '_buildEmptyState()' + code[end_idx+1:]


method = '''

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // If you want to use the JPG version, comment the SvgPicture below and uncomment this Image widget:
          // Image.asset(
          //   'assets/images/folder_empty.jpg',
          //   width: 220.w,
          //   fit: BoxFit.contain,
          // ),
          SvgPicture.asset(
            'assets/images/folder_empty.svg',
            width: 220.w,
          ),
          SizedBox(height: 24.h),
          Text(
            "Oops! No Data Available",
            style: GoogleFonts.inter(
              fontSize: 22.sp,
              fontWeight: AppFontWeight.bold,
              color: const Color(0xFF0F172A),
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Text(
              "The data you\\'re looking for isn\\'t available yet.",
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: AppFontWeight.medium,
                color: const Color(0xFF64748B),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 60.h),
        ],
      ),
    );
  }
}
'''

code = code.rstrip().replace('}\n\n}', '}')
if code.endswith('}'):
    code = code[:-1] + method

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(code)

print("Updated summary_view.dart using balanced parenthesis!")
