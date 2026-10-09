import re

file_path = 'lib/features/summary/presentation/summary_view.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    code = f.read()

pattern = re.compile(
    r'Center\(\s*child:\s*Column\(\s*mainAxisAlignment:\s*MainAxisAlignment\.center,\s*children:\s*\[\s*Lottie\.asset\(\s*"assets/lottie/empty_ghost\.json"[\s\S]*?\]\s*,\s*\)\s*,\s*\)',
    re.DOTALL
)

matches = pattern.findall(code)
print(f"Found {len(matches)} matches")

new_code = pattern.sub('_buildEmptyState()', code)

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
              "The data you're looking for isn't available yet.",
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
}'''

new_code = new_code.rstrip().replace('}\n\n}', '}')
if new_code.endswith('}'):
    new_code = new_code[:-1] + method

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(new_code)
