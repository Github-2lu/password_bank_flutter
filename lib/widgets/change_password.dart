import 'package:flutter/material.dart';
import 'package:password_bank_flutter/models/data_models.dart';
import 'package:password_bank_flutter/services/database_helper.dart';
import 'package:password_bank_flutter/services/hash_encr_dcr.dart';

class ChangePassword extends StatefulWidget {
  final UserInfo user;
  const ChangePassword({super.key, required this.user});
  @override
  State<ChangePassword> createState() {
    return _ChangePasswordState();
  }
}

class _ChangePasswordState extends State<ChangePassword> {
  final _passwordController = TextEditingController();

  void _showSnackBarMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _savePassword() {
    if (_passwordController.text == "") {
      _showSnackBarMessage("Password Field can't be Empty.");
      return;
    }
    widget.user.password = getPasswordHash(_passwordController.text);
    UserDatabaseHelper.updateUser(widget.user);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(
        height: 15,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: TextFormField(
          controller: _passwordController,
          decoration: const InputDecoration(label: Text("New Password")),
        ),
      ),
      const SizedBox(
        height: 15,
      ),
      Row(
        children: [
          const Spacer(),
          ElevatedButton(onPressed: _savePassword, child: const Text("Save"))
        ],
      )
    ]);
  }
}
