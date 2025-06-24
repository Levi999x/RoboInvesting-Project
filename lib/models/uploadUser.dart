import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(explicitToJson: true)
class UploadUser{

  UploadUser(
      this.id,
      this.image,
      this.phone,
      this.name,
      this.email,
      this.token,
      this.time,
      this.score,
      this.balance,
      this.address,
      );

  String id,
      image,
      phone,
      name,
      email,
      address,
  token;
     int time;
     int score;
     double balance;

  UploadUser.fromJson(Map<dynamic,dynamic> json)
    :id = json['id'] as String ,
        image = json['image'] as String ,
        phone = json['phone'] as String ,
        name = json['name'] as String,
        email= json['email'] as String,
        token= json['token']??"" as String,
        time = json['time'] as int,
        score = json['score']??0 as int,
        balance = json['balance']??0.01 as double,
  address = json['address'] ??"" as String;

  Map<dynamic, dynamic> toJson() =>
      <dynamic, dynamic>{
        'id': id,
        'image': image,
        'phone': phone,
        'name': name,
        'email': email,
        'token': token,
        'time': time,
        'score': score,
        'balance': balance,
        'address': address,


      };
}