
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mierp_apps/core/models/credential_model.dart';
import 'package:mierp_apps/domain/credential/repository/credential_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CredentialRepositoryImpl implements CredentialRepository {

  FlutterSecureStorage flutterSecureStorage = FlutterSecureStorage();

  @override
  Future<void> setDataUser(String dataUserRaw) async {
    final sharedPreferences = await SharedPreferences.getInstance();

    await sharedPreferences.setString('user', dataUserRaw);
  }

  @override
  Future<void> setCredentialUser(String email, bool isSave) async {
    final sharedPreferences = await SharedPreferences.getInstance();

    await flutterSecureStorage.write(key: 'email', value: email);
    await sharedPreferences.setBool('isSave', isSave);
  }

  @override
  Future<Credential> loadCredentialUser() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    final email = await flutterSecureStorage.read(key: 'email');
    final save = await sharedPreferences.getBool('isSave') ?? false;
    final json = {
      'email':email,
      'isSave':save
    };

    return Credential.fromJson(json);
  }

  @override
  Future<void> deletePreference() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await flutterSecureStorage.delete(key: 'email');
    await sharedPreferences.setBool('isSave', false);
  }
}