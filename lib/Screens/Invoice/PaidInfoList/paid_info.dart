import 'package:fast_quote/Utils/constants.dart';
import 'package:fast_quote/Widgets/add_part_button.dart';
import 'package:fast_quote/Widgets/common_appbar.dart';
import 'package:fast_quote/Widgets/input_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../Widgets/no_data_found.dart';
import 'paid_info_provider.dart';

class PaidInfoListScreen extends StatefulWidget {
  const PaidInfoListScreen({super.key});

  @override
  State<PaidInfoListScreen> createState() => _PaidInfoListScreenState();
}

class _PaidInfoListScreenState extends State<PaidInfoListScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = Provider.of<PaidInfoProvider>(context, listen: false);
      provider.initData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PaidInfoProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, provider.paidInfoList);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: commonAppBar(
          context: context,
          heading: 'Paid Info ',
          onPressed: () {
            Navigator.pop(context, provider.paidInfoList);
          },
        ),
        body: Column(
          children: [
            provider.paidInfoList.isEmpty
                ? const Expanded(
                    child: Center(
                      child: NoDataFoundScreen(
                        passedData: 'No Info Available ..',
                      ),
                    ),
                  )
                : Expanded(
                    child: ListView.separated(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        itemBuilder: (context, index) {
                          var data = provider.paidInfoList[index];
                          return Card(
                            margin: EdgeInsets.symmetric(horizontal: 15.w),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                                side: BorderSide(color: secondary)),
                            child: InkWell(
                              onTap: () {},
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.sp, vertical: 5.sp),
                                child: SizedBox(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Amount",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13.sp,
                                                      color: secondary),
                                                ),
                                                const Spacer(),
                                                Text(
                                                  data.amount.toString(),
                                                  style: TextStyle(
                                                      fontSize: 12.sp,
                                                      color: secondary),
                                                ),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                provider.deleteData(data.id!);
                                              },
                                              icon: const Icon(
                                                  CupertinoIcons.delete)),
                                          IconButton(
                                              onPressed: () {
                                                provider.setValues(data);
                                                showModalBottomSheet(
                                                    context: context,
                                                    isDismissible: false,
                                                    isScrollControlled: true,
                                                    backgroundColor:
                                                        Colors.white,
                                                    shape:
                                                        const RoundedRectangleBorder(
                                                      side: BorderSide(
                                                          color:
                                                              Colors.black87),
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                        top: Radius.circular(8),
                                                      ),
                                                    ),
                                                    builder: (context) {
                                                      return Padding(
                                                        padding: EdgeInsets.only(
                                                            left: 15,
                                                            right: 15,
                                                            top: 15,
                                                            bottom:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .viewInsets
                                                                    .bottom),
                                                        child: StatefulBuilder(
                                                            builder: (context,
                                                                setState) {
                                                          return Form(
                                                            key: _formKey,
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        'Paid Info',
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .black87,
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            letterSpacing:
                                                                                1.5,
                                                                            fontSize:
                                                                                15.sp),
                                                                      ),
                                                                    ),
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        provider
                                                                            .clearDialogueFields();
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child: Container(
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.white,
                                                                              border: Border.all(color: Colors.black87),
                                                                              shape: BoxShape.circle),
                                                                          child: const Icon(Icons.close)),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: 20.h,
                                                                ),
                                                                StepperTextField(
                                                                  controllerValue:
                                                                      provider
                                                                          .ctlPaidDate,
                                                                  hintValue:
                                                                      'Paid Date',
                                                                  validate:
                                                                      (val) {
                                                                    if (val!
                                                                        .isEmpty) {
                                                                      return "Field Cant be empty";
                                                                    } else {
                                                                      return null;
                                                                    }
                                                                  },
                                                                  rOnly: true,
                                                                  onTap: () {
                                                                    provider.selectPaidDate(
                                                                        context);
                                                                  },
                                                                ),
                                                                SizedBox(
                                                                  height: 15.h,
                                                                ),
                                                                StepperTextField(
                                                                  controllerValue:
                                                                      provider
                                                                          .ctlAmount,
                                                                  hintValue:
                                                                      'Amount',
                                                                  inputType:
                                                                      TextInputType
                                                                          .number,
                                                                  validate:
                                                                      (val) {
                                                                    if (val!
                                                                        .isEmpty) {
                                                                      return "Field Cant be empty";
                                                                    } else {
                                                                      return null;
                                                                    }
                                                                  },
                                                                ),
                                                                SizedBox(
                                                                  height: 15.h,
                                                                ),
                                                                StepperTextField(
                                                                  controllerValue:
                                                                      provider
                                                                          .ctlNotes,
                                                                  hintValue:
                                                                      'Note',
                                                                  maxLine: 4,
                                                                  inputType:
                                                                      TextInputType
                                                                          .text,
                                                                  validate:
                                                                      (val) {
                                                                    return null;
                                                                  },
                                                                ),
                                                                SizedBox(
                                                                  height: 20.h,
                                                                ),
                                                                AppAddPartButtonWidget(
                                                                    onTap: () {
                                                                      final isValid = _formKey
                                                                          .currentState!
                                                                          .validate();

                                                                      if (!isValid) {
                                                                        return;
                                                                      }

                                                                      provider.updateData(
                                                                          PaidInfoModel(
                                                                              id: data.id.toString(),
                                                                              note: provider.ctlNotes.text,
                                                                              paidDate: provider.ctlPaidDate.text,
                                                                              amount: double.parse(provider.ctlAmount.text)),
                                                                          context);
                                                                    },
                                                                    btnText:
                                                                        'Add Paid info'),
                                                                SizedBox(
                                                                  height: 20.h,
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        }),
                                                      );
                                                    });
                                              },
                                              icon: const Icon(CupertinoIcons
                                                  .pencil_circle_fill))
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Paid Date',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13.sp,
                                                color: secondary),
                                          ),
                                          const Spacer(),
                                          Text(
                                            data.paidDate!,
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                color: secondary),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Note',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13.sp,
                                                color: secondary),
                                          ),
                                          const SizedBox(
                                            width: 40,
                                          ),
                                          Flexible(
                                            child: Text(
                                              data.note! == ""
                                                  ? "-"
                                                  : data.note!,
                                              style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color: secondary),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: 10.h,
                          );
                        },
                        itemCount: provider.paidInfoList.length),
                  ),
            SizedBox(
              height: 10.h,
            ),
            AppAddPartButtonSmall(
                onTap: () {
                  showModalBottomSheet(
                      isDismissible: false,
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
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child:
                                  StatefulBuilder(builder: (context, setState) {
                                return Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              'Paid Info',
                                              style: TextStyle(
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 1.5,
                                                  fontSize: 15.sp),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              provider.clearDialogueFields();
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: Colors.black87),
                                                    shape: BoxShape.circle),
                                                child: const Icon(Icons.close)),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20.h,
                                      ),
                                      StepperTextField(
                                        controllerValue: provider.ctlPaidDate,
                                        hintValue: 'Paid Date',
                                        validate: (val) {
                                          if (val!.isEmpty) {
                                            return "Field Cant be empty";
                                          } else {
                                            return null;
                                          }
                                        },
                                        rOnly: true,
                                        onTap: () {
                                          provider.selectPaidDate(context);
                                        },
                                      ),
                                      SizedBox(
                                        height: 15.h,
                                      ),
                                      StepperTextField(
                                        controllerValue: provider.ctlAmount,
                                        hintValue: 'Amount',
                                        inputType: TextInputType.number,
                                        validate: (val) {
                                          if (val!.isEmpty) {
                                            return "Field Cant be empty";
                                          } else {
                                            return null;
                                          }
                                        },
                                      ),
                                      SizedBox(
                                        height: 15.h,
                                      ),
                                      StepperTextField(
                                        controllerValue: provider.ctlNotes,
                                        hintValue: 'Note',
                                        maxLine: 4,
                                        inputType: TextInputType.text,
                                        validate: (val) {
                                          return null;
                                        },
                                      ),
                                      SizedBox(
                                        height: 20.h,
                                      ),
                                      AppAddPartButtonWidget(
                                          onTap: () {
                                            final isValid = _formKey
                                                .currentState!
                                                .validate();

                                            if (!isValid) {
                                              return;
                                            }

                                            int length =
                                                provider.paidInfoList.length;
                                            int indez = length + 1;

                                            provider.addData(
                                                PaidInfoModel(
                                                    id: indez.toString(),
                                                    note:
                                                        provider.ctlNotes.text,
                                                    paidDate: provider
                                                        .ctlPaidDate.text,
                                                    amount: double.parse(
                                                        provider
                                                            .ctlAmount.text)),
                                                context);
                                          },
                                          btnText: 'Add Discount'),
                                      SizedBox(
                                        height: 20.h,
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ),
                          ));
                },
                btnText: 'Add Paid Amount'),
            SizedBox(
              height: 10.h,
            ),
          ],
        ),
      ),
    );
  }
}
