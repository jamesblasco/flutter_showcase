import 'dart:io';
import 'package:yaml/yaml.dart';

class SocialMetadata  {
  final String title;
  final String description;
  final String url;

  SocialMetadata(this.title, this.description, this.url);

  @override
  String toString() => 'SocialMetadata:\n $title,\n $description, \n$url';
}


Future<SocialMetadata> generateMetadata() async {
  String content = File('pubspec.yaml').readAsStringSync();

  final doc = loadYaml(content);

  if(doc is YamlMap) {
    final successNode = doc['showcase'];
    if(successNode is YamlMap) {
      final String  title = successNode['title'];
      final String  description = successNode['description'];
      final String  url = successNode['url'];

      return SocialMetadata(title, description, url);
    } else {
      print('no showcase $successNode');
    }
  } else {
    print('no map $doc');
  }
  return null;
}