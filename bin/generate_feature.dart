import 'dart:developer';
import 'dart:io';

/// To use this feature generator
/// `dart run bin/generate_feature.dart feature_name`
void main(List<String> args) async {
  if (args.isEmpty) {
    log('❌ No feature name provided');
    log('Usage: dart run bin/generate_feature.dart feature_name');
    exit(1);
  }

  final featureName = args.first;

  log('🔄 Generating feature: $featureName');

  try {
    await FeatureGenerator().generate(featureName);
  } catch (e) {
    log('❌ Error generating feature: $e');
    exit(1);
  }
}

/// A CLI tool to generate a feature with clean architecture structure
class FeatureGenerator {
  /// Base path for features
  final String basePath = 'lib/src/features';
  final String testBasePath = 'test/src/features';

  /// Generate a feature with the given name
  Future<void> generate(String featureName) async {
    final normalizedName = _normalizeFeatureName(featureName);

    // Create directories
    final directories = [
      '$basePath/$normalizedName',
      '$basePath/$normalizedName/data',
      '$basePath/$normalizedName/data/datasources',
      '$basePath/$normalizedName/data/models',
      '$basePath/$normalizedName/data/datasources/local',
      '$basePath/$normalizedName/data/datasources/remote',
      '$basePath/$normalizedName/data/repositories_impl',
      '$basePath/$normalizedName/domain',
      '$basePath/$normalizedName/domain/entities',
      '$basePath/$normalizedName/domain/repositories',
      '$basePath/$normalizedName/domain/usecases',
      '$basePath/$normalizedName/presentation',
      '$basePath/$normalizedName/presentation/pages',
      '$basePath/$normalizedName/presentation/widgets',
      '$basePath/$normalizedName/presentation/blocs',
      '$testBasePath/$normalizedName/data',
      '$testBasePath/$normalizedName/data/models',
      '$testBasePath/$normalizedName/data/datasources',
      '$testBasePath/$normalizedName/data/datasources/local',
      '$testBasePath/$normalizedName/data/datasources/remote',
      '$testBasePath/$normalizedName/data/repositories_impl',
      '$testBasePath/$normalizedName/domain',
      '$testBasePath/$normalizedName/domain/entities',
      '$testBasePath/$normalizedName/domain/repositories',
      '$testBasePath/$normalizedName/domain/usecases',
      '$testBasePath/$normalizedName/presentation',
      '$testBasePath/$normalizedName/presentation/pages',
      '$testBasePath/$normalizedName/presentation/widgets',
      '$testBasePath/$normalizedName/presentation/blocs',
    ];

    for (final dir in directories) {
      await Directory(dir).create(recursive: true);
      log('✅ Created directory: $dir');
    }

    // Create files
    await _createFeatureFiles(normalizedName);

    // Update index_generator.yaml
    await _updateIndexGenerator(normalizedName);

    // Run index generator
    await _runIndexGenerator();

    log('🎉 Feature $normalizedName generated successfully!');
  }

  /// Run the index generator command
  Future<void> _runIndexGenerator() async {
    log('📦 Running index generator...');

    try {
      final result = await Process.run('dart', [
        'pub',
        'global',
        'run',
        'index_generator',
      ]);

      if (result.exitCode == 0) {
        log('✅ Index files generated successfully');
      } else {
        log('⚠️ Index generator completed with warnings:');
        log(result.stderr.toString());
      }
    } catch (e) {
      log('❌ Failed to run index generator: $e');
      log('📝 Run manually with: dart pub global run index_generator');
    }
  }

  // * ----- Create feature files ----- //

  /// Create feature files
  Future<void> _createFeatureFiles(String featureName) async {
    await _createDomainFiles(featureName);
    await _createDataFiles(featureName);
    await _createPresentationFiles(featureName);
  }

  // * ----- Data files ----- //

  /// Create data files
  Future<void> _createDataFiles(String featureName) async {
    await _createFile(
      '$basePath/$featureName/data/data.dart',
      '// GENERATED CODE - DO NOT MODIFY BY HAND\n\nlibrary;\n',
    );

    // Create models
    await _createFile(
      '$basePath/$featureName/data/models/${featureName}_model.dart',
      '''class ${_pascalCase(featureName)}Model {}''',
    );

    // Create local datasource
    await _createFile(
      '$basePath/$featureName/data/datasources/local/${featureName}_local_datasource_impl.dart',
      '''
abstract class ${_pascalCase(featureName)}LocalDatasource {}

class ${_pascalCase(featureName)}LocalDatasourceImpl implements ${_pascalCase(featureName)}LocalDatasource {}
''',
    );

    // Create remote datasource
    await _createFile(
      '$basePath/$featureName/data/datasources/remote/${featureName}_remote_datasource_impl.dart',
      '''
abstract class ${_pascalCase(featureName)}RemoteDatasource {}

class ${_pascalCase(featureName)}RemoteDatasourceImpl implements ${_pascalCase(featureName)}RemoteDatasource {}
''',
    );
  }

