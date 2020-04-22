import 'dart:io';

import 'common/common.dart';
import 'common/directory.dart';
import 'common/web_driver.dart';

const _appFilePath = 'showcase/src/app.dart';
const _appTestFilePath = 'showcase/src/app_test.dart';

Future takeScreenshot({String browser = 'chrome'}) async {
  Directory('showcase/src')..createIfNotExistSync();

  final temp = [
    File(_appFilePath)..writeAsStringSync(_appFile),
    File('showcase/src/app_test.dart')..writeAsStringSync(_appTestFile)
  ];

  WebDriver driver;
  if (browser == 'chrome')
    driver = ChromeDriver();
  else if (browser == 'safari')
    driver = SafariDriver();
  else
    throwToolExit('$browser is not supported');

  print('before start');
  await driver.start();

  print('after driver started');

  final screenshotProccess = await Process.start(
    'flutter',
    [
      'drive',
      '--target=$_appFilePath',
      '--driver=$_appTestFilePath',
      '--browser-name=$browser',
      '-dweb-server',
      '--release',
      '--dart-define=SCREENSHOT_MODE=true',
      '--dart-define=FLUTTER_SHOWCASE=true'
    ],
  );

  await stdout.addStream(screenshotProccess.stdout);
  await stderr.addStream(screenshotProccess.stderr);

  await screenshotProccess.exitCode;

  driver.close();

  temp.forEach((file) {
    file.deleteSync(recursive: true);
  });
}

final String _appFile = '''
  import 'package:flutter_driver/driver_extension.dart';
  import '../../lib/main.dart' as app;
  void main() {
    // This line enables the extension
    enableFlutterDriverExtension();

    // Call the `main()` function of your app or call `runApp` with any widget you
    // are interested in testing.
    app.main();
  }
  ''';

final String _appTestFile = '''
  import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main()  {
  group('Flutter Showcase', ()  {
    // First, define the Finders and use them to locate widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys in step 1.
    final counterTextFinder = find.byTooltip('Button');
    final buttonFinder = find.byValueKey('increment');

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();

    });



    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('screenshot', () async {
      final image  = await driver.screenshot();
      var fileCopy = await File('build/web_showcase/social_media.png').writeAsBytes(image);
    });


  });
}

  ''';
