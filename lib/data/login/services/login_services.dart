
import 'package:get/get.dart';
import 'package:mierp_apps/data/login/login_repository.dart';
import 'package:mierp_apps/domain/credential/repository/credential_repository.dart';

class LoginServices extends GetxService {

  final CredentialRepository credentialRepository;
  final LoginRepository loginRepository;

  LoginServices({required this.credentialRepository, required this.loginRepository});


}