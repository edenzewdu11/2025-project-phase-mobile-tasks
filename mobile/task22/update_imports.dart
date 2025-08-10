import 'dart:io';

void main() {
  final dir = Directory('.');
  final dartFiles = dir.listSync(recursive: true)
      .where((file) => file.path.endsWith('.dart') && !file.path.contains('.dart_tool'));

  for (var file in dartFiles) {
    final content = File(file.path).readAsStringSync();
    final updatedContent = content.replaceAll(
      'package:contracts_of_data_sources',
      'package:contracts_of_data_sources',
    );
    
    if (content != updatedContent) {
      print('Updating imports in ${file.path}');
      File(file.path).writeAsStringSync(updatedContent);
    }
  }
}
