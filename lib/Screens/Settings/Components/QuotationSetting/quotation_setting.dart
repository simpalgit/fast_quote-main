import 'package:fast_quote/Utils/constants.dart';
import 'package:fast_quote/Widgets/add_part_button.dart';
import 'package:fast_quote/Widgets/common_appbar.dart';
import 'package:fast_quote/Widgets/error_found_widget.dart';
import 'package:fast_quote/Widgets/input_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'quotation_setting_provider.dart';

class QuotationSettingsScreen extends StatefulWidget {
  const QuotationSettingsScreen({super.key});

  @override
  State<QuotationSettingsScreen> createState() =>
      _QuotationSettingsScreenState();
}

class _QuotationSettingsScreenState extends State<QuotationSettingsScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final provider =
          Provider.of<QuotationSettingsProvider>(context, listen: false);
      provider.getQuotationSettingsData(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QuotationSettingsProvider>(context);
    return Scaffold(
      appBar: commonAppBar(context: context, heading: "Quotation Settings"),
      body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            child: Column(
              children: [
                StepperTextField(
                  controllerValue: provider.ctlNumberPrefix,
                  inputType: TextInputType.text,
                  validate: (val) {
                    return null;
                  },
                  hintValue: "Number Prefix",
                  onChange: (p0) {},
                ),
                provider.errorPrefix.isEmpty
                    ? Container()
                    : ErrorText(
                        error: provider.errorPrefix,
                      ),
                SizedBox(
                  height: 15.h,
                ),
                StepperTextField(
                  controllerValue: provider.ctlSerialNumber,
                  inputType: TextInputType.number,
                  validate: (val) {
                    return null;
                  },
                  hintValue: "Serial Number",
                  onChange: (p0) {},
                ),
                SizedBox(
                  height: 15.h,
                ),
                StepperTextField(
                  rOnly: true,
                  controllerValue: provider.ctlDiscountDisplay,
                  inputType: TextInputType.number,
                  validate: (val) {
                    return null;
                  },
                  onTap: () {
                    _selectDiscountDisplay(context, provider);
                  },
                  hintValue: "Discount Display",
                  onChange: (p0) {},
                ),
                SizedBox(
                  height: 15.h,
                ),
                StepperTextField(
                  rOnly: true,
                  onTap: () {
                    _selectTaxType(context, provider);
                  },
                  controllerValue: provider.ctlTaxDisplay,
                  validate: (val) {
                    return null;
                  },
                  hintValue: "Tax Display",
                  onChange: (p0) {},
                ),
                SizedBox(
                  height: 15.h,
                ),
                StepperTextField(
                  rOnly: true,
                  controllerValue: provider.ctlProductDisplay,
                  validate: (val) {
                    return null;
                  },
                  onTap: () {
                    _selectProductDisplayType(context, provider);
                  },
                  hintValue: "Product Display",
                  onChange: (p0) {},
                ),
                SizedBox(
                  height: 15.h,
                ),
                StepperTextField(
                  controllerValue: provider.ctlTopMessage,
                  inputType: TextInputType.text,
                  validate: (val) {
                    return null;
                  },
                  maxLine: 3,
                  hintValue: "Top Message",
                  onChange: (p0) {},
                ),
                SizedBox(
                  height: 15.h,
                ),
                StepperTextField(
                  controllerValue: provider.ctlBottomMessage,
                  inputType: TextInputType.text,
                  maxLine: 3,
                  validate: (val) {
                    return null;
                  },
                  hintValue: "Bottom Message",
                  onChange: (p0) {},
                ),
                SizedBox(
                  height: 15.h,
                ),
                StepperTextField(
                  rOnly: true,
                  controllerValue: provider.ctlPaymentInstruction,
                  inputType: TextInputType.text,
                  validate: (val) {
                    return null;
                  },
                  onTap: () {
                    _selectBankInfoDisplay(context, provider);
                  },
                  suf: Icon(
                    Icons.account_balance_outlined,
                    color: primaryColor,
                  ),
                  hintValue: "Bank info display",
                  onChange: (p0) {},
                ),
                SizedBox(
                  height: 15.h,
                ),
                AppAddPartButtonWidget(
                    onTap: () {
                      provider.uploadUpdateQuotationSettingsData(context);
                    },
                    btnText: provider.id == "" ? "Save" : 'Update'),
              ],
            ),
          )),
    );
  }

  _selectDiscountDisplay(
      BuildContext context, QuotationSettingsProvider provider) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: const Radius.circular(30.0).r,
          ),
        ),
        builder: (context) {
          return SizedBox(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 15.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    'Select Discount type',
                    style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.bold,
                        color: primaryColor),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  ListTileHelper(
                    onPressed: () {
                      provider.setDiscountDisplay('No Discount');
                      Navigator.pop(context);
                    },
                    text: 'No Discount',
                  ),
                  Container(
                    height: 1,
                    color: secondary,
                  ),
                  ListTileHelper(
                    onPressed: () {
                      provider.setDiscountDisplay('Per item');
                      Navigator.pop(context);
                    },
                    text: 'Per item',
                  ),
                  Container(
                    height: 1,
                    color: secondary,
                  ),
                  ListTileHelper(
                    onPressed: () {
                      provider.setDiscountDisplay('On Total');
                      Navigator.pop(context);
                    },
                    text: 'On Total',
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                ],
              ),
            ),
          );
        }).then((value) {
      setState(() {});
    });
  }

  _selectTaxType(BuildContext context, QuotationSettingsProvider provider) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: const Radius.circular(30.0).r,
          ),
        ),
        builder: (context) {
          return SizedBox(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 15.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    'Select Tax type',
                    style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.bold,
                        color: primaryColor),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  ListTileHelper(
                    onPressed: () {
                      provider.setTaxDisplay('No Tax');
                      Navigator.pop(context);
                    },
                    text: 'No Tax',
                  ),
                  Container(
                    height: 1,
                    color: secondary,
                  ),
                  ListTileHelper(
                    onPressed: () {
                      provider.setTaxDisplay('Per item');
                      Navigator.pop(context);
                    },
                    text: 'Per item',
                  ),
                  Container(
                    height: 1,
                    color: secondary,
                  ),
                  ListTileHelper(
                    onPressed: () {
                      provider.setTaxDisplay('On Total');
                      Navigator.pop(context);
                    },
                    text: 'On Total',
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                ],
              ),
            ),
          );
        }).then((value) {
      setState(() {});
    });
  }

  _selectProductDisplayType(
      BuildContext context, QuotationSettingsProvider provider) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: const Radius.circular(30.0).r,
          ),
        ),
        builder: (context) {
          return SizedBox(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 15.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    'Display Product HSN',
                    style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.bold,
                        color: primaryColor),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  ListTileHelper(
                    onPressed: () {
                      provider.setProductDisplayType('Yes');
                      Navigator.pop(context);
                    },
                    text: 'Yes',
                  ),
                  Container(
                    height: 1,
                    color: secondary,
                  ),
                  ListTileHelper(
                    onPressed: () {
                      provider.setProductDisplayType('No');
                      Navigator.pop(context);
                    },
                    text: 'No',
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                ],
              ),
            ),
          );
        }).then((value) {
      setState(() {});
    });
  }

  _selectBankInfoDisplay(
      BuildContext context, QuotationSettingsProvider provider) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: const Radius.circular(30.0).r,
          ),
        ),
        builder: (context) {
          return SizedBox(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 15.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    'Display Bank information',
                    style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.bold,
                        color: primaryColor),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  ListTileHelper(
                    onPressed: () {
                      provider.setBankInfoDisplay('Yes');
                      Navigator.pop(context);
                    },
                    text: 'Yes',
                  ),
                  Container(
                    height: 1,
                    color: secondary,
                  ),
                  ListTileHelper(
                    onPressed: () {
                      provider.setBankInfoDisplay('No');
                      Navigator.pop(context);
                    },
                    text: 'No',
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                ],
              ),
            ),
          );
        }).then((value) {
      setState(() {});
    });
  }
}

class ListTileHelper extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  const ListTileHelper(
      {super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onPressed,
        child: ListTile(
            title: Row(
          children: [
            Icon(
              Icons.circle,
              size: 10,
              color: primaryColor,
            ),
            SizedBox(
              width: 20.w,
            ),
            Text(
              text,
              style: TextStyle(color: secondary, fontWeight: FontWeight.bold),
            ),
          ],
        )));
  }
}
