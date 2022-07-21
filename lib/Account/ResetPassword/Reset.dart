import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

String forgetToken = '';
//CreatePassword---------------------------------------------------------------------------
getCreatePassword(String username) async {
  Map<String, dynamic> data = {"username": username};
  String url = "https://mobile.celebrityads.net/api/password/create";
  try {
    final respons = await http.post(Uri.parse(url), body: data).timeout(const Duration(seconds: 8));
    if (respons.statusCode == 200) {
      var state = jsonDecode(respons.body)?["success"];
      print('CreatePassword respons: $state');
      if (state == true) {
        return true;
      } else {
        return false;
      }
    } else {
      return 'serverException';
    }
  } catch (e) {
    if (e is SocketException) {
      return 'SocketException';
    } else if(e is TimeoutException) {
      return 'TimeoutException';
    } else {
      return 'serverException';

    }
  }
}

//VerifyCode---------------------------------------------------------------------------
Future<String> getVerifyCode(String username, int code) async {
  Map<String, dynamic> data = {"username": username, 'code': '$code'};
  String url = "https://mobile.celebrityads.net/api/password/verify";
  try {
    final respons = await http.post(Uri.parse(url), body: data).timeout(const Duration(seconds: 8));
    if (respons.statusCode == 200) {
      var message = jsonDecode(respons.body)?["message"]['en'];
      print('message respons: $message');
      if (message == 'verified') {
        var token = jsonDecode(respons.body)?["data"]['token'];
        forgetToken = token;
        print('token respons: $forgetToken');
        return token;
      } else {
        return 'not verified';
      }
    } else {
      return 'serverException';
    }
  } catch (e) {
    if (e is SocketException) {
      return 'SocketException';
    } else if(e is TimeoutException) {
      return 'TimeoutException';
    } else {
      return 'serverException';

    }
  }
}

//ResetPassword---------------------------------------------------------------------------
getResetPassword(
    String username, String password, String newPassword, String token) async {
  Map<String, dynamic> data = {
    'username': username,
    'token': token,
    'password': password,
    'password_confirmation': newPassword
  };
  String url = "https://mobile.celebrityads.net/api/password/reset";
  try {
    final respons = await http.post(Uri.parse(url), body: data).timeout(const Duration(seconds: 8));
    if (respons.statusCode == 200) {
      var message = jsonDecode(respons.body)?["message"]['en'];
      print('ResetPassword respons: $message');
      if (message == 'The password reset success.') {
        return true;
      } else {
        return false;
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
