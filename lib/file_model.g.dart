// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FileModelAdapter extends TypeAdapter<FileModel> {
  @override
  final int typeId = 1;

  @override
  FileModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FileModel(
      fields[0] as String,
      fields[1] as Uint8List,
    );
  }

  @override
  void write(BinaryWriter writer, FileModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.fileName)
      ..writeByte(1)
      ..write(obj.file);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FileModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
