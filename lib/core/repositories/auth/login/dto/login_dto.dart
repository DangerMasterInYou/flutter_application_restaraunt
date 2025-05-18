import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:email_validator/email_validator.dart';

part 'login_dto.g.dart';

@JsonSerializable()
class LoginDTO extends Equatable {
  const LoginDTO._({
    required this.email,
    required this.password
  });

  factory LoginDTO({
    required String email,
    required String password
  }) {
    if (!EmailValidator.validate(email)) {
      throw Exception('Некорректный email: $email');
    }
    
    return LoginDTO._(
      email: email,
      password: password
    );
  }

  @JsonKey(name: 'email')
  final String email;

  @JsonKey(name: 'password')
  final String password;

  factory LoginDTO.fromJson(Map<String, dynamic> json) => _$LoginDTOFromJson(json);
  Map<String, dynamic> toJson() => _$LoginDTOToJson(this);

  @override
  List<Object> get props => [];
}
