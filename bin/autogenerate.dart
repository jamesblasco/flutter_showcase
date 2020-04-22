import 'dart:io';

import 'package:analyzer/src/dart/ast/utilities.dart';
import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/ast/standard_ast_factory.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:_fe_analyzer_shared/src/scanner/token.dart';
import 'package:dart_style/dart_style.dart';
import 'common/common.dart';
import 'package:args/args.dart';
import 'dart:convert';

void main(List<String> args) {
  final parser = ArgParser();
  parser.addOption('dir', defaultsTo: '');
  parser.addOption('title');
  parser.addOption('github_url');
  parser.addOption('description');
  parser.addOption('links');
  final results = parser.parse(args);
  final directoryPath = results['dir'];

  print('Auto adding Flutter Showcase to project in path $directoryPath');
  try {
    addShowcasePackageIfMissing(path: directoryPath);
  } catch (e) {
    stderr.writeln(
        'An error occurred while adding showcase package in ${directoryPath}pubspec.yaml');
    throw (e);
  }

  Map<String, String> linksFromEncodedJson(String links) {
    if (links == null) return {};

    try {
      var codedLinks = links;
      if (links.startsWith('"') && links.endsWith('"')) {
        codedLinks = links.substring(1, links.length - 1);
      }
      final json = jsonDecode(codedLinks);
      return Map<String, String>.from(json);
    } catch (e) {
      print(e);
      return {};
    }
  }

  try {
    ProjectGenerator(
      title: results['title'],
      description: results['description'],
      githubUrl: results['github_url'],
      links: linksFromEncodedJson(results['links']),
    ).generate(path: directoryPath);
  } catch (e) {
    stderr.writeln(
        'An error occurred while generating showcase widget inside ${directoryPath}lib/main.dart\n');
    rethrow;
  }
}

/// Add missing dependencies to pubspec.yaml
///
void addShowcasePackageIfMissing({String path = ''}) {
  final pubspecName = '${path}pubspec.yaml';
  final pubspec = File(pubspecName);
  final lines = pubspec.readAsLinesSync();

  int dependencyLine;

  final trackLibraries = {
    '  flutter_test:': false,
    '  flutter_showcase:': false,
    '  flutter_driver:': false,
    '  test:': false,
  };

  for (final line in lines.asMap().entries) {
    if (line.value.startsWith('  flutter:')) {
      dependencyLine = line.key + 2;
    } else {
      trackLibraries.forEach((key, value) {
        if (!value && line.value.contains(key)) {
          trackLibraries[key] = true;
        }
      });
    }
  }

  if (dependencyLine != null) {
    trackLibraries.forEach((package, isAlreadyAdded) {
      if (!isAlreadyAdded) {
        lines.insert(dependencyLine, package);
        dependencyLine += 1;
        if ({'  flutter_driver:', '  flutter_test:'}.contains(package)) {
          lines.insert(dependencyLine, '    sdk: flutter');
          dependencyLine += 1;
        }
      }
    });

    final newFile = lines.join('\n');
    pubspec.writeAsStringSync(newFile);
    print('Succesfully added packages to project');
    return;
  } else {
    throw ('No dependecy section in $pubspecName');
  }
}

class ProjectGenerator {
  final String title;
  final String description;
  final String githubUrl;
  final Map<String, String> links;

  ProjectGenerator({
    this.title = '',
    this.description = '',
    this.githubUrl = '',
    this.links = const {},
  });

  /// Add missing dependencies to pubspec.yaml
  ///
  void generate({
    String path = '',
  }) {
    final featureSet = FeatureSet.fromEnableFlags([
      'extension-methods',
      'non-nullable',
    ]);

    final filePath = '${path}lib/main.dart';
    final fileContent = File(filePath).readAsStringSync();

    // TODO: Add support for  WidgetApp and CupertinoApp
    if (fileContent.contains('MaterialApp') && fileContent.contains('main')) {
      final parseResult = parseString(
        content: fileContent,
        featureSet: featureSet,
        path: filePath,
        throwIfDiagnostics: false,
      );

      final unit = parseResult.unit;

      importPackageIfMissing(unit);

      var v = AddShowcaseVisitor(this);
      unit.visitChildren(v);

      var formatter = new DartFormatter();

      try {
        final newContent = formatter.format(unit.toSource());
        File(filePath).writeAsStringSync(newContent);
      } on FormatterException catch (ex) {
        throwToolExit('Error while formatting new file\n${ex}');
      }
      print('Adding showcase to project succesfully');
    } else {
      throwToolExit('There is no MaterialApp in lib/main.dart');
    }
  }

