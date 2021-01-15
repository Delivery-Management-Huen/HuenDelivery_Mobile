class UnexpectedResult implements Exception {
  String _message;

  UnexpectedResult(String message) {
    this._message = message;
  }

  @override
  String toString() {
    return _message;
  }
}