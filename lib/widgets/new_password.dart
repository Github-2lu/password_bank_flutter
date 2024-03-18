import 'package:flutter/material.dart';

// This widget is used for both new password addition and edit existing password info

class NewPassword extends StatefulWidget {
  final void Function(
          String title, String password, String about, bool isNewPassword)
      onSavePassword;
  final Map<String, String>? oldPasswordInfo;
  final void Function() onDeletePassword;

  const NewPassword(
      {super.key,
      required this.onSavePassword,
      required this.onDeletePassword,
      this.oldPasswordInfo});

  @override
  State<NewPassword> createState() {
    return _NewPasswordState();
  }
}

class _NewPasswordState extends State<NewPassword> {
  final _titleController = TextEditingController();
  final _passwordController = TextEditingController();
  final _aboutController = TextEditingController();
  bool _isNewPassword = true;

  void setInitialValues() {
    if (widget.oldPasswordInfo != null) {
      _titleController.text = widget.oldPasswordInfo!["title"]!;
      _passwordController.text = widget.oldPasswordInfo!["password"]!;
      _aboutController.text = widget.oldPasswordInfo!["about"]!;

      _isNewPassword = false;
    }
  }

  void _onSaveNewPassword() {
    if (_titleController.text != "" && _passwordController.text != "") {
      widget.onSavePassword(_titleController.text, _passwordController.text,
          _aboutController.text, _isNewPassword);
      Navigator.pop(context);
    }
  }

  void _onDeletePassword() {
    if (!_isNewPassword) {
      widget.onDeletePassword();
    }
    Navigator.pop(context);
  }

  @override
  void initState() {
    setInitialValues();
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _passwordController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyBoardSpace = MediaQuery.of(context).viewInsets.bottom;

    // This is used to show delete option only when we are adding new password
    List<Widget> buttons = [
      ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel")),
      const SizedBox(
        width: 10,
      ),
      ElevatedButton(
        onPressed: _onSaveNewPassword,
        child: const Text("Save"),
      ),
      const Spacer(),
    ];

    if (!_isNewPassword) {
      buttons.add(ElevatedButton(
          onPressed: _onDeletePassword, child: const Text("Delete")));
    }

    return SizedBox(
      height: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, keyBoardSpace + 16),
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(label: Text("Enter Title")),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _passwordController,
                decoration:
                    const InputDecoration(label: Text("Enter Password")),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _aboutController,
                decoration: const InputDecoration(label: Text("Enter About")),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: buttons,
              )
            ],
          ),
        ),
      ),
    );
  }
}
