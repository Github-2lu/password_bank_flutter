import 'package:flutter/material.dart';

class OtpForm extends StatefulWidget {
  final int realOtp;
  final Function() onCorrectOtp;
  const OtpForm({super.key, required this.realOtp, required this.onCorrectOtp});
  @override
  State<OtpForm> createState() {
    return _OtpFormState();
  }
}

class _OtpFormState extends State<OtpForm> {
  final _otpController = TextEditingController();

  void _showSnackBarMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _checkOtp() {
    if (_otpController.text != widget.realOtp.toString()) {
      _showSnackBarMessage("OTP didn't match");
      return;
    }
    widget.onCorrectOtp();
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        const Text("An OTP has been sent to your email account"),
        const SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextFormField(
            controller: _otpController,
            decoration: const InputDecoration(label: Text("OTP")),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        ElevatedButton(onPressed: _checkOtp, child: const Text("Next"))
      ],
    );
  }
}
