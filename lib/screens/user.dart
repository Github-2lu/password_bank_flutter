import 'package:flutter/material.dart';
import 'package:password_bank_flutter/models/data_models.dart';
import 'package:password_bank_flutter/services/database_helper.dart';

import 'package:password_bank_flutter/widgets/user_info_change.dart';

class UserScreen extends StatefulWidget {
  final UserInfo user;
  final Function(String name, String password) onSaveEditedUser;
  final Function() onDeleteUser;

  const UserScreen(
      {super.key,
      required this.user,
      required this.onSaveEditedUser,
      required this.onDeleteUser});
  @override
  State<UserScreen> createState() {
    return _UserScreenState();
  }
}

class _UserScreenState extends State<UserScreen> {
  final userDB = UserDatabaseHelper();
  final passwordDB = PasswordDatabaseHelper();
  late final UserInfo currentUser;

  void _saveEditedUser(String name, String password) {
    setState(() {
      currentUser.name = name;
    });
    widget.onSaveEditedUser(name, password);
  }

  void _showUserEditForm() {
    showDialog(
        context: context,
        builder: (ctx) => UserInfoChange(
              username: currentUser.name,
              onSaveEditedUser: _saveEditedUser,
            ));
  }

  void onDeleteUser() {
    Navigator.pop(context);
    widget.onDeleteUser();
  }

  @override
  void initState() {
    currentUser = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        title: Text(
          "User Info",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimary),
        ),
        actions: [
          IconButton(
              onPressed: _showUserEditForm,
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).colorScheme.onPrimary,
              )),
          IconButton(
              onPressed: onDeleteUser,
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).colorScheme.onPrimary,
              ))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "User name: ${currentUser.name}",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
