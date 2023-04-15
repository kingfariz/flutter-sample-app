
import 'dart:convert';

UserModel productFromJson(String str) =>
    UserModel.fromJson(json.decode(str));

class UserModel {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String avatarUrl;
  final String supportUrl;
  final String supportText;
  
  UserModel({
     this.id = 0,
     this.email= "",
     this.firstName= "",
     this.lastName= "",
     this.avatarUrl= "",
     this.supportUrl= "",
     this.supportText= "",
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['data']['id'],
      email: json['data']['email'],
      firstName: json['data']['first_name'],
      lastName: json['data']['last_name'],
      avatarUrl: json['data']['avatar'],
      supportUrl: json['support']['url'],
      supportText: json['support']['text'],
    );
  }
}
