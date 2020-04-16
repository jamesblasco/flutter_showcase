import 'dart:io';
import 'common/directory.dart';
import 'common/html_generator.dart';
import 'common/social_metadata.dart';
import 'screenshot.dart';

Future<void> main(List<String> args) async {
  /*final Status status = globals.logger.startProgress('Compiling profile for the Web...', timeout: null);*/

  final socialMetadata = await generateMetadata();

  await flutterBuildShowcase();
  try {
    await takeScreenshot();
  } catch (err) {
    print(err);
  }

  generateHtmlFile(socialMetadata);
}


Future flutterBuildShowcase() async {

  Directory('build/web_old')..removeIfExistsSync();
  Directory('build/web')..renameIfExistsSync('build/web_old');

  final process = await Process.start(
    'flutter',
    [
      'build',
      'web',
    //  '--dart-define=FLUTTER_WEB_USE_SKIA=true',
      '--dart-define=FLUTTER_SHOWCASE=true',
    ],
  );


  stdout.addStream(process.stdout);
  stderr.addStream(process.stderr);
  await process.exitCode;

  Directory('build/web_showcase')..removeIfExistsSync();
  Directory('build/web')..renameIfExistsSync('build/web_showcase');
  Directory('build/web_old')..renameIfExistsSync('build/web');
}
//
