import 'package:flutter/material.dart';
import 'package:password_bank_flutter/models/data_models.dart';
import 'package:password_bank_flutter/screens/forget_password.dart';
import 'package:password_bank_flutter/screens/passwords.dart';
import 'package:password_bank_flutter/screens/root_user.dart';
import 'package:password_bank_flutter/services/database_helper.dart';
import 'package:password_bank_flutter/services/hash_encr_dcr.dart';
import 'package:password_bank_flutter/widgets/create_user.dart';

class LogInForm extends StatefulWidget {
  const LogInForm({super.key});

  @override
  State<LogInForm> createState() {
    return _LogInFormState();
  }
}

class _LogInFormState extends State<LogInForm> {
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();

  void replaceLogInScreen(UserInfo user) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (ctx) => PasswordsScreen(
          user: user,
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
          ElevatedButton(onPressed: logIn, child: const Text("Log In")),
          Row(
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) => const ForgetPassword()));
                  },
                  child: const Text("Forget Password")),
              const Spacer(),
              TextButton(
                  onPressed: () {
                    showModalBottomSheet(
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        context: context,
                        useSafeArea: true,
                        isScrollControlled: true,
                        builder: (ctx) => const CreateUser());
                  },
                  child: const Text("Create new User"))
            ],
          ),
        ],
      ),
    );
  }
}
