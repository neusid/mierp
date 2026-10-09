import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';

class CustomMingdaDatePicker extends StatefulWidget {
  final DateTime initialDate;
  final String title;

  const CustomMingdaDatePicker({super.key, required this.initialDate, this.title = "PILIH TANGGAL"});

  @override
  _CustomMingdaDatePickerState createState() => _CustomMingdaDatePickerState();
}

class _CustomMingdaDatePickerState extends State<CustomMingdaDatePicker> {
  late DateTime _selectedDate;
  late DateTime _currentMonth;
  final Color _primaryColor = AppColors.vividPurple;

  final List<String> _dayNames = ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'];
  final List<String> _fullDayNames = ['Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];
  final List<String> _monthNames = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ];
  final List<String> _shortMonthNames = [
    'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
    'Jul', 'Ags', 'Sep', 'Okt', 'Nov', 'Des'
  ];

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _currentMonth = DateTime(widget.initialDate.year, widget.initialDate.month);
  }

  String _getFormattedDate(DateTime date) {
    // 0 = Monday in DateTime.weekday, 7 = Sunday.
    int weekdayIndex = date.weekday == 7 ? 0 : date.weekday;
    String dayName = _fullDayNames[weekdayIndex];
    String monthName = _shortMonthNames[date.month - 1];
    return '$dayName, ${date.day} $monthName ${date.year}';
  }

  void _changeMonth(int offset) {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + offset);
    });
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.w)),
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: GoogleFonts.inter(
                    color: _primaryColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 10.sp,
                    letterSpacing: 0.5,
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Icon(Icons.close, size: 16.w, color: Colors.grey.shade600),
                  ),
                )
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              _getFormattedDate(_selectedDate),
              style: GoogleFonts.inter(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16.h),
            // Quick select chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildQuickChip("Hari Ini", DateTime.now()),
                  SizedBox(width: 8.w),
                  _buildQuickChip("Kemarin", DateTime.now().subtract(const Duration(days: 1))),
                  SizedBox(width: 8.w),
                  _buildQuickChip("7 Hari Lalu", DateTime.now().subtract(const Duration(days: 7))),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            // Month Year Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      "${_monthNames[_currentMonth.month - 1]} ${_currentMonth.year}",
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(Icons.keyboard_arrow_down, size: 16.w, color: Colors.grey.shade600),
                  ],
                ),
                Row(
                  children: [
                    _buildMonthArrow(Icons.chevron_left, () => _changeMonth(-1)),
                    SizedBox(width: 8.w),
                    _buildMonthArrow(Icons.chevron_right, () => _changeMonth(1)),
                  ],
                )
              ],
            ),
            SizedBox(height: 16.h),
            // Calendar Grid
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _dayNames.map((day) => Container(
                width: 32.w,
                alignment: Alignment.center,
                child: Text(
                  day,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
              )).toList(),
            ),
            SizedBox(height: 12.h),
            _buildCalendarGrid(),
            SizedBox(height: 24.h),
            // Bottom Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade300),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.w)),
                    ),
                    child: Text(
                      "Batal",
                      style: GoogleFonts.inter(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: AppColors.premiumDarkGradient,
                      borderRadius: BorderRadius.circular(10.w),
                    ),
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, _selectedDate),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.w)),
                        elevation: 0,
                      ),
                      child: Text(
                        "Terapkan",
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildQuickChip(String label, DateTime targetDate) {
    bool isSelected = _isSameDate(_selectedDate, targetDate);
    return InkWell(
      onTap: () {
        _selectDate(targetDate);
        setState(() {
          _currentMonth = DateTime(targetDate.year, targetDate.month);
        });
      },
      borderRadius: BorderRadius.circular(20.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? null : Colors.white,
          gradient: isSelected ? AppColors.premiumDarkGradient : null,
          borderRadius: BorderRadius.circular(20.w),
          border: Border.all(color: isSelected ? Colors.transparent : Colors.grey.shade200),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            color: isSelected ? Colors.white : Colors.grey.shade600,
            fontSize: 12.sp,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildMonthArrow(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.w),
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _primaryColor.withValues(alpha: 0.05),
          border: Border.all(color: _primaryColor.withValues(alpha: 0.1)),
        ),
        child: Icon(icon, size: 20.w, color: _primaryColor),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    // Determine first day of month (1 = Mon, 7 = Sun)
    DateTime firstDay = DateTime(_currentMonth.year, _currentMonth.month, 1);
    int daysInMonth = DateUtils.getDaysInMonth(_currentMonth.year, _currentMonth.month);
    
    // We want Sunday to be index 0
    int firstDayOffset = firstDay.weekday == 7 ? 0 : firstDay.weekday;

    // Previous month info
    DateTime prevMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    int daysInPrevMonth = DateUtils.getDaysInMonth(prevMonth.year, prevMonth.month);

    List<Widget> gridItems = [];

    // Previous month days
    for (int i = 0; i < firstDayOffset; i++) {
      int day = daysInPrevMonth - firstDayOffset + i + 1;
      gridItems.add(_buildCalendarCell(day, isCurrentMonth: false));
    }

    // Current month days
    for (int i = 1; i <= daysInMonth; i++) {
      gridItems.add(_buildCalendarCell(i, isCurrentMonth: true));
    }

    // Next month days (fill rest of grid to 42 cells typically)
    int remainingCells = 42 - gridItems.length;
    for (int i = 1; i <= remainingCells; i++) {
      gridItems.add(_buildCalendarCell(i, isCurrentMonth: false));
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.0,
      mainAxisSpacing: 4.h,
      crossAxisSpacing: 4.w,
      children: gridItems,
    );
  }

  Widget _buildCalendarCell(int day, {required bool isCurrentMonth}) {
    DateTime cellDate = isCurrentMonth 
        ? DateTime(_currentMonth.year, _currentMonth.month, day)
        : (day > 15 
            ? DateTime(_currentMonth.year, _currentMonth.month - 1, day)
            : DateTime(_currentMonth.year, _currentMonth.month + 1, day));
            
    bool isSelected = _isSameDate(_selectedDate, cellDate);

    return InkWell(
      onTap: () {
        _selectDate(cellDate);
        if (!isCurrentMonth) {
          setState(() {
            _currentMonth = DateTime(cellDate.year, cellDate.month);
          });
        }
      },
      borderRadius: BorderRadius.circular(10.w),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? null : Colors.transparent,
          gradient: isSelected ? AppColors.premiumDarkGradient : null,
          borderRadius: BorderRadius.circular(10.w),
        ),
        child: Text(
          day.toString(),
          style: GoogleFonts.inter(
            fontSize: 13.sp,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected 
                ? Colors.white 
                : (isCurrentMonth ? Colors.black87 : Colors.grey.shade400),
          ),
        ),
      ),
    );
  }
}
