import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TheUser{

  String? name;
  String? id;
  String? image;
  String? email;
  String? phone;
  String? country;

  TheUser();
}


class tttt extends StatefulWidget {

  @override
  MyAppState createState() {
    return new MyAppState();
  }
}

class MyAppState extends State<tttt> {
  ImageProvider? backgroundImage;

  @override
  void didChangeDependencies() async{
    backgroundImage = AssetImage('assets/Background/login.png');
    await precacheImage(backgroundImage!,context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.light(),
      home: Scaffold(
        backgroundColor: Colors.red,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: backgroundImage!,
              fit: BoxFit.fill,
            ),
          ),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}