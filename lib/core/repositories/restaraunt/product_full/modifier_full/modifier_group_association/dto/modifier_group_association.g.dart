// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modifier_group_association.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModifierGroupAssociationCreateDTO _$ModifierGroupAssociationCreateDTOFromJson(
        Map<String, dynamic> json) =>
    ModifierGroupAssociationCreateDTO(
      name: json['name'] as String,
      isRequired: json['is_required'] as bool,
      isMultiselect: json['is_multiselect'] as bool,
    );

Map<String, dynamic> _$ModifierGroupAssociationCreateDTOToJson(
        ModifierGroupAssociationCreateDTO instance) =>
    <String, dynamic>{
      'name': instance.name,
      'is_required': instance.isRequired,
      'is_multiselect': instance.isMultiselect,
    };

ModifierGroupAssociationPatchDTO _$ModifierGroupAssociationPatchDTOFromJson(
        Map<String, dynamic> json) =>
    ModifierGroupAssociationPatchDTO(
      name: json['name'] as String?,
      isRequired: json['is_required'] as bool?,
      isMultiselect: json['is_multiselect'] as bool?,
    );

Map<String, dynamic> _$ModifierGroupAssociationPatchDTOToJson(
        ModifierGroupAssociationPatchDTO instance) =>
    <String, dynamic>{
      if (instance.name case final value?) 'name': value,
      if (instance.isRequired case final value?) 'is_required': value,
      if (instance.isMultiselect case final value?) 'is_multiselect': value,
    };
