
import 'package:mierp_apps/data/login/login_repository.dart';
import 'package:mierp_apps/domain/credential/repository/credential_repository.dart';

class LoginServices {

  final CredentialRepository credentialRepository;
  final LoginRepository loginRepository;

  LoginServices({required this.credentialRepository, required this.loginRepository});


}