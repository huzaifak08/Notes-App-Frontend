import 'package:flutter/material.dart';
import 'package:notes_app/Screens/signup_screen.dart';
import 'package:notes_app/Services/auth_service.dart';
import 'package:notes_app/Utils/utils.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _fromKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(title: const Text('Login User'), centerTitle: true),
      body: Form(
        key: _fromKey,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.02, vertical: height * 0.01),
          child: Column(
            children: [
              SizedBox(height: height * 0.03),
              TextFormField(
                controller: emailController,
                decoration: textInputDecoration.copyWith(hintText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Email Can't be Empty";
                  }
                  return null;
                },
              ),
              SizedBox(height: height * 0.02),
              TextFormField(
                controller: passwordController,
                decoration: textInputDecoration.copyWith(hintText: 'Password'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Password Can't be Empty";
                  }
                  return null;
                },
              ),
              SizedBox(height: height * 0.03),
              ElevatedButton(
                onPressed: () {
                  if (_fromKey.currentState!.validate()) {
                    AuthService().signInUser(
                        context: context,
                        email: emailController.text,
                        password: passwordController.text);
                  }
                },
                child: const Text('Sign In'),
              ),
              SizedBox(height: height * 0.03),
              Row(
                children: [
                  const Text('Do not have an account? '),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignupScreen()));
                    },
                    child: const Text('Clich here'),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
