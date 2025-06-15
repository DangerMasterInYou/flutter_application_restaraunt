// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderAdapter extends TypeAdapter<Order> {
  @override
  final int typeId = 7;

  @override
  Order read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Order(
      id: fields[0] as int,
      userId: fields[1] as int,
      itemsProducts: fields[2] as String,
      paymentMethod: fields[3] as String,
      payed: fields[4] as bool,
      status: fields[5] as Status,
      createdAt: fields[6] as DateTime,
      createdBy: fields[7] as String,
      updatedAt: fields[8] as DateTime,
      updatedBy: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Order obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.itemsProducts)
      ..writeByte(3)
      ..write(obj.paymentMethod)
      ..writeByte(4)
      ..write(obj.payed)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.createdBy)
      ..writeByte(8)
      ..write(obj.updatedAt)
      ..writeByte(9)
      ..write(obj.updatedBy);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StatusAdapter extends TypeAdapter<Status> {
  @override
  final int typeId = 6;

  @override
  Status read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Status.created;
      case 1:
        return Status.rejected;
      case 2:
        return Status.accepted;
      case 3:
        return Status.ready;
      case 4:
        return Status.issued;
      default:
        return Status.created;
    }
  }

  @override
  void write(BinaryWriter writer, Status obj) {
    switch (obj) {
      case Status.created:
        writer.writeByte(0);
        break;
      case Status.rejected:
        writer.writeByte(1);
        break;
      case Status.accepted:
        writer.writeByte(2);
        break;
      case Status.ready:
        writer.writeByte(3);
        break;
      case Status.issued:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DateTime? _parseDateTime(dynamic value) {
  if (value == null || value is! String || value.isEmpty) {
    return null;
  }
  try {
    return DateTime.parse(value);
  } catch (e) {
    return null; // Or handle error, like returning DateTime.now() or a specific default
  }
}

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
      id: (json['id'] as num?)?.toInt() ?? 0,
      userId: (json['user_id'] as num?)?.toInt() ?? 0,
      itemsProducts: json['items_products'] as String? ?? '',
      paymentMethod: json['payment_method'] as String? ?? '',
      payed: json['payed'] as bool? ?? false,
      status: json['status'] == null
          ? Status.created // Default status if status field is null
          : $enumDecodeNullable(_$StatusEnumMap, json['status']) ?? Status.created, // Default if enum decode fails
      createdAt: _parseDateTime(json['created_at']) ?? DateTime.now(),
      createdBy: json['created_by'] as String? ?? '',
      updatedAt: _parseDateTime(json['updated_at']) ?? DateTime.now(),
      updatedBy: json['updated_by'] as String? ?? '',
    );

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'items_products': instance.itemsProducts,
      'payment_method': instance.paymentMethod,
      'payed': instance.payed,
      'status': _$StatusEnumMap[instance.status]!,
      'created_at': instance.createdAt.toIso8601String(),
      'created_by': instance.createdBy,
      'updated_at': instance.updatedAt.toIso8601String(),
      'updated_by': instance.updatedBy,
    };

const _$StatusEnumMap = {
  Status.created: 'created',
  Status.rejected: 'rejected',
  Status.accepted: 'accepted',
  Status.ready: 'ready',
  Status.issued: 'issued',
};
