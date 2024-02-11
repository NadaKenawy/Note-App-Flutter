// ignore_for_file: prefer_const_constructors, avoid_print, use_build_context_synchronously, body_might_complete_normally_nullable, unused_local_variable, non_constant_identifier_names

import 'dart:io';

import 'package:app/auth/components/custombuttom.dart';
import 'package:app/categories/customfild.dart';
import 'package:app/note/view.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class AddNote extends StatefulWidget {
  final String docid;
  const AddNote({super.key, required this.docid});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController note = TextEditingController();

  bool isloading = false;
  File? file;
  String? url;

  AddNote(context) async {
    CollectionReference collectionnote = FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.docid)
        .collection("note");
    if (formstate.currentState!.validate()) {
      try {
        isloading = true;
        setState(() {});
        DocumentReference response =
            await collectionnote.add({'note': note.text, "url": url ?? "none"});

        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => NoteView(categoryid: widget.docid)),
        );
      } catch (error) {
        isloading = false;
        setState(() {});
        print("Failed to add note: $error");
      }
    }
  }

  getImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      file = File(photo!.path);
      var imgname = basename(photo!.path);
      var refStorge = FirebaseStorage.instance.ref("images/$imgname");
      await refStorge.putFile(file!);
      url = await refStorge.getDownloadURL();
    }
    setState(() {});
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
        title: Text("Add Note"),
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
                      title: "Add",
                      onPressed: () {
                        AddNote(context);
                      },
                    ),
                    CustomButtomUpload(
                      title: "Upload Image",
                      isSelected: url == null ? false : true,
                      onPressed: () async {
                        await getImage();
                      },
                    ),
                  ],
                )),
    );
  }
}