  String addShowcaseProject(String s) {
    return '''
  Showcase(
     title: $title,
     description: $description,
     links: [
       ${githubUrl != null ? 'LinkData.github(\'$githubUrl\'),' : ''}
       ${links['pub'] != null ? 'LinkData.pub(\'${links['pub']}\'),' : ''}
     ],
     app: $s)
  ''';
  }

  /// Add missing dependencies to pubspec.yaml
  ///
  void importPackageIfMissing(CompilationUnit unit) {
    final packageImport =
        'import \'package:flutter_showcase/flutter_showcase.dart\';';
    if (!unit.toSource().contains(packageImport)) {
      final Directive node = unit.directives.last;

      final Directive clone = AstCloner().cloneNode(node);

      int offset = clone.offset;
      StringToken importToken = StringToken(TokenType.STRING, 'import', offset);
      StringToken semiColonToken =
          StringToken(TokenType.STRING, ';', offset + packageImport.length - 1);

      final packageString =
          '\'package:flutter_showcase/flutter_showcase.dart\'';
      StringToken st = StringToken(
          TokenType.STRING, packageString, offset + importToken.length);
      final ssl = astFactory.simpleStringLiteral(st, packageString);
      final ImportDirective newDirectory = astFactory.importDirective(null,
          null, importToken, ssl, null, null, null, null, null, semiColonToken);

      unit.directives.add(newDirectory);
    }
  }
}

class AddShowcaseVisitor extends RecursiveAstVisitor {
  final ProjectGenerator generator;

  AddShowcaseVisitor(this.generator);

  @override
  visitMethodInvocation(MethodInvocation node) {
    //Check if Material App exits
    if (node.toSource().contains('MaterialApp')) {
      if (!node.toSource().startsWith('MaterialApp')) {
        var v = AddShowcaseVisitor(generator);
        node.visitChildren(v);
      } else {
        // Check if [builder] argument is called
        if (node.toSource().contains('builder:')) {
          final builderNode = node.argumentList.arguments
              .where((element) => element.toSource().contains('builder:'))
              .first;
          // Check if [builder] argument contains already a frame  builder
          if (!builderNode.toSource().contains('Frame.builder') ||
              !builderNode.toSource().contains('FrameBuilder')) {
            print(builderNode.toSource());
            String newString =
                'builder: (context, child) => FrameBuilder(app: child, ${builderNode.toString()})';
            int offset = builderNode.offset;
            StringToken st = StringToken(TokenType.STRING, newString, offset);

            final ssl = astFactory.simpleStringLiteral(st, newString);
            final NodeReplacer replacer = NodeReplacer(builderNode, ssl);
            builderNode.parent.accept(replacer);
          }
        } else {
          // Add frame builder
          final builderNode = node.argumentList.arguments.first;
          print(builderNode);
          String newString =
              '${builderNode.toString()}, builder: Frame.builder';
          int offset = builderNode.offset;
          StringToken st = StringToken(TokenType.STRING, newString, offset);
          final ssl = astFactory.simpleStringLiteral(st, newString);
          final NodeReplacer replacer = NodeReplacer(builderNode, ssl);
          builderNode.parent.accept(replacer);
        }
      }
    }
    if (node.toSource().startsWith('runApp') &&
        !node.toSource().contains('Showcase')) {
      print(node.toSource());
      final widget = node.argumentList.arguments.first;

      SimpleStringLiteral ssl = _createSimpleStringLiteral(widget);
      final NodeReplacer replacer = NodeReplacer(widget, ssl);
      widget.parent.accept(replacer);
    }
  }

  SimpleStringLiteral _createSimpleStringLiteral(AstNode node) {
    String newString = generator.addShowcaseProject(node.toString());
    int offset = node.offset;
    StringToken st = StringToken(TokenType.STRING, newString, offset);

    return astFactory.simpleStringLiteral(st, newString);
  }
}
/*


SimpleStringLiteral _create_SimpleStringLiteral(AstNode node){
  String new_string = modify(node.toString());
  int line_num = node.offset;
  //holds the position and type
  StringToken st = new StringToken(
      TokenType.STRING,new_string,line_num);
  return new SimpleStringLiteral(st, new_string);
}
String modify(String s){
  List parts = s.split('=');
  var value = parts[1];
  List l = parts[0].split('.');
  String dynamism = l.sublist(0,l.length-1).join('.');
  String propertyName = l.last.trim();
  return '${dynamism}.set("${propertyName}",${value})';
}*/
