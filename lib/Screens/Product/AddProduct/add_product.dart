import 'package:fast_quote/Screens/Product/AddProduct/add_product_provider.dart';
import 'package:fast_quote/Widgets/add_part_button.dart';
import 'package:fast_quote/Widgets/common_appbar.dart';
import 'package:fast_quote/Widgets/error_found_widget.dart';
import 'package:fast_quote/Widgets/input_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = Provider.of<AddProductProvider>(context, listen: false);
      provider.initData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AddProductProvider>(
      context,
    );
    return Scaffold(
      appBar: commonAppBar(
        context: context,
        heading: 'Add Product',
      ),
      body:Center(
        child: Container(
                      alignment: Alignment.center,
                      constraints: BoxConstraints(minWidth: 800, maxWidth: 800),
             child:   Padding(
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
              AppAddPartButtonWidget(
                  onTap: () {
                    final isValid = _formKey.currentState!.validate();
        
                    if (!isValid) {
                      return;
                    }
        
                    provider.addProduct(context);
                  },
                  btnText: 'Add Product'),
            ],
          ),
        ),
            ),
      ));
  }
}
