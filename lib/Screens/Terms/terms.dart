import 'dart:convert';

import 'package:fast_quote/Screens/Terms/TermsSection/EnquiryTerms/enquiry_terms_provider.dart';
import 'package:fast_quote/Screens/Terms/TermsSection/QuotationTerms/quotation_terms.dart';
import 'package:fast_quote/Screens/Terms/TermsSection/terms_repository.dart';
import 'package:fast_quote/Utils/common_functions.dart';
import 'package:fast_quote/Utils/constants.dart';
import 'package:fast_quote/Widgets/add_part_button.dart';
import 'package:fast_quote/Widgets/common_loaders.dart';
import 'package:fast_quote/Widgets/error_found_widget.dart';
import 'package:fast_quote/Widgets/input_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'TermsSection/EnquiryTerms/enquiry_terms.dart';
import 'TermsSection/InvoiceTerms/invoice_terms.dart';
import 'TermsSection/InvoiceTerms/invoice_terms_provider.dart';
import 'TermsSection/QuotationTerms/quotation_terms_provider.dart';

class TermsScreen extends StatefulWidget {
  final int initNumber;
  const TermsScreen({super.key, required this.initNumber});

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(
      length: 3,
      vsync: this,
    );
  }

  int segmentedControlGroupValue = 0;
  String type = "Enquiry";
  final Map<int, Widget> myTabs = const <int, Widget>{
    0: Text("Enquiry"),
    1: Text("Invoice"),
    2: Text("Quotation")
  };
  final TextEditingController _ctlTerms = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: DefaultTabController(
          length: 3,
          child: NestedScrollView(
            headerSliverBuilder: (context, value) {
              return [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  elevation: 0,
                  pinned: true,
                  floating: true,
                  snap: true,
                  title: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5).w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 25.h,
                            width: 40.w,
                            margin: EdgeInsets.only(right: 0.w),
                            decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(10).r),
                            child: Center(
                              child: Icon(
                                Icons.arrow_back_sharp,
                                color: whiteColor,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15.w,
                        ),
                        Text(
                          'Terms & Conditions',
                          style: TextStyle(
                              color: secondary, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  centerTitle: false,
                  bottom: TabBar(
                    controller: controller,
                    indicatorColor: primaryColor,
                    labelColor: primaryColor,
                    unselectedLabelColor: secondary,
                    labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold, letterSpacing: 1),
                    tabs: const [
                      Tab(text: "Enquiry"),
                      Tab(
                        text: "Invoice",
                      ),
                      Tab(text: "Quotation"),
                    ],
                  ),
                ),
              ];
            },
            body: isLoadingButton
                ? Container()
                : TabBarView(
                    controller: controller,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      EnquiryTermsScreen(
                        baseContext: context,
                        fromAddTerm: false,
                        selectedTerms: const [],
                      ),
                      InvoiceTermsScreen(
                        baseContext: context,
                        fromAddTerm: false,
                        selectedTerms: const [],
                      ),
                      QuotationTermsScreen(
                        baseContext: context,
                        fromAddTerm: false,
                        selectedTerms: const [],
                      ),
                    ],
                  ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          label: const Text('Add Term'),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          backgroundColor: primaryColor,
          onPressed: () {
            String type = "Enquiry";
            int segmentedControlGroupValue = controller.index;
            if (controller.index == 0) {
              type = "Enquiry";
            } else if (controller.index == 1) {
              type = "Invoice";
            } else if (controller.index == 2) {
              type = "Quotation";
            }

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
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: StatefulBuilder(builder: (context, setState) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Add Term',
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.5,
                                          fontSize: 15.sp),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      _ctlTerms.clear();

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
                              Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: CupertinoSlidingSegmentedControl(
                                        thumbColor: primaryColor,
                                        children: {
                                          0: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: Text(
                                              "Enquiry",
                                              style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      segmentedControlGroupValue ==
                                                              0
                                                          ? Colors.white
                                                          : Colors.black87),
                                            ),
                                          ),
                                          1: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: Text(
                                              "Invoice",
                                              style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      segmentedControlGroupValue ==
                                                              1
                                                          ? Colors.white
                                                          : Colors.black87),
                                            ),
                                          ),
                                          2: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: Text(
                                              "Quotation",
                                              style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      segmentedControlGroupValue ==
                                                              2
                                                          ? Colors.white
                                                          : Colors.black87),
                                            ),
                                          ),
                                        },
                                        groupValue: segmentedControlGroupValue,
                                        onValueChanged: (int? newValue) {
                                          setState(() {
                                            segmentedControlGroupValue =
                                                newValue!;

                                            if (newValue == 0) {
                                              type = "Enquiry";
                                            } else if (newValue == 1) {
                                              type = "Invoice";
                                            } else if (newValue == 2) {
                                              type = "Quotation";
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15.h,
                                    ),
                                    ModelTextField(
                                      controllerValue: _ctlTerms,
                                      hintValue: 'Term',
                                      inputType: TextInputType.text,
                                      maxLine: 5,
                                      validateValue: 'Enter Term.',
                                    ),
                                    errorTerm.isEmpty
                                        ? Container()
                                        : ErrorText(
                                            error: errorTerm,
                                          ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              isLoadingButton
                                  ? const CommonButtonLoader()
                                  : AppAddPartButtonWidget(
                                      onTap: isLoadingButton
                                          ? null
                                          : () {
                                              final isValid = _formKey
                                                  .currentState!
                                                  .validate();

                                              if (!isValid) {
                                                return;
                                              }
                                              setState(() {
                                                isLoadingButton = true;
                                              });

                                              addTerm(
                                                  type, _ctlTerms.text.trim());
                                              // _formKey.currentState!.save();
                                            },
                                      btnText: 'Add Term'),
                              SizedBox(
                                height: 20.h,
                              ),
                            ],
                          );
                        }),
                      ),
                    ));
          },
        ),
      ),
    );
  }

  bool isLoadingButton = false;
  String errorTerm = "";
  TermsRepository termsRepository = TermsRepository();
  Future<void> addTerm(String type, String termData) async {
    var passedData = json.encode({"type": type, "description": termData});
    var result = await termsRepository.addTerm(context, passedData);

    result.fold((error) {
      CommonFunctions.showErrorSnackbar(context, error.message);
    }, (data) {
      errorTerm = "";
      _ctlTerms.clear();
      if (data != null) {
        var responseJson = json.decode(data.body);

        if (data.statusCode == 400) {
          responseJson['error'].forEach((k, v) {
            if (k == "description") {
              errorTerm = v[0];
            }
          });
          setState(() {
            isLoadingButton = false;
          });
        } else {
          Navigator.pop(context);
          CommonFunctions.showSuccessSnackbar("Term Added.");
          setState(() {
            isLoadingButton = false;
          });

          if (type == "Enquiry") {
            controller.index = 0;
            var provider =
                Provider.of<EnquiryTermsProvider>(context, listen: false);
            provider.getTermsData([], context);
          } else if (type == "Invoice") {
            controller.index = 1;
            var provider =
                Provider.of<InvoiceTermsProvider>(context, listen: false);
            provider.getTermsData([], context);
          } else if (type == "Quotation") {
            controller.index = 2;
            var provider =
                Provider.of<QuotationTermsProvider>(context, listen: false);
            provider.getTermsData([], context);
          }
        }
      }
    });
  }
}
