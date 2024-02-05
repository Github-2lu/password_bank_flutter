import 'package:flutter/material.dart';

class UserEditForm extends StatefulWidget {
  final String userName;
  final Function(String userName, String password) onSaveUser;
  final Function() onDeleteUser;

  const UserEditForm(
      {super.key,
      required this.userName,
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

  void setInitialValues() {
    _userNameController.text = widget.userName;
  }

  void _onSaveUser() {
    if (_userNameController.text != "" && _passwordController.text != "") {
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
