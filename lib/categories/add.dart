// ignore_for_file: prefer_const_constructors, avoid_print, use_build_context_synchronously, body_might_complete_normally_nullable, unused_local_variable

import 'package:app/auth/components/custombuttom.dart';
import 'package:app/categories/customfild.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();

  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');
  bool isloading = false;

  addcategory() async {
    if (formstate.currentState!.validate()) {
      try {
        isloading = true;
        setState(() {});
        DocumentReference response = await categories.add(
            {'name': name.text, "id": FirebaseAuth.instance.currentUser!.uid});

        Navigator.of(context)
            .pushNamedAndRemoveUntil("HomePage", (route) => false);
      } catch (error) {
        isloading = false;
        setState(() {});
        print("Failed to add note: $error");
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    name.dispose();
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
                          hinttext: "Enter Name",
                          mycontroller: name,
                          validator: (val) {
                            if (val == "") {
                              return "Can't Be Empty";
                            }
                          }),
                    ),
                    CustomButtom(
                      title: "Add",
                      onPressed: () {
                        addcategory();
                      },
                    )
                  ],
                )),
    );
  }
}
