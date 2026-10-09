import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/widgets/card_order.dart';
import 'package:mierp_apps/core/widgets/card_stock.dart';
import 'package:mierp_apps/features/inventory_alerts/presentation/bloc/inventory_alerts_bloc.dart';
import 'package:go_router/go_router.dart';

class InventoryAlertsView extends StatefulWidget {
  final int initialTabIndex;
  const InventoryAlertsView({super.key, this.initialTabIndex = 0});

  @override
  State<InventoryAlertsView> createState() => _InventoryAlertsViewState();
}

class _InventoryAlertsViewState extends State<InventoryAlertsView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
    context.read<InventoryAlertsBloc>().add(InventoryAlertsFetchRequested());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softWhite,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.charcoal),
          onPressed: () => context.pop(),
        ),
        title: Text(
          "Inventory Alerts",
          style: GoogleFonts.inter(
            color: AppColors.charcoal,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.blueLine,
          unselectedLabelColor: AppColors.coolGray,
          indicatorColor: AppColors.blueLine,
          indicatorWeight: 3,
          labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14.sp),
          unselectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 14.sp),
          tabs: const [
            Tab(text: "Low Stock"),
            Tab(text: "Incoming Stock"),
          ],
        ),
      ),
      body: BlocBuilder<InventoryAlertsBloc, InventoryAlertsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return Center(
              child: Text(
                state.error!,
                style: GoogleFonts.inter(color: Colors.red),
              ),
            );
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildLowStock(state),
              _buildIncomingStock(state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLowStock(InventoryAlertsState state) {
    if (state.lowStockProducts.isEmpty) {
      return Center(
        child: Text(
          "No Low Stock Alerts",
          style: GoogleFonts.inter(
            color: AppColors.coolGray,
            fontSize: 14.sp,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(24.w),
      itemCount: state.lowStockProducts.length,
      itemBuilder: (context, index) {
        final data = state.lowStockProducts[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 12.w),
          child: GestureDetector(
            onTap: () {
              context.push('/detail_product/${data.id}');
            },
            child: CardStock(
              idBarang: data.productCode,
              namaBarang: data.productName,
              quantity: data.quantity,
              unitPrice: data.unitPrice,
              lineTotal: data.quantity * data.unitPrice,
              type: data.category,
              image: data.imageProduct,
              createdOn: data.createdOn,
            ),
          ),
        );
      },
    );
  }

  Widget _buildIncomingStock(InventoryAlertsState state) {
    if (state.incomingStockProducts.isEmpty) {
      return Center(
        child: Text(
          "No Incoming Stock",
          style: GoogleFonts.inter(
            color: AppColors.coolGray,
            fontSize: 14.sp,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(24.w),
      itemCount: state.incomingStockProducts.length,
      itemBuilder: (context, index) {
        final data = state.incomingStockProducts[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 12.w),
          child: GestureDetector(
            onTap: () {
              context.push("/detail_product_order/${data.id}");
            },
            child: CardOrder(
              idOrder: data.id ?? '',
              idBarang: data.productId,
              namaBarang: data.productName,
              financeApproved: data.financeApproved,
              createdOn: data.orderDate,
              nameUser: data.firstName,
              quantity: data.quantity,
              unitPrice: data.unitPrice,
              lineTotal: data.totalCost,
              imageProduct: data.imageProduct,
              finance: false, 
              onPayPressed: () {}, 
            ),
          ),
        );
      },
    );
  }
}
