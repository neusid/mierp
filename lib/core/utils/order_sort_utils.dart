import 'package:mierp_apps/core/models/all_summary.dart';
import 'package:mierp_apps/core/models/order.dart';
import 'package:mierp_apps/core/models/sales_order.dart';
import 'package:mierp_apps/core/models/summary_type.dart';

class OrderSortUtils {
  /// Robust flexible date parser supporting ISO-8601, 'YYYY-MM-DD', 'DD-MM-YYYY', etc.
  static DateTime? parseDateFlexible(String? dateStr) {
    if (dateStr == null || dateStr.trim().isEmpty) return null;
    final str = dateStr.trim();
    final parsed = DateTime.tryParse(str);
    if (parsed != null) return parsed;

    final parts = str.split('-');
    if (parts.length == 3) {
      if (parts[0].length == 4) {
        // YYYY-MM-DD
        final y = int.tryParse(parts[0]);
        final m = int.tryParse(parts[1]);
        final d = int.tryParse(parts[2]);
        if (y != null && m != null && d != null) return DateTime(y, m, d);
      } else {
        // DD-MM-YYYY
        final d = int.tryParse(parts[0]);
        final m = int.tryParse(parts[1]);
        final y = int.tryParse(parts[2]);
        if (y != null && m != null && d != null) return DateTime(y, m, d);
      }
    }
    return null;
  }

  /// Compares two date strings in descending order (newest first).
  static int compareDatesDesc(String? aStr, String? bStr) {
    final dateA = parseDateFlexible(aStr);
    final dateB = parseDateFlexible(bStr);
    if (dateA != null && dateB != null) {
      return dateB.compareTo(dateA);
    }
    if (dateA != null) return -1;
    if (dateB != null) return 1;
    return (bStr ?? '').compareTo(aStr ?? '');
  }

  /// Sorts OrderProduct: Unpaid (Pay Now) items first, then secondary sort by date descending.
  static int compareOrders(OrderProduct a, OrderProduct b) {
    final aUnpaid = !(a.financeApproved ?? false);
    final bUnpaid = !(b.financeApproved ?? false);
    if (aUnpaid != bUnpaid) {
      return aUnpaid ? -1 : 1; // Unpaid comes first
    }
    return compareDatesDesc(a.orderDate, b.orderDate);
  }

  /// Sorts SalesOrder: Unpaid (Pay Now) items first, then secondary sort by date descending.
  static int compareSalesOrders(SalesOrder a, SalesOrder b) {
    final aUnpaid = !(a.financeApproved ?? false);
    final bUnpaid = !(b.financeApproved ?? false);
    if (aUnpaid != bUnpaid) {
      return aUnpaid ? -1 : 1; // Unpaid comes first
    }
    return compareDatesDesc(a.purchasedDate, b.purchasedDate);
  }

  /// Checks if an AllSummary item requires payment action (Pay Now).
  static bool isPayNowSummary(AllSummary item) {
    if (item.summaryType == SummaryType.order) {
      if (item.data is OrderProduct) {
        return !((item.data as OrderProduct).financeApproved ?? false);
      }
      try {
        return !(item.data.financeApproved ?? false);
      } catch (_) {}
    } else if (item.summaryType == SummaryType.salesOrder) {
      if (item.data is SalesOrder) {
        return !((item.data as SalesOrder).financeApproved ?? false);
      }
      try {
        return !(item.data.financeApproved ?? false);
      } catch (_) {}
    }
    return false;
  }

  /// Sorts AllSummary: Unpaid (Pay Now) items first, then secondary sort by date descending.
  static int compareSummaries(AllSummary a, AllSummary b) {
    final aUnpaid = isPayNowSummary(a);
    final bUnpaid = isPayNowSummary(b);
    if (aUnpaid != bUnpaid) {
      return aUnpaid ? -1 : 1; // Unpaid comes first
    }
    return compareDatesDesc(a.createdOn, b.createdOn);
  }
}
