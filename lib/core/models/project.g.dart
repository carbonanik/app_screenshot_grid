// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProjectAdapter extends TypeAdapter<Project> {
  @override
  final int typeId = 0;

  @override
  Project read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Project(
      gridColumns: fields[0] as int,
      gridRows: fields[1] as int,
      outputWidth: fields[2] as int,
      outputHeight: fields[3] as int,
      title: fields[4] as String,
      titleFontSize: fields[5] as double,
      titleColorValue: fields[6] as int,
      titleFontFamily: fields[7] as String,
      bgType: fields[8] as BackgroundTypeHive?,
      showBorders: fields[9] as bool,
      gap: fields[10] as double,
      deviceFrameIndex: fields[11] as int,
      images: (fields[12] as List?)?.cast<Uint8List>(),
    );
  }

  @override
  void write(BinaryWriter writer, Project obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.gridColumns)
      ..writeByte(1)
      ..write(obj.gridRows)
      ..writeByte(2)
      ..write(obj.outputWidth)
      ..writeByte(3)
      ..write(obj.outputHeight)
      ..writeByte(4)
      ..write(obj.title)
      ..writeByte(5)
      ..write(obj.titleFontSize)
      ..writeByte(6)
      ..write(obj.titleColorValue)
      ..writeByte(7)
      ..write(obj.titleFontFamily)
      ..writeByte(8)
      ..write(obj.bgType)
      ..writeByte(9)
      ..write(obj.showBorders)
      ..writeByte(10)
      ..write(obj.gap)
      ..writeByte(11)
      ..write(obj.deviceFrameIndex)
      ..writeByte(12)
      ..write(obj.images);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BackgroundTypeHiveAdapter extends TypeAdapter<BackgroundTypeHive> {
  @override
  final int typeId = 1;

  @override
  BackgroundTypeHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BackgroundTypeHive()
      ..type = fields[0] as String
      ..colorValue = fields[1] as int?
      ..gradientColors = (fields[2] as List?)?.cast<int>()
      ..gradientStops = (fields[3] as List?)?.cast<double>()
      ..begin = fields[4] as String?
      ..end = fields[5] as String?;
  }

  @override
  void write(BinaryWriter writer, BackgroundTypeHive obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.colorValue)
      ..writeByte(2)
      ..write(obj.gradientColors)
      ..writeByte(3)
      ..write(obj.gradientStops)
      ..writeByte(4)
      ..write(obj.begin)
      ..writeByte(5)
      ..write(obj.end);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BackgroundTypeHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
