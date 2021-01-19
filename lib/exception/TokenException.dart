class TokenException implements Exception {
  String _message;

  TokenException(String message) {
    this._message = message;
  }

  @override
  String toString() {
    return _message;
  }
}