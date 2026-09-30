import 'package:fast_quote/Screens/Customer/customer_model.dart';
import 'package:fast_quote/Utils/constants.dart';
import 'package:fast_quote/Widgets/add_part_button.dart';
import 'package:fast_quote/Widgets/common_appbar.dart';
import 'package:fast_quote/Widgets/error_found_widget.dart';
import 'package:fast_quote/Widgets/input_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'edit_customer_provider.dart';

class EditCustomerScreen extends StatefulWidget {
  final CustomerModel customerModel;
  const EditCustomerScreen({super.key, required this.customerModel});

  @override
  State<EditCustomerScreen> createState() => _EditCustomerScreenState();
}

class _EditCustomerScreenState extends State<EditCustomerScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final provider =
          Provider.of<EditCustomerProvider>(context, listen: false);
      provider.getStates(context, widget.customerModel);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EditCustomerProvider>(context);
    return Scaffold(
      appBar: commonAppBar(
        context: context,
        heading: 'Edit Customer',
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
                        controllerValue: provider.ctlCustomer,
                        inputType: TextInputType.text,
                        validate: (val) {
                          if (val!.isEmpty) {
                            return "Field Cant be empty";
                          } else {
                            return null;
                          }
                        },
                        hintValue: "Customer Name",
                        onChange: (p0) {},
                      ),
                      provider.errorCustomerName.isEmpty
                          ? Container()
                          : ErrorText(
                              error: provider.errorCustomerName,
                            ),
                      SizedBox(
                        height: 12.h,
                      ),
                      StepperTextField(
                        controllerValue: provider.ctlCompanyName,
                        hintValue: 'Company Name',
                        inputType: TextInputType.name,
                        validate: (val) {
                          if (val!.isEmpty) {
                            return "Field Cant be empty";
                          } else {
                            return null;
                          }
                        },
                      ),
                      provider.errorCompanyName.isEmpty
                          ? Container()
                          : ErrorText(
                              error: provider.errorCompanyName,
                            ),
                      SizedBox(
                        height: 12.h,
                      ),
                      StepperTextField(
                        controllerValue: provider.ctlEmail,
                        hintValue: 'Email',
                        inputType: TextInputType.emailAddress,
                        validate: (val) {
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 12.h,
                      ),
                      StepperTextField(
                        controllerValue: provider.ctlMobile,
                        inputType: TextInputType.phone,
                        validate: (val) {
                          if (val!.isEmpty) {
                            return "Field Cant be empty";
                          } else if (val.length < 10) {
                            return "mobile num 10";
                          } else {
                            return null;
                          }
                        },
                        mLength: 10,
                        hintValue: "Mobile",
                      ),
                      provider.errorMobile.isEmpty
                          ? Container()
                          : ErrorText(
                              error: provider.errorMobile,
                            ),
                      SizedBox(
                        height: 12.h,
                      ),
                      StepperTextField(
                        controllerValue: provider.ctlAddressOne,
                        hintValue: 'Address One',
                        inputType: TextInputType.streetAddress,
                        validate: (val) {
                          if (val!.isEmpty) {
                            return "Field Cant be empty";
                          } else {
                            return null;
                          }
                        },
                      ),
                      provider.errorAddOne.isEmpty
                          ? Container()
                          : ErrorText(
                              error: provider.errorAddOne,
                            ),
                      SizedBox(
                        height: 12.h,
                      ),
                      StepperTextField(
                        controllerValue: provider.ctlAddressTwo,
                        hintValue: 'Address Two',
                        inputType: TextInputType.streetAddress,
                        validate: (val) {
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 12.h,
                      ),
                      StepperTextField(
                        controllerValue: provider.ctlOtherInfo,
                        hintValue: 'Other Info',
                        inputType: TextInputType.streetAddress,
                        validate: (val) {
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 12.h,
                      ),
                      StepperTextField(
                        controllerValue: provider.ctlGstInNumber,
                        hintValue: 'GSTIN Number',
                        inputType: TextInputType.text,
                        validate: (val) {
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 12.h,
                      ),
                      StepperTextField(
                        rOnly: true,
                        onTap: () {
                          _selectState(context, provider);
                        },
                        controllerValue: provider.ctlState,
                        hintValue: 'State',
                        inputType: TextInputType.streetAddress,
                        validate: (val) {
                          if (val!.isEmpty) {
                            return "Field Cant be empty";
                          } else {
                            return null;
                          }
                        },
                      ),
                      provider.errorState.isEmpty
                          ? Container()
                          : ErrorText(
                              error: provider.errorState,
                            ),
                      SizedBox(
                        height: 12.h,
                      ),
                      StepperTextField(
                        controllerValue: provider.ctlShippingAddress,
                        hintValue: 'Shipping address',
                        inputType: TextInputType.streetAddress,
                        maxLine: 5,
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
                                                      provider.deleteCustomer(
                                                          context,
                                                          widget.customerModel);
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

                        provider.editCustomer(context, widget.customerModel);
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

  _selectState(BuildContext context, EditCustomerProvider provider) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: const Radius.circular(30.0).r,
          ),
        ),
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              var filteredData = [];
              if (provider.ctlStateName.text.isEmpty) {
                filteredData = provider.stateList;
              } else {
                filteredData = provider.stateList
                    .where((e) => (e.name
                        .toLowerCase()
                        .contains(provider.ctlStateName.text.toLowerCase())))
                    .toList();
              }

              return Padding(
                padding: EdgeInsets.only(
                    top: 30.sp,
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    left: 15.sp,
                    right: 15.sp),
                child: SizedBox(
                  height: 350.h,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Select State',
                        style: TextStyle(fontSize: 20.sp),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 0, left: 20, right: 20)
                                .w,
                        child: TextFormField(
                          controller: provider.ctlStateName,
                          style: TextStyle(
                              fontSize: 15.sp,
                              color: secondary,
                              fontWeight: FontWeight.w400),
                          decoration: InputDecoration(
                              hintText: 'Search product...',
                              suffixIcon: Icon(
                                Icons.search,
                                color: primaryColor,
                              ),
                              contentPadding: const EdgeInsets.only(left: 20),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide:
                                    BorderSide(color: secondary, width: 1.5),
                              ),
                              fillColor: Colors.white,
                              filled: true),
                          onChanged: (String value) {
                            setState(() {/*areaSearch = value.toString();*/});
                          },
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                            itemCount: filteredData.length,
                            physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            itemBuilder: (context, index) {
                              return ListTile(
                                onTap: () {
                                  provider.stateOnClick(
                                      filteredData[index], context);
                                },
                                title: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.w),
                                  child:
                                      Text(filteredData[index].name.toString()),
                                ),
                              );
                            }),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        }).then((value) {
      setState(() {});
    });
  }
}
