// ignore_for_file: avoid_print, duplicate_ignore

import 'package:app/auth/Login.dart';
import 'package:app/auth/Signup.dart';
import 'package:app/HomePage.dart';
import 'package:app/categories/add.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("===================BackGround Message");
  print("Title : ${message.notification!.title}");
  print("Body : ${message.notification!.body}");
  print(message.data);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("============================== Test click");
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        print("===================Foreground Message");
        print("Title : ${message.notification!.title}");
        print("Body : ${message.notification!.body}");
        print(message.data);
      }
    });

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('===================== User is currently signed out!');
      } else {
        // ignore: avoid_print
        print('===================== User is signed in!');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          appBarTheme: AppBarTheme(
              backgroundColor: Colors.grey[50],
              titleTextStyle: const TextStyle(
                  color: Colors.blue,
                  fontSize: 19,
                  fontWeight: FontWeight.bold),
              iconTheme: const IconThemeData(color: Colors.blue))),
      debugShowCheckedModeBanner: false,
      home: FirebaseAuth.instance.currentUser != null &&
              FirebaseAuth.instance.currentUser!.emailVerified
          ? const HomePage()
          : const Login(),
      routes: {
        "Signup": (context) => const Singup(),
        "Login": (context) => const Login(),
        "HomePage": (context) => const HomePage(),
        "add": (context) => const AddCategory(),
      },
    );
  }
}
