import 'package:fast_quote/Screens/Settings/Components/ColumnHeading/column_heading_provider.dart';
import 'package:fast_quote/Utils/constants.dart';
import 'package:fast_quote/Widgets/add_part_button.dart';
import 'package:fast_quote/Widgets/common_appbar.dart';
import 'package:fast_quote/Widgets/input_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ColumnHeadingScreen extends StatefulWidget {
  const ColumnHeadingScreen({super.key});

  @override
  State<ColumnHeadingScreen> createState() => _ColumnHeadingScreenState();
}

class _ColumnHeadingScreenState extends State<ColumnHeadingScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = Provider.of<ColumnHeadingProvider>(
        context,
        listen: false,
      );
      provider.initData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ColumnHeadingProvider>(context);
    return Scaffold(
      appBar: commonAppBar(context: context, heading: "Column Heading"),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                StepperTextField(
                  controllerValue: provider.ctlTaxLabel,
                  inputType: TextInputType.text,
                  suf: Icon(CupertinoIcons.tag_circle_fill, color: secondary),
                  validate: (val) {
                    if (val!.isEmpty) {
                      return "Please enter Tax Label";
                    } else {
                      return null;
                    }
                  },
                  hintValue: "tax label",
                  onChange: (p0) {},
                ),
                SizedBox(height: 15.h),
                StepperTextField(
                  suf: Icon(CupertinoIcons.tag_circle_fill, color: secondary),
                  controllerValue: provider.ctlProductHSNLabel,
                  inputType: TextInputType.text,
                  validate: (val) {
                    if (val!.isEmpty) {
                      return "Please enter product hsn label";
                    } else {
                      return null;
                    }
                  },
                  hintValue: "Product HSN Label",
                  onChange: (p0) {},
                ),
                SizedBox(height: 15.h),
                StepperTextField(
                  suf: Icon(CupertinoIcons.tag_circle_fill, color: secondary),
                  controllerValue: provider.ctlOtherChargesLabel,
                  inputType: TextInputType.text,
                  validate: (val) {
                    if (val!.isEmpty) {
                      return "Please enter other charges label";
                    } else {
                      return null;
                    }
                  },
                  hintValue: "Other Charges Label",
                  onChange: (p0) {},
                ),
                SizedBox(height: 15.h),
                AppAddPartButtonWidget(
                  onTap: () {
                    final isValid = _formKey.currentState!.validate();

                    if (!isValid) {
                      return;
                    }

                    provider.updateColumnHeading(context);
                  },
                  btnText: 'Update',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
