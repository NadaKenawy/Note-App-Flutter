// ignore_for_file: use_build_context_synchronously, annotate_overrides, unused_import, prefer_const_constructors

import 'package:app/categories/edit.dart';
import 'package:app/note/add.dart';
import 'package:app/note/edit.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class NoteView extends StatefulWidget {
  final String categoryid;
  const NoteView({super.key, required this.categoryid});
  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  List data = [];

  bool isloading = true;

  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("categories")
        .doc(widget.categoryid)
        .collection("note")
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
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddNote(docid: widget.categoryid)));
          },
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          title: const Text("NoteView"),
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
        body: WillPopScope(
          child: isloading == true
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, i) {
                    return InkWell(
                      onLongPress: () {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.warning,
                          animType: AnimType.rightSlide,
                          title: "Warning",
                          desc: 'Are You Sure To Delete It?',
                          btnOkOnPress: () async {
                            await FirebaseFirestore.instance
                                .collection("categories")
                                .doc(widget.categoryid)
                                .collection("note")
                                .doc(data[i].id)
                                .delete();
                            if (data[i]['url'] != "none") {
                              FirebaseStorage.instance
                                  .refFromURL(data[i]['url'])
                                  .delete();
                            }
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    NoteView(categoryid: widget.categoryid)));
                          },
                          btnCancelOnPress: () async {},
                        ).show();
                      },
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => EditNote(
                                notedocid: data[i].id,
                                categoryid: widget.categoryid,
                                value: data[i]['note'])));
                      },
                      child: Card(
                          child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(children: [
                          Text(
                            "${data[i]['note']}",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          Padding(padding: EdgeInsets.all(10)),
                          if (data[i]['url'] != "none")
                            Image.network(
                              data[i]['url'],
                              height: 100,
                            )
                        ]),
                      )),
                    );
                  }),
          onWillPop: () {
            Navigator.of(context)
                .pushNamedAndRemoveUntil("HomePage", (route) => false);
            return Future.value(false);
          },
        ));
  }
}
