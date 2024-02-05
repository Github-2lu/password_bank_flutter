import 'package:flutter/material.dart';

class UserInfoChange extends StatefulWidget {
  final String username;
  final Function(String name, String password) onSaveEditedUser;

  const UserInfoChange(
      {super.key, required this.username, required this.onSaveEditedUser});
  @override
  State<UserInfoChange> createState() {
    return _UserInfoChangeState();
  }
}

class _UserInfoChangeState extends State<UserInfoChange> {
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();

  _saveEditedUser() {
    if (_nameController.text != "" && _passwordController.text != "") {
      widget.onSaveEditedUser(_nameController.text, _passwordController.text);
    }
    // if (_nameController.text != "") {
    //   widget.onSaveEditedUser(_nameController.text);
    // }
    Navigator.pop(context);
  }

  @override
  void initState() {
    _nameController.text = widget.username;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        title: const Text("Enter User Info"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(label: Text("User name")),
              controller: _nameController,
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              decoration: const InputDecoration(label: Text("User name")),
              controller: _passwordController,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel")),
                const SizedBox(
                  width: 5,
                ),
                ElevatedButton(
                    onPressed: _saveEditedUser, child: const Text("Save"))
              ],
            )
          ],
        ),
      ),
    );
  }
}
