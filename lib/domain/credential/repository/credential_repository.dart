
import 'package:mierp_apps/core/models/credential_model.dart';

abstract class CredentialRepository {

  Future<void> setDataUser(String dataUserRaw);
  Future<void> setCredentialUser(String email, bool isSave);
  Future<Credential> loadCredentialUser();
  Future<void> deletePreference();
}