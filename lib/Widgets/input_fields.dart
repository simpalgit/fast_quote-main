import 'package:fast_quote/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ModelTextField extends StatelessWidget {
  final TextEditingController? controllerValue;
  final VoidCallback? onTap;
  final String? validateValue;
  final TextInputType? inputType;
  final TextInputAction? actionNext;
  final String? hintValue;
  final int? maxLine, mLength;
  final Widget? suf;

  const ModelTextField({
    super.key,
    this.controllerValue,
    this.validateValue,
    this.hintValue,
    this.onTap,
    this.inputType,
    this.actionNext,
    this.mLength,
    this.maxLine,
    this.suf,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(fontSize: 12.sp, letterSpacing: 1),
      cursorColor: Colors.black87,
      textInputAction: actionNext,
      maxLines: maxLine,
      onTap: onTap,
      keyboardType: inputType,
      validator: (value) {
        if (value!.isEmpty) {
          return validateValue;
        } else {
          return null;
        }
      },
      controller: controllerValue!,
      maxLength: mLength,
      decoration: InputDecoration(
        suffixIcon: suf,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        filled: true,
        fillColor: Colors.white,
        counterText: '',
        hintText: hintValue,
        hintStyle: TextStyle(fontSize: 12.sp, letterSpacing: 1),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.red),
        ),
        labelStyle: const TextStyle(color: Colors.black87),
      ),
    );
  }
}

class StepperTextField extends StatelessWidget {
  final TextEditingController? controllerValue;
  final VoidCallback? onTap;
  final Function(String)? onChange;
  final Widget? suf;
  final bool? rOnly;
  final TextInputType? inputType;
  final TextInputAction? actionNext;
  final bool? obsText;
  final int? maxLine, mLength;

  final String? Function(String?)? validate;
  final String? hintValue;
  const StepperTextField({
    super.key,
    this.suf,
    this.controllerValue,
    this.obsText = false,
    this.validate,
    this.onTap,
    this.rOnly = false,
    this.inputType,
    this.actionNext,
    this.mLength,
    this.maxLine,
    this.hintValue,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChange,
      style: TextStyle(fontSize: 13.sp, letterSpacing: 1, color: Colors.black),
      cursorColor: Colors.black87,
      readOnly: rOnly!,
      textInputAction: actionNext,
      maxLines: maxLine,
      onTap: onTap,
      keyboardType: inputType,
      obscureText: obsText!,
      validator: validate!,
      controller: controllerValue!,
      maxLength: mLength,
      decoration: InputDecoration(
        suffixIcon: suf,
        label: Text(hintValue!),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        filled: true,
        fillColor: Colors.white,
        counterText: '',
        hintText: hintValue,
        alignLabelWithHint: true,
        hintStyle: TextStyle(fontSize: 12.sp, letterSpacing: 1),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.red),
        ),
        labelStyle: const TextStyle(color: Colors.black87),
      ),
    );
  }
}

class BankTextField extends StatelessWidget {
  final TextEditingController? controllerValue;
  final VoidCallback? onTap;
  final Function(String)? onChange;
  final Widget? suf;
  final bool? rOnly;
  final TextInputType? inputType;
  final TextInputAction? actionNext;
  final bool? obsText;
  final int? maxLine, mLength;

  final String? Function(String?)? validate;
  final String? hintValue;
  const BankTextField({
    super.key,
    this.suf,
    this.controllerValue,
    this.obsText = false,
    this.validate,
    this.onTap,
    this.rOnly = false,
    this.inputType,
    this.actionNext,
    this.mLength,
    this.maxLine,
    this.hintValue,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChange,
      style: TextStyle(fontSize: 13.sp, letterSpacing: 1, color: Colors.black),
      cursorColor: Colors.black87,
      readOnly: rOnly!,
      textInputAction: actionNext,
      maxLines: maxLine,
      onTap: onTap,
      keyboardType: inputType,
      obscureText: obsText!,
      validator: validate!,
      controller: controllerValue!,
      maxLength: mLength,
      decoration: InputDecoration(
        suffixIcon: suf,
        label: const Text(""),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        filled: true,
        fillColor: Colors.white,
        counterText: '',
        hintText: hintValue,
        alignLabelWithHint: true,
        hintStyle: TextStyle(fontSize: 12.sp, letterSpacing: 1),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.red),
        ),
        labelStyle: const TextStyle(color: Colors.black87),
      ),
    );
  }
}

class LoginTextFields extends StatelessWidget {
  final TextEditingController controllerValue;
  final VoidCallback? onTap;
  final Widget? pref;
  final Function(String)? onChange;
  final String? validateValue;
  final bool? rOnly;
  final TextInputType? inputType;
  final TextInputAction? actionNext;
  final String? hintValue, labelVal;
  final int? maxLine, mLength;
  final Widget? suf;
  final String? Function(String?) validate;
  final bool? obsText;

  const LoginTextFields({
    super.key,
    required this.controllerValue,
    this.validateValue,
    required this.validate,
    this.pref,
    this.hintValue,
    this.obsText = false,
    this.onTap,
    this.rOnly = false,
    this.inputType,
    this.actionNext,
    this.mLength,
    this.maxLine,
    this.suf,
    this.labelVal,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return TextFormField(
      onChanged: onChange,
      style: TextStyle(
        fontSize: size.width * 0.035,
        letterSpacing: 1,
        color: Colors.black,
      ),
      cursorColor: Colors.black87,
      readOnly: rOnly!,
      textInputAction: actionNext,
      onTap: onTap,
      keyboardType: inputType,
      validator: validate,
      obscureText: obsText!,
      controller: controllerValue,
      maxLength: mLength,
      decoration: InputDecoration(
        suffixIcon: suf,
        prefixIcon: pref,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        filled: true,
        fillColor: Colors.white,
        counterText: '',
        hintText: hintValue,
        labelText: labelVal,
        hintStyle: TextStyle(fontSize: 12.sp, letterSpacing: 1),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.red),
        ),
        labelStyle: const TextStyle(color: Colors.black87),
      ),
    );
  }
}
