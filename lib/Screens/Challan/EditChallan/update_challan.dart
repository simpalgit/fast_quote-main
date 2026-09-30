import 'package:fast_quote/Screens/Challan/ChallanList/challan_list_model.dart';
import 'package:fast_quote/Screens/Challan/EditChallan/update_challan_provider.dart';
import 'package:fast_quote/Widgets/add_part_button.dart';
import 'package:fast_quote/Widgets/common_appbar.dart';
import 'package:fast_quote/Widgets/input_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class UpdateChallanScreen extends StatefulWidget {
  final ChallanListModel challanListModel;
  final String data;
  const UpdateChallanScreen(
      {super.key, required this.challanListModel, required this.data});

  @override
  State<UpdateChallanScreen> createState() => _UpdateChallanScreenState();
}

class _UpdateChallanScreenState extends State<UpdateChallanScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final provider =
          Provider.of<UpdateChallanProvider>(context, listen: false);
      provider.initData(widget.challanListModel);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UpdateChallanProvider>(
      context,
    );
    return Scaffold(
      appBar: commonAppBar(
        context: context,
        heading: 'Update Challan Details',
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 15.w, right: 15.w, bottom: 5.h),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Form(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 15.h,
                      ),
                      StepperTextField(
                        controllerValue: provider.ctlPhone,
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
                      SizedBox(
                        height: 12.h,
                      ),
                      StepperTextField(
                        controllerValue: provider.ctlTopMessage,
                        hintValue: 'Top Messsage',
                        inputType: TextInputType.name,
                        validate: (val) {
                          if (val!.isEmpty) {
                            return "Field Cant be empty";
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: 12.h,
                      ),
                      StepperTextField(
                        controllerValue: provider.ctlBottomMessage,
                        inputType: TextInputType.text,
                        validate: (val) {
                          if (val!.isEmpty) {
                            return "Field Cant be empty";
                          } else {
                            return null;
                          }
                        },
                        hintValue: "Bottom Messsage",
                        onChange: (p0) {},
                      ),
                      SizedBox(
                        height: 12.h,
                      ),
                      StepperTextField(
                        controllerValue: provider.ctlAddress,
                        hintValue: 'Address',
                        inputType: TextInputType.multiline,
                        actionNext: TextInputAction.newline,
                        validate: (val) {
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 12.h,
                      ),
                      StepperTextField(
                        controllerValue: provider.ctlShippingAddress,
                        hintValue: 'Shipping Address',
                        inputType: TextInputType.multiline,
                        actionNext: TextInputAction.newline,
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
                  provider.updateChallan(
                      context, widget.challanListModel, widget.data);
                },
                btnText: 'Update Challan'),
          ],
        ),
      ),
    );
  }
}
