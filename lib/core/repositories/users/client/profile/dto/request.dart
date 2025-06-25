import 'package:json_annotation/json_annotation.dart';

part 'request.g.dart';


@JsonSerializable()
class ProfilePatchDTO {
  @JsonKey(name: 'birthday', includeIfNull: false)
  final DateTime? birthday;

  @JsonKey(name: 'username', includeIfNull: false)
  final String? username;

  @JsonKey(name: 'family_name', includeIfNull: false)
  final String? familyName;

  @JsonKey(name: 'phone', includeIfNull: false)
  final String? phone;

  ProfilePatchDTO({
    this.birthday,
    this.username,
    this.familyName,
    this.phone,
  });

  factory ProfilePatchDTO.fromJson(Map<String, dynamic> json) =>
      _$ProfilePatchDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ProfilePatchDTOToJson(this);
}
