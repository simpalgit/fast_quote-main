import 'package:fast_quote/Screens/Settings/Components/ChangePassword/change_pass_provider.dart';
import 'package:fast_quote/Utils/constants.dart';
import 'package:fast_quote/Widgets/add_part_button.dart';
import 'package:fast_quote/Widgets/common_loaders.dart';
import 'package:fast_quote/Widgets/input_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../../Widgets/common_appbar.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = Provider.of<ChangePassProvider>(context, listen: false);
      provider.initData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChangePassProvider>(context);
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: commonAppBar(
        context: context,
        heading: 'Change Password',
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 20.h,
                ),
                SizedBox(
                  height: size.height * 0.2,
                  child: Lottie.network(
                    "https://lottie.host/b72d482a-8285-41a6-aed9-19ff59a21d4f/2un8X2czPh.json",
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                LoginTextFields(
                  obsText: provider.showHidePass,
                  controllerValue: provider.ctlPassword,
                  hintValue: 'Password',
                  labelVal: 'Password',
                  inputType: TextInputType.visiblePassword,
                  validate: (val) {
                    if (val!.isEmpty) {
                      return "Password can't be empty";
                    } else {
                      return null;
                    }
                  },
                  suf: IconButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: () {
                        provider.changeShowhidePass(provider.showHidePass);
                      },
                      icon: Icon(
                        provider.showHidePass
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: secondary,
                      )),
                ),
                SizedBox(
                  height: 12.h,
                ),
                LoginTextFields(
                  obsText: provider.showHideRePass,
                  controllerValue: provider.ctlRePassword,
                  hintValue: 'Re enter Password',
                  labelVal: 'Re enter Password',
                  inputType: TextInputType.visiblePassword,
                  validate: (val) {
                    if (val!.isEmpty) {
                      return "Password can't be empty";
                    } else {
                      return null;
                    }
                  },
                  suf: IconButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: () {
                        provider.changeShowhideRePass(provider.showHideRePass);
                      },
                      icon: Icon(
                        provider.showHideRePass
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: secondary,
                      )),
                ),
                SizedBox(
                  height: 20.h,
                ),
                provider.isBtnLoading
                    ? const CommonButtonLoader()
                    : AppAddPartButtonWidget(
                        onTap: provider.isBtnLoading
                            ? null
                            : () {
                                final isValid =
                                    _formKey.currentState!.validate();

                                if (!isValid) {
                                  return;
                                }

                                provider.changePassword(context);
                              },
                        btnText: 'Change Password'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
