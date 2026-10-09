import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:mierp_apps/features/dashboard/presentation/warehouse/dashboard_warehouse_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mierp_apps/features/main_page/presentation/cubit/main_page_cubit.dart';
import 'package:mierp_apps/features/profile/presentation/profile_view.dart';
import 'package:mierp_apps/core/widgets/coming_soon_view.dart';

class WarehouseMainPageView extends StatelessWidget {
  const WarehouseMainPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: BlocBuilder<MainPageCubit, int>(
        builder: (context, currentIndex) {
          return IndexedStack(
            index: currentIndex,
            children: [
              DashboardWarehouseView(),
              ComingSoonView(title: "Search Segera Hadir", onHomePressed: () => context.read<MainPageCubit>().goToDashboard()),
              ComingSoonView(title: "Graph Segera Hadir", onHomePressed: () => context.read<MainPageCubit>().goToDashboard()),
              ComingSoonView(title: "Clock Segera Hadir", onHomePressed: () => context.read<MainPageCubit>().goToDashboard()),
              ProfileView(onBack: () => context.read<MainPageCubit>().goToDashboard()),
            ],
          );
        }
      ),
      bottomNavigationBar: BlocBuilder<MainPageCubit, int>(
        builder: (context, currentIndex) {
          return BottomAppBar(
            height: 70.w,
            padding: EdgeInsetsGeometry.only(
                left: 16.w, right: 16.w, top: 12.w, bottom: 6.w),
            color: Colors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavItem(context, "assets/icons/home-2.svg", "Home", 0, currentIndex),
                _buildNavItem(context, "assets/icons/search-normal.svg", "Search", 1, currentIndex),
                _buildNavItem(context, "assets/icons/graph.svg", "Graph", 2, currentIndex),
                _buildNavItem(context, "assets/icons/clock.svg", "Clock", 3, currentIndex),
                _buildNavItem(context, "assets/icons/user.svg", "User", 4, currentIndex),
              ],
            ),
          );
        }
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String iconPath, String label, int index, int currentIndex) {
    bool isActive = index == currentIndex;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20.w),
        onTap: () {
          context.read<MainPageCubit>().changeIndex(index);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          width: isActive ? 105.w : 50.w,
          height: 40.w,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.w),
          decoration: isActive
              ? BoxDecoration(
                  gradient: AppColors.premiumDarkGradient,
                  borderRadius: BorderRadius.circular(100.w))
              : null,
          child: Row(
            spacing: 6.w,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                iconPath,
                width: isActive ? 20.02.w : 24.w,
                height: isActive ? 20.h : 24.h,
                colorFilter: ColorFilter.mode(
                    isActive ? Colors.white : AppColors.grayTitle, BlendMode.srcIn),
              ),
              if (isActive)
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        height: 16 / 12,
                        fontWeight: AppFontWeight.medium,
                        color: Colors.white),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}



