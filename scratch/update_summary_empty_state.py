import re

file_path = 'lib/features/summary/presentation/summary_view.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    code = f.read()

# Pattern to match the existing empty states:
# child: Column(
#   mainAxisAlignment: MainAxisAlignment.center,
#   children: [
#     Lottie.asset("assets/lottie/empty_ghost.json", width: 292.w,),
#     Container(width: 250.w, child: Column(..., children: [ Text("TITLE"), Text("DESC") ] ))
pattern = re.compile(
    r'''child:\s*Column\(\s*mainAxisAlignment:\s*MainAxisAlignment\.center,\s*children:\s*\[\s*Lottie\.asset\(\s*["']assets/lottie/empty_ghost\.json["'],\s*width:\s*292\.w,?\s*\),\s*Container\(\s*width:\s*250\.w,?\s*child:\s*Column\(\s*crossAxisAlignment:\s*CrossAxisAlignment\.center,\s*spacing:\s*10\.w,?\s*children:\s*\[\s*Text\(\s*["']([^"']+)["'][^\)]*\),\s*Text\(\s*["']([^"']+)["'][^\)]*\),\s*\],\s*\),\s*\),\s*\]\s*,\s*\)''',
    re.DOTALL
)

def replacer(match):
    title = match.group(1)
    desc = match.group(2)
    return f"child: _buildEmptyState(\"{title}\", \"{desc}\")"

new_code = pattern.sub(replacer, code)

# Inject the _buildEmptyState method at the end of the class
method = '''

  Widget _buildEmptyState(String title, String message) {
    return Column(
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
          title,
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
            message,
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
    );
  }
}
'''

new_code = new_code.rstrip().replace('}\n\n}', '}')
if new_code.endswith('}'):
    new_code = new_code[:-1] + method

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(new_code)

print("Updated summary_view.dart")
