import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../header_boxes.dart';

part 'combo_bundle.g.dart';

@HiveType(typeId: HiveHeaders.comboBundleId)
@JsonSerializable()
class ComboBundle {
  ComboBundle({
    required this.id,
    required this.comboVariantId,
    required this.includedVariantId,
    required this.quantity,
    required this.isDeleted,
  });

  @HiveField(0)
  @JsonKey(name: 'id')
  final int id;

  @HiveField(1)
  @JsonKey(name: 'combo_variant_id')
  final int comboVariantId;

  @HiveField(2)
  @JsonKey(name: 'included_variant_id')
  final int includedVariantId;

  @HiveField(3)
  @JsonKey(name: 'quantity')
  final int quantity;

  @HiveField(4)
  @JsonKey(name: 'is_deleted')
  final bool isDeleted;

  factory ComboBundle.fromJson(Map<String, dynamic> json) =>
      _$ComboBundleFromJson(json);
  Map<String, dynamic> toJson() => _$ComboBundleToJson(this);

  ComboBundle copyWith({
    int? id,
    int? comboVariantId,
    int? includedVariantId,
    int? quantity,
    bool? isDeleted,
  }) {
    return ComboBundle(
      id: id ?? this.id,
      comboVariantId: comboVariantId ?? this.comboVariantId,
      includedVariantId: includedVariantId ?? this.includedVariantId,
      quantity: quantity ?? this.quantity,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
