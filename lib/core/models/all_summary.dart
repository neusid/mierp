import 'package:mierp_apps/core/models/summary_type.dart';

class AllSummary {
  final SummaryType summaryType;
  final dynamic data;
  final String createdOn;

  AllSummary({required this.summaryType, required this.data, required this.createdOn});
}