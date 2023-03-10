import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:matchdotdog/dogs/register_dog.dart';
import 'package:matchdotdog/auth/register.dart';
import 'package:matchdotdog/ui/main_background.dart';
import 'package:matchdotdog/dogs/my_dogs.dart';
import './fire_auth.dart';
import './validators.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();
  bool _isProcessing = false;
  final firestoreInstance = FirebaseFirestore.instance;
  late bool _dogExists;
  late Stream<QuerySnapshot> _myDogsStream;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          _focusEmail.unfocus();
          _focusPassword.unfocus();
        },
        child: Scaffold(
          body: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              border:
                  Border.all(color: Colors.white.withOpacity(0.2), width: 1.0),
              gradient: const LinearGradient(
                colors: [Colors.amber, Colors.pink],
                stops: [0.0, 1.0],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Icon(
                          Icons.pets_outlined,
                          size: 100,
                          color: Colors.black,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const SizedBox(
                            width: 270,
                            child: Text(
                              "Sign In",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22),
                            )),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: _emailTextController,
                                    focusNode: _focusEmail,
                                    validator: (value) =>
                                        Validator.validateEmail(
                                      email: value,
                                    ),
                                    decoration: InputDecoration(
                                      labelText: 'Email',
                                      fillColor: Colors.white,
                                      icon: Icon(Icons.email_rounded),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: _passwordTextController,
                                    focusNode: _focusPassword,
                                    obscureText: true,
                                    validator: (value) =>
                                        Validator.validatePassword(
                                      password: value,
                                    ),
                                    decoration: InputDecoration(
                                      labelText: 'Password',
                                      fillColor: Colors.white,
                                      icon: Icon(Icons.key),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24.0),
                                _isProcessing
                                    ? const CircularProgressIndicator()
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: OutlinedButton(
                                              onPressed: () async {
                                                _focusEmail.unfocus();
                                                _focusPassword.unfocus();

                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  setState(() {
                                                    _isProcessing = true;
                                                  });

                                                  User? user = await FireAuth
                                                      .signInUsingEmailPassword(
                                                    email: _emailTextController
                                                        .text,
                                                    password:
                                                        _passwordTextController
                                                            .text,
                                                  );

                                                  _myDogsStream =
                                                      FirebaseFirestore
                                                          .instance
                                                          .collection('dogs')
                                                          .where(
                                                              'owner',
                                                              isEqualTo:
                                                                  user?.uid)
                                                          .snapshots();

                                                  setState(() {
                                                    _isProcessing = false;
                                                  });

                                                  if (user != null) {
                                                    print(
                                                        "User is successfully logged in!");

                                                    if (_myDogsStream != null) {
                                                      Navigator.of(context)
                                                          .pushReplacement(
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      MyDogs(
                                                                          user:
                                                                              user)));
                                                    } else {
                                                      Navigator.of(context)
                                                          .pushReplacement(
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      RegisterDog(
                                                                          user:
                                                                              user)));
                                                    }

                                                    // Navigator.of(context)
                                                    //     .pushReplacement(
                                                    //   MaterialPageRoute(
                                                    //     builder: (context) =>
                                                    //         RegisterDog(
                                                    //       user: user,
                                                    //     ),
                                                    //   ),
                                                    // );
                                                  }
                                                }
                                              },
                                              child: const Text(
                                                'Sign In',
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 24.0),
                                          Expanded(
                                            child: OutlinedButton(
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        RegisterUser(),
                                                  ),
                                                );
                                              },
                                              child: const Text(
                                                'Register',
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
