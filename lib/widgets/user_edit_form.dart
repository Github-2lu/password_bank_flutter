import 'package:flutter/material.dart';
import 'package:password_bank_flutter/models/data_models.dart';

class UserEditForm extends StatefulWidget {
  final UserInfo user;
  final Function(String userName, String password) onSaveUser;
  final Function() onDeleteUser;

  const UserEditForm(
      {super.key,
      required this.user,
      required this.onSaveUser,
      required this.onDeleteUser});

  @override
  State<UserEditForm> createState() {
    return _UserEditFormState();
  }
}

class _UserEditFormState extends State<UserEditForm> {
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();

  void setInitialValues() {
    _userNameController.text = widget.user.name;
    _emailController.text = widget.user.emailId;
  }

  void _onSaveUser() {
    if (_userNameController.text != "" &&
        _passwordController.text != "" &&
        _emailController.text != "") {
      widget.onSaveUser(_userNameController.text, _passwordController.text);
      Navigator.pop(context);
    }
  }

  void _onDeleteUser() {
    widget.onDeleteUser();
    Navigator.pop(context);
  }

  @override
  void initState() {
    setInitialValues();
    super.initState();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyBoardSpace = MediaQuery.of(context).viewInsets.bottom;
    return SizedBox(
      height: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, keyBoardSpace + 16),
          child: Column(
            children: [
              TextFormField(
                controller: _userNameController,
                decoration: const InputDecoration(
                  label: Text("User Name"),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(label: Text("Password")),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(label: Text("Email")),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: _onSaveUser,
                    child: const Text("Save"),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _onDeleteUser,
                    child: const Text("Delete"),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
