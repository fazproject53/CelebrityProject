
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:flutter/material.dart';
import 'balance_object.dart';




class RadioWidgetDemo extends StatefulWidget {
  static BalanceObject? balanceObject;

  // ignore: use_key_in_widget_constructors
   const RadioWidgetDemo() : super();

  @override
  RadioWidgetDemoState createState() => RadioWidgetDemoState();
}

class RadioWidgetDemoState extends State<RadioWidgetDemo> {
  //
  List<User>? users;
  User? selectedUser;
  int? selectedRadio;
  int? selectedRadioTile;


  @override
  void initState() {
    super.initState();
    selectedRadio = 0;
    selectedRadioTile = 0;
    users = User.getUsers();
  }

  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
    });
  }

  setSelectedUser(User user) {
    setState(() {
      selectedUser = user;
    });
  }

  List<Widget> createRadioListUsers() {
    List<Widget> widgets = [];
    for (User user in users!) {
      widgets.add(
        RadioListTile(
          value: user,
          groupValue: selectedUser,
          title: Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Directionality(
                      textDirection: TextDirection.ltr,
                      child: text(context, user.firstName, 14, black)),

                ],
              )),
          selected: selectedUser == user,
          activeColor: purple,

          onChanged: (User? currentUser) {
            setSelectedUser(currentUser!);
            print("Current User ${currentUser.firstName}");
            print('Selected user ${selectedUser!.firstName}');
            print('user is ${user.firstName}');
            ///-----------------------------------------------------------------
            print('selectedRadio $selectedRadio');
            print('selectedRadioTile $selectedRadioTile');
          },
        ),
      );
    }
    ///this will be sent to the function to make sure celebrity choose one of credit card


    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Column(
          children: createRadioListUsers(),
        ),
      ],
    );
  }
}

///
class User {
  int userId;
  String firstName;

  User({
    required this.userId,
    required this.firstName,
  });

  static List<User> getUsers() {
    return <User>[
      User(userId: 1, firstName: "SA** **** **** **** **** 4958"),
      User(userId: 2, firstName: "SA** **** **** **** **** 4323"),
    ];
  }
}
