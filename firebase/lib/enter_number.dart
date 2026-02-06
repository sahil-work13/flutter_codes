import 'package:firebase/verify_otp.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EnterNumber extends StatefulWidget {
  const EnterNumber({super.key});

  @override
  State<EnterNumber> createState() => _PhoneInputPageState();
}

class _PhoneInputPageState extends State<EnterNumber> {
  final TextEditingController phoneController = TextEditingController();
  bool loading = false;

  Future<void> sendOtp() async {
    setState(() => loading = true);

    try {
      final confirmationResult =
      await FirebaseAuth.instance.signInWithPhoneNumber(
        phoneController.text,
      );

      setState(() => loading = false);

      // 👉 Navigate to OTP page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OtpVerifyPage(
            confirmationResult: confirmationResult,
          ),
        ),
      );
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Enter Phone Number")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                hintText: "+91XXXXXXXXXX",
                labelText: "Phone Number",
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 24),
            loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: sendOtp,
              child: const Text("Send OTP"),
            ),
          ],
        ),
      ),
    );
  }
}
