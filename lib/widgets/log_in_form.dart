import 'package:flutter/material.dart';
import 'package:password_bank_flutter/models/data_models.dart';
import 'package:password_bank_flutter/screens/passwords.dart';
import 'package:password_bank_flutter/screens/root_user.dart';
import 'package:password_bank_flutter/services/database_helper.dart';
import 'package:password_bank_flutter/services/hash_encr_dcr.dart';

class LogInForm extends StatefulWidget {
  const LogInForm({super.key});

  @override
  State<LogInForm> createState() {
    return _LogInFormState();
  }
}

class _LogInFormState extends State<LogInForm> {
  // final userDatabase = UserDatabaseHelper();
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();

  void replaceLogInScreen(UserInfo user) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (ctx) => PasswordsScreen(
          user: user,
          // originalUserPassword: _passwordController.text,
        ),
      ),
    );
  }

  void _showSnackBarMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void createUser() async {
    if (_userNameController.text == "" || _passwordController.text == "") {
      _showSnackBarMessage("name and password Field can't be empty");
      return;
    }

    final passwordHash = getPasswordHash(_passwordController.text);

    final allUsers = await UserDatabaseHelper.getAllUsers();
    if (allUsers != null) {
      for (final user in allUsers) {
        if (user.name == _userNameController.text &&
            user.password == passwordHash) {
          _showSnackBarMessage("User alredy Exist in Database.");
          return;
        }
      }
    }

    UserDatabaseHelper.addUser(
        UserInfo(name: _userNameController.text, password: passwordHash));
    _showSnackBarMessage("User added to Database");
  }

  void _showRootUserScreen() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (ctx) => const RootUserScreen()));
  }

  void logIn() async {
    if (_userNameController.text == "" || _passwordController.text == "") {
      _showSnackBarMessage("name and password Field can't be empty");
      return;
    }

    if (_userNameController.text == "root" &&
        _passwordController.text == "root") {
      _showRootUserScreen();
      return;
    }

    final passwordHash = getPasswordHash(_passwordController.text);
    UserInfo? user;
    final allUsers = await UserDatabaseHelper.getAllUsers();
    if (allUsers != null) {
      for (final avialableUser in allUsers) {
        if (avialableUser.name == _userNameController.text &&
            avialableUser.password == passwordHash) {
          user = avialableUser;
          break;
        }
      }
    }

    // print('id : ${allUsers![0].id} users: ${allUsers[0].name} password: ${allUsers[0].password}');

    if (user == null) {
      _showSnackBarMessage("User not in the Database.");
      return;
    }

    replaceLogInScreen(user);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              // decoration: Theme.of(context).inputDecorationTheme.copyWith(),
              decoration: const InputDecoration(label: Text("User name")),
              controller: _userNameController,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              decoration: const InputDecoration(label: Text("Password")),
              controller: _passwordController,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(onPressed: logIn, child: const Text("Log In")),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                  onPressed: createUser, child: const Text("Create User"))
            ],
          ),
        ],
      ),
    );
  }
}
