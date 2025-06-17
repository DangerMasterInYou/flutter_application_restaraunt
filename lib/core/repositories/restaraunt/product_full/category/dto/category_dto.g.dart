// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryCreateDTO _$CategoryCreateDTOFromJson(Map<String, dynamic> json) =>
    CategoryCreateDTO(
      name: json['name'] as String,
      sortOrder: (json['sortOrder'] as num).toInt(),
    );

Map<String, dynamic> _$CategoryCreateDTOToJson(CategoryCreateDTO instance) =>
    <String, dynamic>{
      'name': instance.name,
      'sortOrder': instance.sortOrder,
    };

CategoryPatchDTO _$CategoryPatchDTOFromJson(Map<String, dynamic> json) =>
    CategoryPatchDTO(
      name: json['name'] as String?,
      sortOrder: (json['sort_order'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CategoryPatchDTOToJson(CategoryPatchDTO instance) =>
    <String, dynamic>{
      if (instance.name case final value?) 'name': value,
      if (instance.sortOrder case final value?) 'sort_order': value,
    };
