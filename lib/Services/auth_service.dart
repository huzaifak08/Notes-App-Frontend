import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:notes_app/Models/user_model.dart';
import 'package:notes_app/Provider/user_provider.dart';
import 'package:notes_app/Screens/home_screen.dart';
import 'package:notes_app/Screens/signin_screen.dart';
import 'package:notes_app/Utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _baseUrl = "http://192.168.10.20:2000/notes";

  // Register User:
  void signUpUser(
      {required BuildContext context,
      required String name,
      required String email,
      required String password}) async {
    try {
      UserModel user = UserModel(
        name: name,
        email: email,
        password: password,
      );

      final response = await http.post(
        Uri.parse("$_baseUrl/signup"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: user.toJson(),
      );

      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Account Created');
        },
      );
    } catch (e) {
      debugPrint(e.toString());
      showSnackBar(context, e.toString());
    }
  }

  // SignIn User:
  void signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      final navigator = Navigator.of(context);
      // final UserModel user = UserModel(name: email, password: password);

      final response = await http.post(Uri.parse("$_baseUrl/signin"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode({
            'email': email,
            'password': password,
          }));

      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () async {
          final sf = await SharedPreferences.getInstance();
          userProvider.setUser(response.body);
          await sf.setString(
              'x-auth-token', jsonDecode(response.body)['token']);

          navigator.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
              (route) => false);
        },
      );
    } catch (err) {
      debugPrint(err.toString());
      showSnackBar(context, err.toString());
    }
  }

  // Get User Data:
  void getUserData(BuildContext context) async {
    try {
      var userProvider = Provider.of<UserProvider>(context, listen: false);

      SharedPreferences sf = await SharedPreferences.getInstance();
      String? token = sf.getString('x-auth-token');

      if (token == null) {
        sf.setString('x-auth-token', '');
      }

      var tokenRes = await http.post(
        Uri.parse("$_baseUrl/tokenIsValid"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!,
        },
      );

      var response = jsonDecode(tokenRes.body);

      if (response == true) {
        final usrRes = await http.post(
          Uri.parse('$_baseUrl/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token,
          },
        );

        userProvider.setUser(usrRes.body);
      }
    } catch (err) {
      debugPrint(err.toString());
      // showSnackBar(context, err.toString());
    }
  }

  // Sign Out:
  void signOut(BuildContext context) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    sf.setString('x-auth_token', '');

    // ignore: use_build_context_synchronously
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const SignInScreen(),
        ),
        (route) => false);
  }
}
