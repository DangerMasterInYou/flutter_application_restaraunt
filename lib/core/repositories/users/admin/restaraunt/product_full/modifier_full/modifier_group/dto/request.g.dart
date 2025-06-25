// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModifierGroupCreateDTO _$ModifierGroupCreateDTOFromJson(
        Map<String, dynamic> json) =>
    ModifierGroupCreateDTO(
      name: json['name'] as String,
      isRequired: json['is_required'] as bool,
      isMultiselect: json['is_multiselect'] as bool,
    );

Map<String, dynamic> _$ModifierGroupCreateDTOToJson(
        ModifierGroupCreateDTO instance) =>
    <String, dynamic>{
      'name': instance.name,
      'is_required': instance.isRequired,
      'is_multiselect': instance.isMultiselect,
    };

ModifierGroupPatchDTO _$ModifierGroupPatchDTOFromJson(
        Map<String, dynamic> json) =>
    ModifierGroupPatchDTO(
      name: json['name'] as String?,
      isRequired: json['is_required'] as bool?,
      isMultiselect: json['is_multiselect'] as bool?,
    );

Map<String, dynamic> _$ModifierGroupPatchDTOToJson(
        ModifierGroupPatchDTO instance) =>
    <String, dynamic>{
      if (instance.name case final value?) 'name': value,
      if (instance.isRequired case final value?) 'is_required': value,
      if (instance.isMultiselect case final value?) 'is_multiselect': value,
    };
