// ignore_for_file: use_build_context_synchronously, avoid_print, prefer_const_constructors, file_names, unused_local_variable, body_might_complete_normally_nullable

import 'package:app/auth/components/custombuttom.dart';
import 'package:app/auth/components/customlogo.dart';
import 'package:app/auth/components/textformfild.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Singup extends StatefulWidget {
  const Singup({super.key});
  @override
  State<Singup> createState() => _SingupState();
}

class _SingupState extends State<Singup> {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Form(
              key: formstate,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 50,
                  ),
                  CustomLogo(),
                  Container(
                    height: 20,
                  ),
                  const Text(
                    "Register",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    height: 10,
                  ),
                  const Text(
                    "Register To Continue Using The App ",
                    style: TextStyle(color: Colors.grey),
                  ),
                  Container(
                    height: 20,
                  ),
                  const Text("Username",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  Container(
                    height: 10,
                  ),
                  CustomTextForm(
                    hinttext: "Enter your username",
                    mycontroller: username,
                    validator: (val) {
                      if (val == "") {
                        return "Can't be empty";
                      }
                    },
                  ),
                  Container(
                    height: 10,
                  ),
                  const Text("Email",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  Container(
                    height: 10,
                  ),
                  CustomTextForm(
                    hinttext: "Enter your email",
                    mycontroller: email,
                    validator: (val) {
                      if (val == "") {
                        return "Can't be empty";
                      }
                    },
                  ),
                  Container(
                    height: 10,
                  ),
                  const Text("Password",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  Container(
                    height: 10,
                  ),
                  CustomTextForm(
                    hinttext: "Enter your password",
                    mycontroller: password,
                    validator: (val) {
                      if (val == "") {
                        return "Can't be empty";
                      }
                    },
                  ),
                  Container(
                    height: 10,
                  ),
                  const Text("Confirm Password",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  Container(
                    height: 10,
                  ),
                  CustomTextForm(
                    hinttext: "Enter confirm password",
                    mycontroller: password,
                    validator: (val) {
                      if (val == "") {
                        return "Can't be empty";
                      }
                    },
                  ),
                  Container(
                    height: 30,
                  ),
                ],
              ),
            ),
            CustomButtom(
              title: 'Register',
              onPressed: () async {
                if (formstate.currentState!.validate()) {
                  try {
                    final credential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                      email: email.text,
                      password: password.text,
                    );
                    FirebaseAuth.instance.currentUser!.sendEmailVerification();
                    Navigator.of(context).pushReplacementNamed("Login");
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      print('The password provided is too weak.');
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: 'Error..',
                        desc: 'The password provided is too weak.',
                        btnCancelOnPress: () {},
                        btnOkOnPress: () {},
                      ).show();
                    } else if (e.code == 'email-already-in-use') {
                      print('The account already exists for that email.');
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: 'Error..',
                        desc: 'The account already exists for that email.',
                        btnCancelOnPress: () {},
                        btnOkOnPress: () {},
                      ).show();
                    }
                  } catch (e) {
                    print(e);
                  }
                } else {
                  print("Not Valid");
                }
              },
            ),
            Container(
              height: 20,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed("Login");
              },
              child: const Center(
                child: Text.rich(TextSpan(children: [
                  TextSpan(
                      text: "Have an Account? ",
                      style: TextStyle(fontSize: 17)),
                  TextSpan(
                      text: "Login",
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 17))
                ])),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
