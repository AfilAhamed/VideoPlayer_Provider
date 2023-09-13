// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoriteVideoModelAdapter extends TypeAdapter<FavoriteVideoModel> {
  @override
  final int typeId = 1;

  @override
  FavoriteVideoModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoriteVideoModel(
      favvideoPath: fields[1] as String,
      favname: fields[0] as String,
      favThumbnailPath: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, FavoriteVideoModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.favname)
      ..writeByte(1)
      ..write(obj.favvideoPath)
      ..writeByte(2)
      ..write(obj.favThumbnailPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteVideoModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
