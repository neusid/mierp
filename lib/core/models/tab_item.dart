import 'package:get/get.dart';

class TabItem {
  TabItem(this.title, this.isActive, this.collection);
  final String title;
  RxBool isActive = false.obs;
  final String collection;
}