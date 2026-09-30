import 'dart:async';

import 'package:fast_quote/Screens/Product/product_model.dart';
import 'package:fast_quote/Utils/constants.dart';
import 'package:fast_quote/Utils/route_names.dart';
import 'package:fast_quote/Widgets/common_appbar.dart';
import 'package:fast_quote/Widgets/input_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'add_enquiry_product_provider.dart';

class AddEnquiryProduct extends StatefulWidget {
  final ProductModel productModel;
  const AddEnquiryProduct({super.key, required this.productModel});

  @override
  State<AddEnquiryProduct> createState() => _AddEnquiryProductState();
}

class _AddEnquiryProductState extends State<AddEnquiryProduct> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final provider =
          Provider.of<AddEnquiryProductProvider>(context, listen: false);
      provider.initData(widget.productModel);
    });
    super.initState();
  }

  navigateToColumnHeading() async {
    await Navigator.pushNamed(context, RouteNames.columnHeading)
        .then(onRefresh);
  }

  FutureOr onRefresh(dynamic value) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final provider =
          Provider.of<AddEnquiryProductProvider>(context, listen: false);
      provider.initData(widget.productModel);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AddEnquiryProductProvider>(
      context,
    );
    return Scaffold(
      appBar: commonAppBar(
        context: context,
        heading: 'Add Product',
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 15.h,
                ),
                StepperTextField(
                  controllerValue: provider.ctlProductName,
                  hintValue: 'Product Name',
                  inputType: TextInputType.name,
                  validate: (val) {
                    if (val!.isEmpty) {
                      return "Field Cant be empty.";
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: 12.h,
                ),
                StepperTextField(
                  controllerValue: provider.ctlQuantity,
                  hintValue: 'Quantity',
                  inputType: TextInputType.number,
                  validate: (val) {
                    if (val!.isEmpty) {
                      return "Field Cant be empty.";
                    } else {
                      return null;
                    }
                  },
                  mLength: 7,
                ),
                SizedBox(
                  height: 12.h,
                ),
                StepperTextField(
                  controllerValue: provider.ctlPrice,
                  hintValue: 'Price',
                  inputType: TextInputType.number,
                  validate: (val) {
                    if (val!.isEmpty) {
                      return "Field Cant be empty.";
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: 12.h,
                ),
                InkWell(
                    onTap: () {
                      navigateToColumnHeading();
                    },
                    child: Text(
                      'Change Tax Type',
                      style: TextStyle(
                          letterSpacing: 1,
                          color: primaryColor,
                          fontWeight: FontWeight.bold),
                    )),
                SizedBox(
                  height: 5.h,
                ),
                StepperTextField(
                  controllerValue: provider.ctlGST,
                  suf: const Icon(
                    Icons.percent_rounded,
                  ),
                  hintValue: provider.taxHintValue,
                  inputType: TextInputType.number,
                  validate: (val) {
                    return null;
                  },
                ),
                SizedBox(
                  height: 12.h,
                ),
                StepperTextField(
                  controllerValue: provider.ctlDescription,
                  maxLine: 5,
                  hintValue: 'Description',
                  inputType: TextInputType.text,
                  validate: (val) {
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Add To Enquiry'),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        backgroundColor: primaryColor,
        onPressed: () {
          final isValid = _formKey.currentState!.validate();

          if (!isValid) {
            return;
          }
          provider.addToEnquiryFun(context, widget.productModel);
        },
      ),
    );
  }
}
