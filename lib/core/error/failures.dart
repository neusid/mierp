import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

// Terjadi error di level server (misal 500)
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

// Terjadi error saat tidak ada koneksi internet
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

// Khusus untuk error validasi UI / OTP (misal 400, 401, 404, 422)
// Tidak boleh memicu layar Galat Fatal 500
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

// Khusus jika data cache lokal gagal dimuat
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}
