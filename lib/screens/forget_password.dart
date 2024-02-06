import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:password_bank_flutter/models/data_models.dart';
import 'dart:math';
import 'package:password_bank_flutter/keys/master_key.dart';
import 'package:password_bank_flutter/services/database_helper.dart';
import 'package:password_bank_flutter/widgets/change_password.dart';
import 'package:password_bank_flutter/widgets/otp_form.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() {
    return _ForgetPasswordState();
  }
}

class _ForgetPasswordState extends State<ForgetPassword> {
  bool isUserInDB = false;
  bool isMailSend = false;
  bool isOtpCorrect = false;
  final _userNameController = TextEditingController();
  final _userEmailController = TextEditingController();
  int? otp;
  UserInfo? user;

  void _showSnackBarMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void sendEmail() async {
    const String username = serverEmail;
    const String password = serverEmailPassword;
    final smtpServer = gmail(username, password);
    Random random = Random();
    otp = random.nextInt(9999);

    final message = Message()
      ..from = Address(username, _userNameController.text)
      ..recipients.add(_userEmailController.text)
      ..subject = "Password Change"
      ..text = "OTP: $otp";
    final sendStatus = send(message, smtpServer);
    sendStatus.whenComplete(() {
      setState(() {
        isMailSend = true;
      });
    });
  }

  Future<UserInfo?> findUser() async {
    final allUsers = await UserDatabaseHelper.getAllUsers();
    if (allUsers != null) {
      for (final user in allUsers) {
        if (user.name == _userNameController.text &&
            user.emailId == _userEmailController.text) {
          return user;
        }
      }
    }
    return null;
  }

  void userEntered() async {
    if (_userNameController.text == "" || _userEmailController.text == "") {
      _showSnackBarMessage("Name and Email field can't be empty");
      return;
    }

    user = await findUser();
    if (user == null) {
      _showSnackBarMessage("No User found");
      return;
    }
    setState(() {
      isUserInDB = true;
    });
    sendEmail();
  }

  void _correctOtp() {
    setState(() {
      isOtpCorrect = true;
    });
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _userEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent;
    mainContent = Column(children: [
      const SizedBox(
        height: 15,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: TextFormField(
          decoration: const InputDecoration(label: Text("User name")),
          controller: _userNameController,
        ),
      ),
      const SizedBox(
        height: 15,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: TextFormField(
          decoration: const InputDecoration(label: Text("Email")),
          controller: _userEmailController,
        ),
      ),
      const SizedBox(
        height: 15,
      ),
      ElevatedButton(onPressed: userEntered, child: const Text("Next"))
    ]);

    if (isUserInDB && !isMailSend) {
      mainContent = const Center(
        child: CircularProgressIndicator(),
      );
    } else if (isMailSend && !isOtpCorrect) {
      mainContent = OtpForm(realOtp: otp!, onCorrectOtp: _correctOtp);
    } else if (isOtpCorrect) {
      mainContent = ChangePassword(user: user!);
    }

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
          "Forget Password",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: mainContent,
    );
  }
}
