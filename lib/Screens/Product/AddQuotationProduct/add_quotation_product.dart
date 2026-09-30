import 'dart:async';

import 'package:fast_quote/Screens/Product/product_model.dart';
import 'package:fast_quote/Utils/common_functions.dart';
import 'package:fast_quote/Utils/constants.dart';
import 'package:fast_quote/Utils/route_names.dart';
import 'package:fast_quote/Widgets/common_appbar.dart';
import 'package:fast_quote/Widgets/input_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'add_quotation_product_provider.dart';

class AddQuotationProduct extends StatefulWidget {
  final ProductModel productModel;
  final String action;
  const AddQuotationProduct(
      {super.key, required this.productModel, required this.action});

  @override
  State<AddQuotationProduct> createState() => _AddQuotationProductState();
}

class _AddQuotationProductState extends State<AddQuotationProduct> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController ctlDisc = TextEditingController();

  bool isPercentage = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final provider =
          Provider.of<AddQuotationProductProvider>(context, listen: false);
      provider.initData(widget.productModel, context);
      if (widget.productModel.isDiscount != null) {
        if (widget.productModel.isDiscount!) {
          if (widget.productModel.discountType == "Percentage") {
            isPercentage = true;
            ctlDisc.text = widget.productModel.discountPercentage!;
          } else {
            isPercentage = false;
            ctlDisc.text = widget.productModel.discountAmt!;
          }
        }
      }
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
          Provider.of<AddQuotationProductProvider>(context, listen: false);
      provider.initData(widget.productModel, context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AddQuotationProductProvider>(
      context,
    );
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
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
                  provider.quoteInvSettingModel.discount == "Per item"
                      ? Column(
                          children: [
                            InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        vertical: 5,
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            title: const Text(
                                              'Percentage',
                                            ),
                                            onTap: () {
                                              setState(() {
                                                isPercentage = true;
                                                ctlDisc.clear();
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                          ListTile(
                                            title: const Text('Flat Amount'),
                                            onTap: () {
                                              setState(() {
                                                isPercentage = false;
                                                ctlDisc.clear();
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Card(
                                margin: EdgeInsets.zero,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                    side: const BorderSide(color: Colors.grey)),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 15.0, horizontal: 12.w),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            isPercentage
                                                ? 'Add Discount (Percentage)'
                                                : 'Add Discount (Flat Amt)',
                                            style: const TextStyle(
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const Icon(
                                            CupertinoIcons.chevron_forward,
                                            size: 18,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            StepperTextField(
                              controllerValue: ctlDisc,
                              hintValue: isPercentage
                                  ? 'Discount (in %)'
                                  : 'Flat Amount',
                              inputType: TextInputType.number,
                              validate: (val) {
                                return null;
                              },
                              onChange: (value) {
                                if (value.isNotEmpty) {
                                  if (value != ".") {
                                    double val = double.parse(value);
                                    if (isPercentage) {
                                      if (val > 100) {
                                        if (val > 100) {
                                          if (val > 100) {
                                            val = 100;
                                          }

                                          ctlDisc.value = TextEditingValue(
                                            text: val.toString(),
                                            selection:
                                                TextSelection.fromPosition(
                                              TextPosition(
                                                  offset: ctlDisc.value
                                                      .selection.baseOffset),
                                            ),
                                          );
                                          CommonFunctions.showErrorSnackbar(
                                              context,
                                              "Discount is greater than 100.");
                                        }
                                      }
                                    } else {
                                      if (val >
                                          double.parse(
                                              provider.ctlPrice.text)) {
                                        if (val >
                                            double.parse(
                                                provider.ctlPrice.text)) {
                                          val = double.parse(
                                              provider.ctlPrice.text);
                                        }

                                        ctlDisc.value = TextEditingValue(
                                          text: val.toString(),
                                          selection: TextSelection.fromPosition(
                                            TextPosition(
                                                offset: ctlDisc.value.selection
                                                    .baseOffset),
                                          ),
                                        );
                                        CommonFunctions.showErrorSnackbar(
                                            context,
                                            "Added Discount Amount is greater than price.");
                                      }
                                    }
                                  } else {
                                    ctlDisc.clear();
                                    setState(() {});
                                  }
                                }
                              },
                            ),
                            SizedBox(
                              height: 12.h,
                            ),
                          ],
                        )
                      : Container(),
                  provider.quoteInvSettingModel.tax == "Per item"
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
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
                          ],
                        )
                      : const SizedBox(),
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
          label: const Text('Add To Quotation'),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          backgroundColor: primaryColor,
          onPressed: () {
            final isValid = _formKey.currentState!.validate();

            if (!isValid) {
              return;
            }
            provider.addToEnquiryFun(context, widget.productModel, isPercentage,
                ctlDisc.text, widget.action);
          },
        ),
      ),
    );
  }
}
