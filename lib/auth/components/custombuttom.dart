// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';

class CustomButtom extends StatelessWidget {
  final void Function()? onPressed;
  final String title;
  const CustomButtom({super.key, this.onPressed, required this.title});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 40,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      color: const Color.fromARGB(255, 24, 118, 195),
      onPressed: onPressed,
      child: Text(
        "$title",
        style: const TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }
}

class CustomButtomUpload extends StatelessWidget {
  final void Function()? onPressed;
  final String title;
  final bool isSelected;
  const CustomButtomUpload(
      {super.key,
      this.onPressed,
      required this.title,
      required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 40,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      color: isSelected ? Colors.green : Color.fromARGB(255, 24, 118, 195),
      onPressed: onPressed,
      child: Text(
        "$title",
        style: const TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }
}
