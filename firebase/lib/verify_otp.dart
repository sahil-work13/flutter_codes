import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';

class OtpVerifyPage extends StatefulWidget {
  final ConfirmationResult confirmationResult;

  const OtpVerifyPage({
    super.key,
    required this.confirmationResult,
  });

  @override
  State<OtpVerifyPage> createState() => _OtpVerifyPageState();
}

class _OtpVerifyPageState extends State<OtpVerifyPage> {
  final TextEditingController otpController = TextEditingController();
  bool loading = false;

  Future<void> verifyOtp() async {
    setState(() => loading = true);

    try {
      await widget.confirmationResult
          .confirm(otpController.text);

      setState(() => loading = false);

      // 👉 Navigate to Home & remove previous pages
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MyHomePage(title: '',)),
            (route) => false,
      );
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid OTP")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify OTP")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: otpController,
              decoration: const InputDecoration(
                labelText: "Enter OTP",
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: verifyOtp,
              child: const Text("Verify OTP"),
            ),
          ],
        ),
      ),
    );
  }
}
