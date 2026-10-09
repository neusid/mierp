import sys

file_path = r'd:\Project\Flutter\mierp\lib\features\dashboard\presentation\warehouse\dashboard_warehouse_view.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

lines = content.splitlines()

new_header = """              Container(
                width: 1.sw,
                height: 160.h,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF3B82F6),
                      Color(0xFF6D28D9),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(60.w),
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: -90.h,
                      right: -40.w,
                      child: Container(
                        width: 200.w,
                        height: 200.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.06),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 90.h,
                      left: -20.w,
                      child: Container(
                        width: 120.w,
                        height: 120.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.06),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 56.h,
                      left: 32.w,
                      right: 28.w,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 48.w,
                            height: 48.w,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFE9D5FF),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.person_rounded,
                                color: const Color(0xFF7C3AED),
                                size: 28.w,
                              ),
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Good Morning,",
                                  style: GoogleFonts.inter(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFFE0E7FF),
                                  ),
                                ),
                                Text(
                                  state.userName.isNotEmpty ? state.userName : "Admin",
                                  style: GoogleFonts.inter(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    letterSpacing: -0.5,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/notification');
                            },
                            child: Container(
                              width: 40.w,
                              height: 40.w,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12.w),
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Icon(
                                    Icons.notifications_none_rounded,
                                    color: Colors.white,
                                    size: 24.w,
                                  ),
                                  Positioned(
                                    top: 10.w,
                                    right: 10.w,
                                    child: Container(
                                      width: 8.w,
                                      height: 8.w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: const Color(0xFFEF4444),
                                        border: Border.all(
                                          color: const Color(0xFF4F46E5),
                                          width: 1.5.w,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),"""

lines = lines[:43] + [new_header] + lines[199:]

with open(file_path, 'w', encoding='utf-8') as f:
    f.write('\n'.join(lines))
