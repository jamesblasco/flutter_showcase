import 'dart:io';


abstract class WebDriver {
  Process process;

  List<String> get arguments => [];

  String get command;

  Future start() async {
    assert(process == null, 'driver is already running');
    process = await Process.start(
      command,
      arguments,
    );
  }

  void close() {
    assert(process != null, 'driver is already closed');
    process.kill(ProcessSignal.sigusr1);
    process = null;
  }
}

class ChromeDriver extends WebDriver {
  @override
  String get command => 'chromedriver';

  @override
  List<String> get arguments => [
        '--port=4444',
      ];
}

class SafariDriver extends WebDriver {
  @override
  String get command => 'chromedriver';

  @override
  List<String> get arguments => [
        '--port=4444',
      ];
}