  // * ----- Domain files ----- //

  /// Create domain files
  Future<void> _createDomainFiles(String featureName) async {
    await _createFile(
      '$basePath/$featureName/domain/domain.dart',
      '// GENERATED CODE - DO NOT MODIFY BY HAND\n\nlibrary;\n',
    );

    // Create entity
    await _createFile(
      '$basePath/$featureName/domain/entities/${featureName}_entity.dart',
      '''import 'package:equatable/equatable.dart';

class ${_pascalCase(featureName)}Entity extends Equatable {
  const ${_pascalCase(featureName)}Entity();

  @override
  List<Object?> get props => [];
}
''',
    );

    // Create repository
    await _createFile(
      '$basePath/$featureName/domain/repositories/${featureName}_repository.dart',
      'abstract class ${_pascalCase(featureName)}Repository {}',
    );
  }

  // * ----- Presentation files ----- //

  /// Create presentation files
  Future<void> _createPresentationFiles(String featureName) async {
    // Create presentation.dart
    await _createFile(
      '$basePath/$featureName/presentation/presentation.dart',
      '// GENERATED CODE - DO NOT MODIFY BY HAND\n\nlibrary;\n',
    );

    // Create feature.dart
    await _createFile(
      '$basePath/$featureName/$featureName.dart',
      '// GENERATED CODE - DO NOT MODIFY BY HAND\n\nlibrary;\n\nexport \'data/data.dart\';\nexport \'domain/domain.dart\';\nexport \'presentation/presentation.dart\';\n',
    );

    // Create feature_page.dart
    await _createFile(
      '$basePath/$featureName/presentation/pages/${featureName}_page.dart',
      '''import 'package:flutter/material.dart';

class ${_pascalCase(featureName)}Page extends StatelessWidget {
  const ${_pascalCase(featureName)}Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
''',
    );

    // Create feature_bloc.dart
    await _createFile(
      '$basePath/$featureName/presentation/blocs/${featureName}_bloc.dart',
      '''import 'package:equatable/equatable.dart';

part '${featureName}_event.dart';
part '${featureName}_state.dart';
''',
    );

    // Create feature_event.dart
    await _createFile(
      '$basePath/$featureName/presentation/blocs/${featureName}_event.dart',
      '''part of '${featureName}_bloc.dart';

sealed class ${_pascalCase(featureName)}Event {}''',
    );

    // Create feature_state.dart
    await _createFile(
      '$basePath/$featureName/presentation/blocs/${featureName}_state.dart',
      '''part of '${featureName}_bloc.dart';

final class ${_pascalCase(featureName)}State extends Equatable {
  const ${_pascalCase(featureName)}State();

  @override
  List<Object?> get props => [];
}
''',
    );
  }

  /// Update index_generator.yaml to include the new feature
  Future<void> _updateIndexGenerator(String featureName) async {
    final file = File('index_generator.yaml');
    if (!await file.exists()) {
      log('❌ index_generator.yaml does not exist');
      return;
    }

    String content = await file.readAsString();

    // Check if the feature already exists in the config
    if (content.contains('$basePath/$featureName')) {
      log('⚠️ Feature already exists in index_generator.yaml');
      return;
    }

    // Add the new feature entries
    final featureEntries =
        '''
  # FEATURE : ${featureName.toUpperCase()}
    - directory_path: $basePath/$featureName/data
    - directory_path: $basePath/$featureName/domain
    - directory_path: $basePath/$featureName/presentation
    - directory_path: $basePath/$featureName
      include:
        - data/data.dart
        - domain/domain.dart
        - presentation/presentation.dart
''';

    // Instead of trying to find the perfect spot, just append to the end of the file
    // This is more reliable
    final newContent = '${content.trimRight()}\n$featureEntries';

    // Write the updated content
    await file.writeAsString(newContent);
    log('✅ Updated index_generator.yaml');
  }

  /// Create a file with the given content
  Future<void> _createFile(String filePath, String content) async {
    final file = File(filePath);
    await file.writeAsString(content);
    log('✅ Created file: $filePath');
  }

  /// Convert a feature name to snake_case
  String _normalizeFeatureName(String name) {
    // Convert to snake_case
    name = name.replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => match.start == 0
          ? match.group(0)!.toLowerCase()
          : '_${match.group(0)!.toLowerCase()}',
    );

    // Replace spaces with underscores
    name = name.replaceAll(' ', '_');

    return name.toLowerCase();
  }

  /// Convert a string to PascalCase
  String _pascalCase(String input) {
    if (input.isEmpty) return '';

    // Split by underscores or spaces
    final words = input.split(RegExp(r'[_\s]'));

    // Capitalize each word
    return words
        .map(
          (word) => word.isNotEmpty
              ? word[0].toUpperCase() + word.substring(1).toLowerCase()
              : '',
        )
        .join('');
  }
}
