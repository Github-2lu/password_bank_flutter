import 'package:flutter/material.dart';
import 'package:password_bank_flutter/models/data_models.dart';
import 'package:password_bank_flutter/services/database_helper.dart';
import 'package:password_bank_flutter/services/hash_encr_dcr.dart';

class CreateUser extends StatefulWidget {
  const CreateUser({super.key});

  @override
  State<CreateUser> createState() {
    return _CreateUserState();
  }
}

class _CreateUserState extends State<CreateUser> {
  final _userNameController = TextEditingController();
  final _userPasswordController = TextEditingController();
  final _userEmailController = TextEditingController();

  void _showSnackBarMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  Future<bool> _saveUser() async {
    if (_userNameController.text == "" ||
        _userPasswordController.text == "" ||
        _userPasswordController.text == "") {
      _showSnackBarMessage("All Fields are required.");
      return false;
    }

    final passwordHash = getPasswordHash(_userPasswordController.text);

    final allUsers = await UserDatabaseHelper.getAllUsers();
    if (allUsers != null) {
      for (final user in allUsers) {
        if (user.name == _userNameController.text &&
            user.password == passwordHash) {
          _showSnackBarMessage("User already Exist in Database");
          return false;
        }
      }
    }
    UserDatabaseHelper.addUser(UserInfo(
        name: _userNameController.text,
        password: getPasswordHash(_userPasswordController.text),
        emailId: _userEmailController.text));
    _showSnackBarMessage("User added to Database");
    return true;
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _userEmailController.dispose();
    _userPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyBoardSpace = MediaQuery.of(context).viewInsets.bottom;
    return SizedBox(
      height: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,
            keyBoardSpace + 16,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  controller: _userNameController,
                  decoration: const InputDecoration(
                    label: Text("User Name"),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  controller: _userPasswordController,
                  decoration: const InputDecoration(
                    label: Text("Password"),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  controller: _userEmailController,
                  decoration: const InputDecoration(
                    label: Text("User Email"),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel")),
                  const Spacer(),
                  ElevatedButton(
                      onPressed: () {
                        _saveUser().then((value) {
                          if (value) {
                            Navigator.pop(context);
                          }
                        });
                      },
                      child: const Text("Save"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
