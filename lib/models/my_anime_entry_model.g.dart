// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_anime_entry_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MyAnimeEntryModelAdapter extends TypeAdapter<MyAnimeEntryModel> {
  @override
  final int typeId = 2;

  @override
  MyAnimeEntryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MyAnimeEntryModel(
      animeId: fields[0] as int,
      title: fields[1] as String,
      coverImageUrl: fields[2] as String,
      status: fields[3] as String,
      userId: fields[10] as String,
      userScore: fields[4] as int?,
      episodesWatched: fields[5] as int,
      startDate: fields[6] as DateTime?,
      finishDate: fields[7] as DateTime?,
      totalRewatches: fields[8] as int,
      notes: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MyAnimeEntryModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.animeId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.coverImageUrl)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.userScore)
      ..writeByte(5)
      ..write(obj.episodesWatched)
      ..writeByte(6)
      ..write(obj.startDate)
      ..writeByte(7)
      ..write(obj.finishDate)
      ..writeByte(8)
      ..write(obj.totalRewatches)
      ..writeByte(9)
      ..write(obj.notes)
      ..writeByte(10)
      ..write(obj.userId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyAnimeEntryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
