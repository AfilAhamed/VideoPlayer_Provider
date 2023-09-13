// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VideoStatisticsAdapter extends TypeAdapter<VideoStatistics> {
  @override
  final int typeId = 2;

  @override
  VideoStatistics read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VideoStatistics(
      period: fields[0] as String,
      addedCount: fields[1] as int,
      deletedCount: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, VideoStatistics obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.period)
      ..writeByte(1)
      ..write(obj.addedCount)
      ..writeByte(2)
      ..write(obj.deletedCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoStatisticsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
