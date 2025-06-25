import 'package:flutter_application_restaraunt/api_config.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import '../header_boxes.dart';

part 'menu.g.dart';

@HiveType(typeId: HiveHeaders.menuId)
@JsonSerializable()
class Menu {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  
  String get fullImageUrl => '${ApiConfig.apiSiteUrl}$imageUrl';

  @HiveField(4)
  final String category;

  @HiveField(5)
  final int price;

  @HiveField(6)
  final int? value;

  @HiveField(7)
  final String? unit;

  @HiveField(8)
  final String sku;

  @HiveField(9)
  @JsonKey(name: 'is_available')
  final bool isAvailable;
  
  @HiveField(10)
  @JsonKey(name: 'is_deleted')
  final bool? isDeleted;


  @HiveField(11)
  @JsonKey(name: 'modifier_groups')
  final List<ModifierGroup> modifierGroups;

  Menu({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    required this.category,
    required this.price,
    this.value,
    this.unit,
    required this.sku,
    required this.isAvailable,
    this.isDeleted = false,
    required this.modifierGroups,
  });

  Menu copyWith({
    int? id,
    String? name,
    String? description,
    String? imageUrl,
    String? category,
    int? price,
    int? value,
    String? unit,
    String? sku,
    bool? isAvailable,
    bool? isDeleted,
    List<ModifierGroup>? modifierGroups,
  }) {
    return Menu(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      price: price ?? this.price,
      value: value ?? this.value,
      unit: unit ?? this.unit,
      sku: sku ?? this.sku,
      isAvailable: isAvailable ?? this.isAvailable,
      isDeleted: isDeleted ?? this.isDeleted,
      modifierGroups: modifierGroups ?? this.modifierGroups,
    );
  }

  factory Menu.fromJson(Map<String, dynamic> json) => _$MenuFromJson(json);
  Map<String, dynamic> toJson() => _$MenuToJson(this);
}

@HiveType(typeId: HiveHeaders.modifierGroupId)
@JsonSerializable()
class ModifierGroup {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  @JsonKey(name: 'is_required')
  final bool isRequired;

  @HiveField(3)
  @JsonKey(name: 'is_multiselect')
  final bool isMultiselect;
  
  @HiveField(4)
  @JsonKey(name: 'is_deleted')
  final bool isDeleted;

  @HiveField(5)
  final List<Modifier> modifiers;

  ModifierGroup({
    required this.id,
    required this.name,
    required this.isRequired,
    required this.isMultiselect,
    this.isDeleted = false,
    required this.modifiers,
  });
  
  ModifierGroup copyWith({
    int? id,
    String? name,
    bool? isRequired,
    bool? isMultiselect,
    List<Modifier>? modifiers,
    bool? isDeleted,
  }) {
    return ModifierGroup(
      id: id ?? this.id,
      name: name ?? this.name,
      isRequired: isRequired ?? this.isRequired,
      isMultiselect: isMultiselect ?? this.isMultiselect,
      modifiers: modifiers ?? this.modifiers,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  factory ModifierGroup.fromJson(Map<String, dynamic> json) => _$ModifierGroupFromJson(json);
  Map<String, dynamic> toJson() => _$ModifierGroupToJson(this);
}

@HiveType(typeId: HiveHeaders.modifierId)
@JsonSerializable()
class Modifier {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  @JsonKey(name: 'price_delta')
  final int priceDelta;
  
  // @HiveField(3)
  // @JsonKey(name: 'is_deleted')
  // final bool isDeleted;

  Modifier({
    required this.id,
    required this.name,
    required this.priceDelta,
    // required this.isDeleted,
  });

  Modifier copyWith({
    int? id,
    String? name,
    int? priceDelta,
    // bool? isDeleted,
  }) {
    return Modifier(
      id: id ?? this.id,
      name: name ?? this.name,
      priceDelta: priceDelta ?? this.priceDelta,
      // isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  factory Modifier.fromJson(Map<String, dynamic> json) => _$ModifierFromJson(json);
  Map<String, dynamic> toJson() => _$ModifierToJson(this);
}