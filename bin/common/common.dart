

void throwToolExit(String message, { int exitCode }) {
  throw ToolExit(message, exitCode: exitCode);
}

class ToolExit implements Exception {
  ToolExit(this.message, { this.exitCode });

  final String message;
  final int exitCode;

  @override
  String toString() => 'Exception: $message';
}