// Dilempar oleh layer Data saat HTTP call mengembalikan error 500+
class ServerException implements Exception {
  final String message;
  ServerException({this.message = 'Terjadi kesalahan pada server'});
}

// Dilempar saat validasi form atau input ditolak oleh API (400, 401, 422, dsb)
class ValidationException implements Exception {
  final String message;
  ValidationException({this.message = 'Terjadi kesalahan validasi'});
}

// Dilempar saat tidak ada koneksi internet
class NetworkException implements Exception {
  final String message;
  NetworkException({this.message = 'Koneksi internet terputus'});
}

// Dilempar saat cache lokal gagal diakses
class CacheException implements Exception {}
