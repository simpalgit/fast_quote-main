import 'package:fast_quote/Screens/Customer/AddCustomer/add_customer_provider.dart';
import 'package:fast_quote/Utils/constants.dart';
import 'package:fast_quote/Widgets/add_part_button.dart';
import 'package:fast_quote/Widgets/common_appbar.dart';
import 'package:fast_quote/Widgets/error_found_widget.dart';
import 'package:fast_quote/Widgets/input_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = Provider.of<AddCustomerProvider>(context, listen: false);
      provider.getStates(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AddCustomerProvider>(context);
    return Scaffold(
      appBar: commonAppBar(context: context, heading: 'Add Customer'),
      body: Center(
        child: Container(
          alignment: Alignment.center,
          constraints: BoxConstraints(
            minWidth: 600,
            maxWidth: 1200,  // You may adjust these values for more flexibility
          ),
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StepperTextField(
                    controllerValue: provider.ctlCustomer,
                    inputType: TextInputType.text,
                    validate: (val) {
                      if (val!.isEmpty) {
                        return "Field Can't be empty";
                      } else {
                        return null;
                      }
                    },
                    hintValue: "Customer Name",
                    onChange: (p0) {},
                  ),
                  provider.errorCustomerName.isNotEmpty
                      ? ErrorText(error: provider.errorCustomerName)
                      : SizedBox(height: 12.h),
                  StepperTextField(
                    controllerValue: provider.ctlCompanyName,
                    hintValue: 'Company Name',
                    inputType: TextInputType.name,
                    validate: (val) {
                      if (val!.isEmpty) {
                        return "Field Can't be empty";
                      } else {
                        return null;
                      }
                    },
                  ),
                  provider.errorCompanyName.isNotEmpty
                      ? ErrorText(error: provider.errorCompanyName)
                      : SizedBox(height: 12.h),
                  StepperTextField(
                    controllerValue: provider.ctlEmail,
                    hintValue: 'Email',
                    inputType: TextInputType.emailAddress,
                    validate: (val) {
                      return null;  // Further validation can be added
                    },
                  ),
                  SizedBox(height: 12.h),
                  StepperTextField(
                    controllerValue: provider.ctlMobile,
                    inputType: TextInputType.phone,
                    validate: (val) {
                      if (val!.isEmpty) {
                        return "Field Can't be empty";
                      } else if (val.length < 10) {
                        return "Mobile must be 10 digits";
                      } else {
                        return null;
                      }
                    },
                    mLength: 10,
                    hintValue: "Mobile",
                  ),
                  provider.errorMobile.isNotEmpty
                      ? ErrorText(error: provider.errorMobile)
                      : SizedBox(height: 12.h),
                  StepperTextField(
                    controllerValue: provider.ctlAddressOne,
                    hintValue: 'Address One',
                    inputType: TextInputType.streetAddress,
                    validate: (val) {
                      if (val!.isEmpty) {
                        return "Field Can't be empty";
                      } else {
                        return null;
                      }
                    },
                  ),
                  provider.errorAddOne.isNotEmpty
                      ? ErrorText(error: provider.errorAddOne)
                      : SizedBox(height: 12.h),
                  StepperTextField(
                    controllerValue: provider.ctlAddressTwo,
                    hintValue: 'Address Two',
                    inputType: TextInputType.streetAddress,
                    validate: (val) => null,
                  ),
                  SizedBox(height: 12.h),
                  StepperTextField(
                    controllerValue: provider.ctlOtherInfo,
                    hintValue: 'Other Info',
                    inputType: TextInputType.streetAddress,
                    validate: (val) => null,
                  ),
                  SizedBox(height: 12.h),
                  StepperTextField(
                    controllerValue: provider.ctlGstInNumber,
                    hintValue: 'GSTIN Number',
                    inputType: TextInputType.text,
                    validate: (val) => null,
                  ),
                  SizedBox(height: 12.h),
                  StepperTextField(
                    rOnly: true,
                    onTap: () {
                      _selectState(context, provider);
                    },
                    controllerValue: provider.ctlState,
                    hintValue: 'State',
                    inputType: TextInputType.streetAddress,
                    validate: (val) => null,
                  ),
                  provider.errorState.isNotEmpty
                      ? ErrorText(error: provider.errorState)
                      : SizedBox(height: 12.h),
                  StepperTextField(
                    controllerValue: provider.ctlShippingAddress,
                    hintValue: 'Shipping Address',
                    inputType: TextInputType.multiline,
                    actionNext: TextInputAction.newline,
                    maxLine: 4,
                    validate: (val) => null,
                  ),
                  SizedBox(height: 20.h),
                  AppAddPartButtonWidget(
                    onTap: () {
                      final isValid = _formKey.currentState!.validate();
                      if (!isValid) {
                        return;
                      }
                      provider.addCustomer(context);
                    },
                    btnText: 'Add Customer',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _selectState(BuildContext context, AddCustomerProvider provider) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: const Radius.circular(30.0).r),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            var filteredData = provider.ctlStateName.text.isEmpty
                ? provider.stateList
                : provider.stateList.where((e) => e.name.toLowerCase().contains(
                    provider.ctlStateName.text.toLowerCase(),
                  )).toList();

            return Padding(
              padding: EdgeInsets.only(
                top: 30.sp,
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 15.sp,
                right: 15.sp,
              ),
              child: SizedBox(
                height: 350.h,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Select State', style: TextStyle(fontSize: 20.sp)),
                    SizedBox(height: 20.h),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20).w,
                      child: TextFormField(
                        controller: provider.ctlStateName,
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: secondary,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search State...',
                          suffixIcon: Icon(Icons.search, color: primaryColor),
                          contentPadding: const EdgeInsets.only(left: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: secondary,
                              width: 1.5,
                            ),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        onChanged: (String value) {
                          setState(() {
                            // Trigger rebuild to filter states
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredData.length,
                        physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        ),
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              provider.stateOnClick(filteredData[index], context);
                            },
                            title: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Text(filteredData[index].name.toString()),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((value) {
      setState(() {});
    });
  }
}