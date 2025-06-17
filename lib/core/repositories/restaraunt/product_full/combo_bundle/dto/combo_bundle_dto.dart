import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'combo_bundle_dto.g.dart';

@JsonSerializable()
class ComboBundleCreateDTO extends Equatable {
  const ComboBundleCreateDTO._(
      {required this.comboVariantId,
      required this.includedVariantId,
      required this.quantity});

  factory ComboBundleCreateDTO(
      {required int comboVariantId,
      required int includedVariantId,
      required int quantity}) {
    return ComboBundleCreateDTO._(
        comboVariantId: comboVariantId,
        includedVariantId: includedVariantId,
        quantity: quantity);
  }

  @JsonKey(name: 'combo_variant_id')
  final int comboVariantId;

  @JsonKey(name: 'included_variant_id')
  final int includedVariantId;

  @JsonKey(name: 'quantity')
  final int quantity;

  factory ComboBundleCreateDTO.fromJson(Map<String, dynamic> json) =>
      _$ComboBundleCreateDTOFromJson(json);
  Map<String, dynamic> toJson() => _$ComboBundleCreateDTOToJson(this);

  @override
  List<Object> get props => [];
}

@JsonSerializable()
class ComboBundlePatchDTO {
  @JsonKey(name: 'combo_variant_id', includeIfNull: false)
  final int? comboVariantId;

  @JsonKey(name: 'included_variant_id', includeIfNull: false)
  final int? includedVariantId;

  @JsonKey(name: 'quantity')
  final int? quantity;

  const ComboBundlePatchDTO({
    this.comboVariantId,
    this.includedVariantId,
    this.quantity,
  });

  factory ComboBundlePatchDTO.fromJson(Map<String, dynamic> json) =>
      _$ComboBundlePatchDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ComboBundlePatchDTOToJson(this);
}
