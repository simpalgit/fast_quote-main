import 'dart:convert';

import 'package:fast_quote/Screens/Terms/TermsSection/QuotationTerms/quotation_terms_provider.dart';
import 'package:fast_quote/Screens/Terms/TermsSection/terms_repository.dart';
import 'package:fast_quote/Screens/Terms/terms_model.dart';
import 'package:fast_quote/Utils/common_functions.dart';
import 'package:fast_quote/Utils/constants.dart';
import 'package:fast_quote/Widgets/common_appbar.dart';
import 'package:fast_quote/Widgets/common_loaders.dart';
import 'package:fast_quote/Widgets/error_found_widget.dart';
import 'package:fast_quote/Widgets/no_data_found.dart';
import 'package:fast_quote/Widgets/shimmer_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../Widgets/add_part_button.dart';
import '../../../../Widgets/input_fields.dart';

class QuotationTermsScreen extends StatefulWidget {
  final bool fromAddTerm;
  final BuildContext baseContext;
  final List<TermsModel> selectedTerms;
  const QuotationTermsScreen(
      {super.key,
      required this.fromAddTerm,
      required this.baseContext,
      required this.selectedTerms});

  @override
  State<QuotationTermsScreen> createState() => _QuotationTermsScreenState();
}

class _QuotationTermsScreenState extends State<QuotationTermsScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var provider =
          Provider.of<QuotationTermsProvider>(context, listen: false);
      provider.getTermsData(widget.selectedTerms, context);
    });
    super.initState();
  }

  int segmentedControlGroupValue = 2;
  String type = "Quotation";
  final Map<int, Widget> myTabs = const <int, Widget>{
    0: Text("Enquiry"),
    1: Text("Invoice"),
    2: Text("Quotation")
  };

  bool isLoadingButton = false;
  String errorTerm = "";
  TermsRepository termsRepository = TermsRepository();
  final TextEditingController _ctlTerms = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  Future<void> addTerm(
      String type, String termData, QuotationTermsProvider provider) async {
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
        } else {
          Navigator.pop(context);
          // provider.getTermsData(provider.selectedList);

          provider.getLastRecord(context);
          CommonFunctions.showSuccessSnackbar("Term Added.");
        }
      }
      setState(() {
        isLoadingButton = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<QuotationTermsProvider>(context);
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: widget.fromAddTerm
          ? commonAppBar(
              onPressed: () {
                List<TermsModel> termModel = [];

                termModel = provider.searchResultList
                    .where((element) => element.isSelected == true)
                    .toList();

                Navigator.pop(context, termModel);
              },
              widgetList: [
                IconButton(
                    onPressed: () {
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
                                                          color:
                                                              Colors.black87),
                                                      shape: BoxShape.circle),
                                                  child:
                                                      const Icon(Icons.close)),
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
                                                child:
                                                    CupertinoSlidingSegmentedControl(
                                                  thumbColor: primaryColor,
                                                  children: {
                                                    0: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 10),
                                                      child: Text(
                                                        "Enquiry",
                                                        style: TextStyle(
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: segmentedControlGroupValue ==
                                                                    0
                                                                ? Colors.white
                                                                : Colors
                                                                    .black87),
                                                      ),
                                                    ),
                                                    1: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 10),
                                                      child: Text(
                                                        "Invoice",
                                                        style: TextStyle(
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: segmentedControlGroupValue ==
                                                                    1
                                                                ? Colors.white
                                                                : Colors
                                                                    .black87),
                                                      ),
                                                    ),
                                                    2: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 10),
                                                      child: Text(
                                                        "Quotation",
                                                        style: TextStyle(
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: segmentedControlGroupValue ==
                                                                    2
                                                                ? Colors.white
                                                                : Colors
                                                                    .black87),
                                                      ),
                                                    ),
                                                  },
                                                  groupValue:
                                                      segmentedControlGroupValue,
                                                  onValueChanged:
                                                      (int? newValue) {
                                                    setState(() {
                                                      segmentedControlGroupValue =
                                                          newValue!;

                                                      if (newValue == 0) {
                                                        type = "Enquiry";
                                                      } else if (newValue ==
                                                          1) {
                                                        type = "Invoice";
                                                      } else if (newValue ==
                                                          2) {
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
                                                          isLoadingButton =
                                                              true;
                                                        });

                                                        addTerm(
                                                            type,
                                                            _ctlTerms.text
                                                                .trim(),
                                                            provider);
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
                    icon: Icon(
                      CupertinoIcons.add,
                      color: secondary,
                    ))
              ],
              context: context,
              heading: 'Select Terms',
              subtitle: ' (Quotation)')
          : null,
      body: provider.errorEnable
          ? ErrorFoundWidget(
              errorString: provider.errorText,
              onTap: () {
                provider.getTermsData(widget.selectedTerms, context);
              })
          : provider.isLoading
              ? ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 5.h,
                    );
                  },
                  padding:
                      EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          side: const BorderSide(
                              color: Color.fromARGB(255, 221, 221, 221))),
                      child: Padding(
                        padding: EdgeInsets.all(15.sp),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShimmerBox(width: double.infinity, height: 7.h),
                            SizedBox(height: 8.h),
                            ShimmerBox(width: size.width / 2, height: 7.h),
                            SizedBox(height: 8.h),
                            ShimmerBox(width: size.width / 3, height: 7.h),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 5.h, horizontal: 10.w),
                        child: TextField(
                          controller: provider.searchController,
                          decoration: InputDecoration(
                              hintText: 'Search Term ...',
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
                        ),
                      ),
                      widget.fromAddTerm
                          ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              child: SizedBox(
                                width: double.infinity,
                                child: CheckboxListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10.w, vertical: 0),
                                  checkColor: Colors.white,
                                  checkboxShape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  activeColor: Colors.green,
                                  controlAffinity:
                                      ListTileControlAffinity.trailing,
                                  title: Text(
                                    "Select All",
                                    style: TextStyle(
                                        color: secondary,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  value: provider.selectAll,
                                  onChanged: (bool? value) {
                                    provider.selectAllTerms(
                                      value!,
                                    );
                                  },
                                ),
                              ),
                            )
                          : Container(),
                      provider.noDataFound
                          ? const NoDataFoundScreen(
                              passedData: 'No Term Found ..',
                            )
                          : widget.fromAddTerm
                              ? Expanded(
                                  child: ListView.separated(
                                    separatorBuilder: (context, index) {
                                      return SizedBox(
                                        height: 2.h,
                                      );
                                    },
                                    physics: const BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5.h, horizontal: 5.h),
                                    itemCount: provider.searchResultList.length,
                                    itemBuilder: (context, index) {
                                      return Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                            side: BorderSide(
                                                width: provider
                                                        .searchResultList[index]
                                                        .isSelected!
                                                    ? 2
                                                    : 1,
                                                color: provider
                                                        .searchResultList[index]
                                                        .isSelected!
                                                    ? primaryColor
                                                    : const Color.fromARGB(
                                                        255, 221, 221, 221))),
                                        child: Padding(
                                          padding: EdgeInsets.all(15.sp),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                width: double.infinity,
                                                child: CheckboxListTile(
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  checkColor: Colors.white,
                                                  checkboxShape:
                                                      RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15)),
                                                  activeColor: primaryColor,
                                                  controlAffinity:
                                                      ListTileControlAffinity
                                                          .leading,
                                                  title: Text(
                                                    provider
                                                        .searchResultList[index]
                                                        .term!,
                                                    style: TextStyle(
                                                        color: secondary,
                                                        fontSize: 12.sp,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  value: provider
                                                      .searchResultList[index]
                                                      .isSelected,
                                                  onChanged: (bool? value) {
                                                    provider.changeSelection(
                                                        value!,
                                                        provider.searchResultList[
                                                            index]);
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Expanded(
                                  child: ListView.separated(
                                    separatorBuilder: (context, index) {
                                      return SizedBox(
                                        height: 2.h,
                                      );
                                    },
                                    physics: const BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5.h, horizontal: 5.h),
                                    itemCount: provider.searchResultList.length,
                                    itemBuilder: (context, index) {
                                      return Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                            side: const BorderSide(
                                                color: Color.fromARGB(
                                                    255, 221, 221, 221))),
                                        child: Padding(
                                          padding: EdgeInsets.all(15.sp),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      _ctlTerms.text = provider
                                                          .searchResultList[
                                                              index]
                                                          .term!;

                                                      segmentedControlGroupValue =
                                                          2;
                                                      showModalBottomSheet(
                                                          context: widget
                                                              .baseContext,
                                                          isScrollControlled:
                                                              true,
                                                          backgroundColor:
                                                              Colors.white,
                                                          shape:
                                                              const RoundedRectangleBorder(
                                                            side: BorderSide(
                                                                color: Colors
                                                                    .black87),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .vertical(
                                                              top: Radius
                                                                  .circular(8),
                                                            ),
                                                          ),
                                                          builder:
                                                              (_) => SizedBox(
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsets.only(
                                                                          left:
                                                                              15,
                                                                          right:
                                                                              15,
                                                                          top:
                                                                              15,
                                                                          bottom: MediaQuery.of(widget.baseContext)
                                                                              .viewInsets
                                                                              .bottom),
                                                                      child: StatefulBuilder(builder:
                                                                          (context,
                                                                              setState) {
                                                                        return Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Row(
                                                                              children: [
                                                                                Expanded(
                                                                                  child: Text(
                                                                                    'Update Term',
                                                                                    style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, letterSpacing: 1.5, fontSize: 15.sp),
                                                                                  ),
                                                                                ),
                                                                                InkWell(
                                                                                  onTap: () {
                                                                                    _ctlTerms.clear();

                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                  child: Container(decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black87), shape: BoxShape.circle), child: const Icon(Icons.close)),
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
                                                                                          padding: const EdgeInsets.symmetric(vertical: 10),
                                                                                          child: Text(
                                                                                            "Enquiry",
                                                                                            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: segmentedControlGroupValue == 0 ? Colors.white : Colors.black87),
                                                                                          ),
                                                                                        ),
                                                                                        1: Padding(
                                                                                          padding: const EdgeInsets.symmetric(vertical: 10),
                                                                                          child: Text(
                                                                                            "Invoice",
                                                                                            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: segmentedControlGroupValue == 1 ? Colors.white : Colors.black87),
                                                                                          ),
                                                                                        ),
                                                                                        2: Padding(
                                                                                          padding: const EdgeInsets.symmetric(vertical: 10),
                                                                                          child: Text(
                                                                                            "Quotation",
                                                                                            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: segmentedControlGroupValue == 2 ? Colors.white : Colors.black87),
                                                                                          ),
                                                                                        ),
                                                                                      },
                                                                                      groupValue: segmentedControlGroupValue,
                                                                                      onValueChanged: (int? newValue) {
                                                                                        setState(() {
                                                                                          segmentedControlGroupValue = newValue!;

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
                                                                                  provider.errorTerm.isEmpty
                                                                                      ? Container()
                                                                                      : ErrorText(
                                                                                          error: provider.errorTerm,
                                                                                        ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 20.h,
                                                                            ),
                                                                            provider.isLoading
                                                                                ? const CommonButtonLoader()
                                                                                : AppAddPartButtonWidget(
                                                                                    onTap: provider.isLoading
                                                                                        ? null
                                                                                        : () {
                                                                                            final isValid = _formKey.currentState!.validate();

                                                                                            if (!isValid) {
                                                                                              return;
                                                                                            }

                                                                                            provider.editTerm(context, type, _ctlTerms.text.trim(), provider.searchResultList[index].termId!);
                                                                                            // addTerm(type, _ctlTerms.text);
                                                                                            // _formKey.currentState!.save();
                                                                                          },
                                                                                    btnText: 'Update Term'),
                                                                            SizedBox(
                                                                              height: 20.h,
                                                                            ),
                                                                          ],
                                                                        );
                                                                      }),
                                                                    ),
                                                                  ));
                                                    },
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(5.sp),
                                                      decoration: BoxDecoration(
                                                          color: primaryColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.r)),
                                                      child: const Icon(
                                                        Icons.edit_note_rounded,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 20.w,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      showModalBottomSheet(
                                                          context: widget
                                                              .baseContext,
                                                          isScrollControlled:
                                                              true,
                                                          backgroundColor:
                                                              Colors.white,
                                                          shape:
                                                              const RoundedRectangleBorder(
                                                            side: BorderSide(
                                                                color: Colors
                                                                    .black87),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .vertical(
                                                              top: Radius
                                                                  .circular(8),
                                                            ),
                                                          ),
                                                          builder:
                                                              (_) => SizedBox(
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsets.only(
                                                                          left:
                                                                              15,
                                                                          right:
                                                                              15,
                                                                          top:
                                                                              15,
                                                                          bottom: MediaQuery.of(widget.baseContext)
                                                                              .viewInsets
                                                                              .bottom),
                                                                      child: StatefulBuilder(builder:
                                                                          (context,
                                                                              setState) {
                                                                        return Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Row(
                                                                              children: [
                                                                                Expanded(
                                                                                  child: Text(
                                                                                    'Are you sure you want to delete term ??',
                                                                                    style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, letterSpacing: 1.5, fontSize: 15.sp),
                                                                                  ),
                                                                                ),
                                                                                InkWell(
                                                                                  onTap: () {
                                                                                    _ctlTerms.clear();

                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                  child: Container(decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black87), shape: BoxShape.circle), child: const Icon(Icons.close)),
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
                                                                                        provider.deleteTerm(context, provider.searchResultList[index].termId!);
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
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(5.sp),
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Colors.red[300],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.r)),
                                                      child: const Icon(
                                                        Icons.delete_rounded,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Text(
                                                provider.searchResultList[index]
                                                    .term!,
                                                style: TextStyle(
                                                    color: secondary,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                      SizedBox(
                        height: 30.h,
                      )
                    ],
                  ),
                ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: widget.fromAddTerm
          ? FloatingActionButton.extended(
              label: const Text('Select'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r)),
              backgroundColor: primaryColor,
              onPressed: () {
                List<TermsModel> termModel = [];

                termModel = provider.searchResultList
                    .where((element) => element.isSelected == true)
                    .toList();

                Navigator.pop(context, termModel);
              },
            )
          : null,
    );
  }
}
