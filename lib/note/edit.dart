// ignore_for_file: prefer_const_constructors, avoid_print, use_build_context_synchronously, body_might_complete_normally_nullable, unused_local_variable, non_constant_identifier_names

import 'package:app/auth/components/custombuttom.dart';
import 'package:app/categories/customfild.dart';
import 'package:app/note/view.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditNote extends StatefulWidget {
  final String notedocid;
  final String categoryid;
  final String value;
  const EditNote(
      {super.key,
      required this.notedocid,
      required this.categoryid,
      required this.value});

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController note = TextEditingController();

  bool isloading = false;

  EditNote() async {
    CollectionReference collectionnote = FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.categoryid)
        .collection("note");
    if (formstate.currentState!.validate()) {
      try {
        isloading = true;
        setState(() {});
        await collectionnote.doc(widget.notedocid).update({'note': note.text});

        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => NoteView(categoryid: widget.categoryid)),
        );
      } catch (error) {
        isloading = false;
        setState(() {});
        print("Failed to edit note: $error");
      }
    }
  }

  @override
  void initState() {
    note.text = widget.value;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    note.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Note"),
      ),
      body: Form(
          key: formstate,
          child: isloading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      child: CustomTextFormAdd(
                          hinttext: "Enter Your Note",
                          mycontroller: note,
                          validator: (val) {
                            if (val == "") {
                              return "Can't Be Empty";
                            }
                          }),
                    ),
                    CustomButtom(
                      title: "Save",
                      onPressed: () {
                        EditNote();
                      },
                    )
                  ],
                )),
    );
  }
}
