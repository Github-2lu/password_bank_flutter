import 'package:flutter/material.dart';
import 'package:password_bank_flutter/main.dart';
import 'package:password_bank_flutter/widgets/log_in_form.dart';

class LogInScreen extends StatelessWidget {
  const LogInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Log In Screen",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: kColorScheme.onPrimary, fontWeight: FontWeight.bold),
        ),
      ),
      body: const LogInForm(),
    );
  }
}
