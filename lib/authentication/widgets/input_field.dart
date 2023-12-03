import 'package:flutter/material.dart';
import 'package:receipts/common/constants/constants.dart';

class InputField extends StatelessWidget {
  final Icon prefixIcon;
  final TextEditingController textController;
  final String hintText;
  final bool isObscured;
  final String? Function(String?)? validator;

  const InputField(
      {Key? key,
      required this.prefixIcon,
      required this.textController,
      required this.hintText,
      required this.isObscured,
      required this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: textController,
      obscureText: isObscured,
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          prefixIcon: prefixIcon,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          errorMaxLines: 2,
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.accent),
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              )),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              )),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          )),
    );
  }
}
