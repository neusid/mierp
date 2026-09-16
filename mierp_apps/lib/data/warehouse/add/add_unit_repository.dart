import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mierp_apps/core/models/product.dart';
import 'package:path/path.dart' as p;

class AddUnitRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addUnitToFirebase(collection, Product data) async {
    try {
      await firestore.collection(collection).add({
        "category": data.category,
        "created_on": data.createdOn,
        "image_product": data.imageProduct,
        "product_name": data.productName,
        "product_code": data.productCode,
        "quantity": data.quantity,
        "unit_price": data.unitPrice,
      });
    } catch (e) {
      Get.snackbar("Error add unit", "$e");
    }
  }

  Future<String?> uploadImageToCloudinary(XFile file) async {
    final String cloudName = "diettjfjg";
    final String apiKey = "992753549685141";
    final String apiSecret = "PRB-T14xL2EufKjkBnnOdKov6Nk";

    final uri = Uri.parse(
      "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
    );

    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$apiKey:$apiSecret'));

    try {
      var request = http.MultipartRequest("POST", uri);
      request.headers['Authorization'] = basicAuth;

      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      request.fields['public_id'] = p.basenameWithoutExtension(file.path);

      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        return jsonDecode(responseData)['secure_url'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
