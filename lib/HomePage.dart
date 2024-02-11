// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, annotate_overrides, unused_import, file_names

import 'package:app/categories/edit.dart';
import 'package:app/note/view.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List data = [];

  bool isloading = true;

  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("categories")
        .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    data.addAll(querySnapshot.docs);
    isloading = false;
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed("add");
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("HomePage"),
        actions: [
          IconButton(
              onPressed: () async {
                GoogleSignIn googleSignIn = GoogleSignIn();
                googleSignIn.disconnect();
                await FirebaseAuth.instance.signOut();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("Login", (route) => false);
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: isloading == true
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              itemCount: data.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisExtent: 160),
              itemBuilder: (context, i) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            NoteView(categoryid: data[i].id)));
                  },
                  onLongPress: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.warning,
                      animType: AnimType.rightSlide,
                      title: 'Choose What You Want',
                      btnCancelText: "Delete",
                      btnOkText: "Edit",
                      btnOkOnPress: () async {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => editCategory(
                                docid: data[i].id, oldname: data[i]['name'])));
                      },
                      btnCancelOnPress: () async {
                        await FirebaseFirestore.instance
                            .collection("categories")
                            .doc(data[i].id)
                            .delete();
                        Navigator.of(context).pushReplacementNamed("HomePage");
                      },
                    ).show();
                  },
                  child: Card(
                      child: Container(
                    padding: const EdgeInsets.all(15),
                    child: Column(children: [
                      Image.asset(
                        "images/pngaaa.com-3986187.png",
                        height: 100,
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 5)),
                      Text(
                        "${data[i]['name']}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ]),
                  )),
                );
              }),
    );
  }
}
