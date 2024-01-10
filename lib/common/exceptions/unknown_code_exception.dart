class UnknownCodeException implements Exception {

  const UnknownCodeException({required this.code});

  final int? code;
}