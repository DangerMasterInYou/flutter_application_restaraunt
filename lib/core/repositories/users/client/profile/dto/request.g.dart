// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfilePatchDTO _$ProfilePatchDTOFromJson(Map<String, dynamic> json) =>
    ProfilePatchDTO(
      birthday: json['birthday'] == null
          ? null
          : DateTime.parse(json['birthday'] as String),
      username: json['username'] as String?,
      familyName: json['family_name'] as String?,
      phone: json['phone'] as String?,
    );

Map<String, dynamic> _$ProfilePatchDTOToJson(ProfilePatchDTO instance) =>
    <String, dynamic>{
      if (instance.birthday?.toIso8601String() case final value?)
        'birthday': value,
      if (instance.username case final value?) 'username': value,
      if (instance.familyName case final value?) 'family_name': value,
      if (instance.phone case final value?) 'phone': value,
    };
