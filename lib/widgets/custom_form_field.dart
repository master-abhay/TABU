import 'package:flutter/material.dart';

class CustomFormField extends StatefulWidget {
  const CustomFormField(
      {super.key,
      required this.hintText,
      required this.height,
      required this.validateRegExp,
      required this.obsecureText,
      required this.onSaved});

  final String hintText;
  final double height;
  final RegExp validateRegExp;
  final bool obsecureText;
  final void Function(String?) onSaved;
  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: TextFormField(
        onSaved: widget.onSaved,
        obscureText: widget.obsecureText,
        validator: (value) {
          if (value != null && widget.validateRegExp.hasMatch(value)) {
            return null;
          }
          return "Enter a valid ${widget.hintText.toLowerCase()}";
        },
        decoration: InputDecoration(
            border: OutlineInputBorder(), hintText: widget.hintText),
      ),
    );
  }
}
