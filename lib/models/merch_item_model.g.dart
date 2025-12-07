// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merch_item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MerchItemModelAdapter extends TypeAdapter<MerchItemModel> {
  @override
  final int typeId = 3;

  @override
  MerchItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MerchItemModel(
      id: fields[0] as String,
      itemName: fields[1] as String,
      priceInJpy: fields[2] as double,
      targetCurrency: fields[3] as String,
      convertedPrice: fields[4] as double,
      dateAdded: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, MerchItemModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.itemName)
      ..writeByte(2)
      ..write(obj.priceInJpy)
      ..writeByte(3)
      ..write(obj.targetCurrency)
      ..writeByte(4)
      ..write(obj.convertedPrice)
      ..writeByte(5)
      ..write(obj.dateAdded);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MerchItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
