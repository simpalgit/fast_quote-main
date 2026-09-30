import 'package:fast_quote/Screens/Product/product_model.dart';
import 'package:fast_quote/Widgets/add_part_button.dart';
import 'package:fast_quote/Widgets/common_appbar.dart';
import 'package:fast_quote/Widgets/error_found_widget.dart';
import 'package:fast_quote/Widgets/input_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'edit_product_provider.dart';

class EditProductScreen extends StatefulWidget {
  final ProductModel productModel;
  const EditProductScreen({super.key, required this.productModel});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = Provider.of<EditProductProvider>(context, listen: false);
      provider.initData(context, widget.productModel);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EditProductProvider>(
      context,
    );
    return Scaffold(
      appBar: commonAppBar(
        context: context,
        heading: 'Edit Product',
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 15.w, right: 15.w, bottom: 5.h),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                      provider.errorProductName.isEmpty
                          ? Container()
                          : ErrorText(
                              error: provider.errorProductName,
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
                        mLength: 7,
                      ),
                      provider.errorPrice.isEmpty
                          ? Container()
                          : ErrorText(
                              error: provider.errorPrice,
                            ),
                      SizedBox(
                        height: 12.h,
                      ),
                      StepperTextField(
                        controllerValue: provider.ctlUnit,
                        hintValue: 'Unit',
                        inputType: TextInputType.text,
                        validate: (val) {
                          if (val!.isEmpty) {
                            return "Field Cant be empty.";
                          } else {
                            return null;
                          }
                        },
                      ),
                      provider.errorUnit.isEmpty
                          ? Container()
                          : ErrorText(
                              error: provider.errorUnit,
                            ),
                      SizedBox(
                        height: 12.h,
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
                      SizedBox(
                        height: 12.h,
                      ),
                      StepperTextField(
                        controllerValue: provider.ctlHSN,
                        hintValue: provider.productHSNValue,
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
            SizedBox(
              height: 10.h,
            ),
            Row(
              children: [
                Expanded(
                  child: AppButtonSecondarySmall(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(
                              side: BorderSide(color: Colors.black87),
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(8),
                              ),
                            ),
                            builder: (_) => SizedBox(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 15,
                                        right: 15,
                                        top: 15,
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom),
                                    child: StatefulBuilder(
                                        builder: (context, setState) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Are you sure you want to delete Customer ??',
                                                  style: TextStyle(
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      letterSpacing: 1.5,
                                                      fontSize: 15.sp),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        border: Border.all(
                                                            color:
                                                                Colors.black87),
                                                        shape: BoxShape.circle),
                                                    child: const Icon(
                                                        Icons.close)),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 20.h,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: AppButtonSecondarySmall(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    btnText: 'No'),
                                              ),
                                              SizedBox(
                                                width: 15.w,
                                              ),
                                              Expanded(
                                                child: AppAddPartButtonSmall(
                                                    onTap: () {
                                                      provider.deleteProduct(
                                                          context,
                                                          widget.productModel);
                                                    },
                                                    btnText: 'Yes'),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 20.h,
                                          ),
                                        ],
                                      );
                                    }),
                                  ),
                                ));
                      },
                      btnText: 'Delete'),
                ),
                SizedBox(
                  width: 15.w,
                ),
                Expanded(
                  child: AppAddPartButtonSmall(
                      onTap: () {
                        final isValid = _formKey.currentState!.validate();

                        if (!isValid) {
                          return;
                        }

                        provider.editProduct(context, widget.productModel);
                      },
                      btnText: 'Update'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
