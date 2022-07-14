
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../Models/Methods/method.dart';
import '../../Models/Variables/Variables.dart';

class RadioWidgetUser extends StatefulWidget {
  const RadioWidgetUser() : super();

  @override
  _RadioWidgetUserState createState() => _RadioWidgetUserState();
}

class _RadioWidgetUserState extends State<RadioWidgetUser> {
  final TextEditingController cvvCode1 = TextEditingController();

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

                  ///Text Filed
                  Visibility(
                    visible: selectedUser == user,
                    child: Column(
                      children: [
                        textFieldSmall(
                          context,
                          'رمز التحقق ' 'CVV',
                          12,
                          false,
                          cvvCode1,
                              (String? value) {
                            /// Validation text field
                            if (value == null || value.isEmpty) {
                              return 'حقل اجباري';
                            }
                            if (value.startsWith('0')) {
                              return 'يجب ان لا يبدا بصفر';
                            }
                            if (value.length > 3) {
                              return 'no';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )),
          onChanged: (User? currentUser) {
            print("Current User ${currentUser?.firstName}");
            setSelectedUser(currentUser!);
          },
          selected:  true,
          activeColor: purple,
        ),
      );
    }
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

///user class
class User {
  int userId;
  String firstName;

  User({
    required this.userId,
    required this.firstName,
  });

  static List<User> getUsers() {
    return <User>[
      User(userId: 1, firstName: "**** **** **** 4958"),
      User(userId: 2, firstName: "**** **** **** 4323"),
    ];
  }
}
