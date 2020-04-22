import 'dart:io';
import 'package:yaml/yaml.dart';

class SocialMetadata  {
  final String title;
  final String description;
  final String url;

  SocialMetadata({this.title, this.description, this.url});

  @override
  String toString() => 'SocialMetadata:\n $title,\n $description, \n$url';
}


SocialMetadata generateMetadata()  {
  try {
    String content = File('pubspec.yaml').readAsStringSync();

    final doc = loadYaml(content);

    String title;
    String description;
    String url;

    if (doc is YamlMap) {
      final showcaseNode = doc['showcase'];
      if (showcaseNode is YamlMap) {
        title = showcaseNode['title'];
        description = showcaseNode['description'];
        url = showcaseNode['url'];
      }

    } else {
      print('no map $doc');
    }

    title ??= doc['name'];
    description ??= doc['description'];

    return SocialMetadata(title: title, description: description, url: url);
  } catch (e) {
    stderr.writeln('Error while parsion social metadata');
    throw(e);
  }
}