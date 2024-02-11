// ignore_for_file: use_build_context_synchronously, avoid_print, prefer_const_constructors, body_might_complete_normally_nullable, unnecessary_nullable_for_final_variable_declarations, file_names

import 'package:app/auth/components/custombuttom.dart';
import 'package:app/auth/components/customlogo.dart';
import 'package:app/auth/components/textformfild.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  bool isloading = false;

  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    isloading = true;
    setState(() {});
    if (googleUser == null) {
      return ();
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.of(context).pushNamedAndRemoveUntil("HomePage", (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isloading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
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
                          "Login",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          height: 10,
                        ),
                        const Text(
                          "Login To Continue Using The App ",
                          style: TextStyle(color: Colors.grey),
                        ),
                        Container(
                          height: 20,
                        ),
                        const Text("Email",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold)),
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
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold)),
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
                        InkWell(
                          onTap: () async {
                            if (email.text == "") {
                              isloading = false;
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'Error',
                                desc: 'Please Write Your Email',
                                btnCancelOnPress: () {},
                                btnOkOnPress: () {},
                              ).show();

                              setState(() {});
                              return;
                            }
                            try {
                              await FirebaseAuth.instance
                                  .sendPasswordResetEmail(email: email.text);
                              isloading = false;
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.success,
                                animType: AnimType.rightSlide,
                                title: 'Success',
                                desc: 'We Send a New Password To Your Email',
                                btnCancelOnPress: () {},
                                btnOkOnPress: () {},
                              ).show();

                              setState(() {});
                            } catch (e) {
                              isloading = false;
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'Error',
                                desc:
                                    'Please Make Sure You Enter The Correct Email And Try Again',
                                btnCancelOnPress: () {},
                                btnOkOnPress: () {},
                              ).show();

                              setState(() {});
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(top: 10, bottom: 20),
                            alignment: Alignment.topRight,
                            child: const Text(
                              "Forget Password?",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 98, 98, 98)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomButtom(
                    title: 'Login',
                    onPressed: () async {
                      if (formstate.currentState!.validate()) {
                        try {
                          isloading = true;
                          setState(() {});
                          final credential = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                            email: email.text,
                            password: password.text,
                          );
                          isloading = false;
                          setState(() {});
                          if (credential.user!.emailVerified) {
                            Navigator.of(context)
                                .pushReplacementNamed("HomePage");
                          } else {
                            isloading = false;
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.rightSlide,
                              title: 'Error',
                              desc: 'Please Verfied Email',
                              btnCancelOnPress: () {},
                              btnOkOnPress: () {},
                            ).show();

                            setState(() {});
                          }
                        } catch (e) {
                          isloading = false;
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            title: 'Error',
                            desc: 'Wrong email or password',
                            btnCancelOnPress: () {},
                            btnOkOnPress: () {},
                          ).show();

                          setState(() {});
                        }
                      } else {
                        print("Not Valid");
                      }
                    },
                  ),

                  // CustomButtom(
                  //   title: 'Login',
                  //   onPressed: () async {
                  //     if (formstate.currentState!.validate()) {
                  //       try {
                  //         final credential =
                  //             await FirebaseAuth.instance.signInWithEmailAndPassword(
                  //           email: email.text,
                  //           password: password.text,
                  //         );
                  //         Navigator.of(context).pushReplacementNamed("HomePage");
                  //       } on FirebaseAuthException catch (e) {
                  //         if (e.code == 'user-not-found') {
                  //           print('No user found for that email.');
                  //           AwesomeDialog(
                  //             context: context,
                  //             dialogType: DialogType.error,
                  //             animType: AnimType.rightSlide,
                  //             title: 'Error..',
                  //             desc: 'No user found for that email.',
                  //             btnCancelOnPress: () {},
                  //             btnOkOnPress: () {},
                  //           ).show();
                  //         } else if (e.code == 'wrong-password') {
                  //           print('Wrong password provided for that user.');
                  //           AwesomeDialog(
                  //             context: context,
                  //             dialogType: DialogType.error,
                  //             animType: AnimType.rightSlide,
                  //             title: 'Error..',
                  //             desc: 'Wrong password provided for that user.',
                  //             btnCancelOnPress: () {},
                  //             btnOkOnPress: () {},
                  //           ).show();
                  //         }
                  //       } catch (e) {
                  //         print(e);
                  //       }
                  //     } else {
                  //       print("Not Valid");
                  //     }
                  //   },
                  // ),
                  Container(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(bottom: 20),
                    child: const Text.rich(
                      TextSpan(children: [
                        TextSpan(
                            text: "______________",
                            style: TextStyle(
                                fontSize: 17,
                                color: Color.fromARGB(255, 220, 220, 220))),
                        TextSpan(
                            text: " Or Login With ",
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 17)),
                        TextSpan(
                            text: "______________",
                            style: TextStyle(
                                fontSize: 17,
                                color: Color.fromARGB(255, 220, 220, 220))),
                      ]),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MaterialButton(
                        height: 80,
                        minWidth: 110,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        color: const Color.fromARGB(255, 227, 227, 227),
                        onPressed: () {
                          signInWithGoogle();
                        },
                        child: Image.asset(
                          "images/google.png",
                          height: 48,
                        ),
                      ),
                      MaterialButton(
                        height: 80,
                        minWidth: 110,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        color: const Color.fromARGB(255, 227, 227, 227),
                        onPressed: () {},
                        child: Image.asset(
                          "images/facebook.png",
                          height: 40,
                        ),
                      ),
                      MaterialButton(
                        height: 80,
                        minWidth: 110,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        color: const Color.fromARGB(255, 227, 227, 227),
                        onPressed: () {},
                        child: Image.asset(
                          "images/apple.png",
                          height: 60,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 60,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed("Signup");
                    },
                    child: const Center(
                      child: Text.rich(TextSpan(children: [
                        TextSpan(
                            text: "Don't Have Account? ",
                            style: TextStyle(fontSize: 17)),
                        TextSpan(
                            text: "Register",
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
