import 'dart:io';
import 'package:args/args.dart';

import 'common/directory.dart';
import 'common/html_generator.dart';
import 'common/social_metadata.dart';
import 'screenshot.dart';

bool _useSkia = true;

Future<void> main(List<String> args) async {
  final parser = ArgParser();
  parser.addOption('title');
  parser.addOption('github_url');
  parser.addOption('description');
  parser.addOption('FLUTTER_WEB_USE_SKIA');
  final results = parser.parse(args);
  _useSkia = results['FLUTTER_WEB_USE_SKIA'] ?? true;
  /*final Status status = globals.logger.startProgress('Compiling profile for the Web...', timeout: null);*/

  final socialMetadata = generateMetadata();

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
      '--dart-define=FLUTTER_WEB_USE_SKIA=${_useSkia ? 'true' : 'false'}',
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
