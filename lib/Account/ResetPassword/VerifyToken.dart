import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'Reset.dart';

getVerifyToken(String token) async {
  String url = "https://mobile.celebrityads.net/api/password/find/$token";
  try {
    final respons = await http.get(Uri.parse(url));
    if (respons.statusCode == 200) {
      final body = respons.body;
      VerifyToken verifyToken = VerifyToken.fromJson(jsonDecode(body));
      if (verifyToken.success == true) {
        var token = verifyToken.data?.passowrdReset?.token;
        print('00000000000000000000000000000000000000');
        print(token);
        print('00000000000000000000000000000000000000');
        return true;
      }
    } else {
      return 'serverException';
    }
  } catch (e) {
    if (e is SocketException) {
      return 'SocketException';
    } else if (e is TimeoutException) {
      return 'TimeoutException';
    } else {
      return 'serverException';
    }
  }
}

//------------------------------------------------------------------
class VerifyToken {
  bool? success;
  Data? data;
  Message? message;

  VerifyToken({this.success, this.data, this.message});

  VerifyToken.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message =
        json['message'] != null ? Message.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.message != null) {
      data['message'] = this.message!.toJson();
    }
    return data;
  }
}

class Data {
  int? status;
  PassowrdReset? passowrdReset;

  Data({this.status, this.passowrdReset});

  Data.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    passowrdReset = json['passowrdReset'] != null
        ? new PassowrdReset.fromJson(json['passowrdReset'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.passowrdReset != null) {
      data['passowrdReset'] = this.passowrdReset!.toJson();
    }
    return data;
  }
}

class PassowrdReset {
  int? id;
  String? email;
  String? token;
  String? createdAt;
  String? updatedAt;

  PassowrdReset(
      {this.id, this.email, this.token, this.createdAt, this.updatedAt});

  PassowrdReset.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    token = json['token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['token'] = this.token;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Message {
  String? en;
  String? ar;

  Message({this.en, this.ar});

  Message.fromJson(Map<String, dynamic> json) {
    en = json['en'];
    ar = json['ar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['en'] = this.en;
    data['ar'] = this.ar;
    return data;
  }
}
