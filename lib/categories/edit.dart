// ignore_for_file: prefer_const_constructors, avoid_print, use_build_context_synchronously, camel_case_types, body_might_complete_normally_nullable

import 'package:app/auth/components/custombuttom.dart';
import 'package:app/categories/customfild.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class editCategory extends StatefulWidget {
  final String docid;
  final String oldname;
  const editCategory({super.key, required this.docid, required this.oldname});
  @override
  State<editCategory> createState() => _editCategoryState();
}

class _editCategoryState extends State<editCategory> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();

  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');
  bool isloading = false;

  editcategory() async {
    if (formstate.currentState!.validate()) {
      try {
        isloading = true;
        setState(() {});
        await categories.doc(widget.docid).update({"name": name.text});
        // await categories.doc(widget.docid).set({"name": name.text},SetOptions(merge: true));
        Navigator.of(context)
            .pushNamedAndRemoveUntil("HomePage", (route) => false);
      } catch (error) {
        isloading = false;
        setState(() {});
        print("Failed to edit category: $error");
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    name.dispose();
  }

  @override
  void initState() {
    name.text = widget.oldname;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("edit Category"),
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
                            if (val == null) {
                              return "Can't Be Empty";
                            }
                          }),
                    ),
                    CustomButtom(
                      title: "Save",
                      onPressed: () {
                        editcategory();
                      },
                    )
                  ],
                )),
    );
  }
}
