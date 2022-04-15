import 'dart:typed_data';

import 'package:hive/hive.dart';

part 'file_model.g.dart';

@HiveType(typeId: 1)
class FileModel {
  @HiveField(0)
  final String fileName;
  @HiveField(1)
  final Uint8List file;

  FileModel(this.fileName, this.file);
}
