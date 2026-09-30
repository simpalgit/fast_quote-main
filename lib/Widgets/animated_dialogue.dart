import 'package:fast_quote/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomDialog extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  const CustomDialog({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context, onTap, text),
    );
  }
}

dialogContent(BuildContext context, VoidCallback onTap, String text) {
  return Container(
    decoration: BoxDecoration(
      color: whiteColor,
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 10.0,
          offset: Offset(0.0, 10.0),
        ),
      ],
    ),
    width: MediaQuery.of(context).size.width,
    child: Column(
      mainAxisSize: MainAxisSize.min, // To make the card compact
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.centerRight,
            child: const Icon(Icons.close, color: Colors.black),
          ),
        ),
        const SizedBox(height: 24),
        SvgPicture.asset("assets/images/fill_form.svg", width: 95, height: 95),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: secondary,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
        ),
        const SizedBox(height: 30),
        InkWell(
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
            decoration: BoxDecoration(
              color: secondary,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(24),
            ),
            alignment: Alignment.center,
            child: const Text(
              "Fill Up Form",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class SubscriptionErrorCustomDialog extends StatelessWidget {
  final VoidCallback onTap;
  final String text, btnText;
  const SubscriptionErrorCustomDialog({
    super.key,
    required this.onTap,
    required this.text,
    required this.btnText,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: suberrordialogContent(context, onTap, text, btnText),
    );
  }
}

suberrordialogContent(
  BuildContext context,
  VoidCallback onTap,
  String text,
  String btnText,
) {
  return Container(
    decoration: BoxDecoration(
      color: whiteColor,
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 10.0,
          offset: Offset(0.0, 10.0),
        ),
      ],
    ),
    width: MediaQuery.of(context).size.width,
    child: Column(
      mainAxisSize: MainAxisSize.min, // To make the card compact
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.centerRight,
            child: const Icon(Icons.close, color: Colors.black),
          ),
        ),
        const SizedBox(height: 24),
        SvgPicture.asset("assets/images/fill_form.svg", width: 95, height: 95),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: secondary,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
        ),
        const SizedBox(height: 30),
        InkWell(
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
            decoration: BoxDecoration(
              color: secondary,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(24),
            ),
            alignment: Alignment.center,
            child: Text(
              btnText,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
