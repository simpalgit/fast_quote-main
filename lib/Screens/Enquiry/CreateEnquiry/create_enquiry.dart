import 'package:fast_quote/Screens/Customer/customer_model.dart';
import 'package:fast_quote/Screens/Enquiry/enquiry_helper.dart';
import 'package:fast_quote/Screens/Invoice/CreateInvoice/create_invoice.dart';
import 'package:fast_quote/Screens/Product/product_model.dart';
import 'package:fast_quote/Screens/Terms/terms_model.dart';
import 'package:fast_quote/Utils/common_functions.dart';
import 'package:fast_quote/Utils/constants.dart';
import 'package:fast_quote/Utils/local_shared_preferences.dart';
import 'package:fast_quote/Widgets/add_card.dart';
import 'package:fast_quote/Widgets/add_part_button.dart';
import 'package:fast_quote/Widgets/common_appbar.dart';
import 'package:fast_quote/Widgets/common_loaders.dart';
import 'package:fast_quote/Widgets/input_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../Auth/other_charges_model.dart';
import 'create_enquiry_provider.dart';

class CreateEnquiryPdf extends StatefulWidget {
  final String enquiryData, from;
  const CreateEnquiryPdf({
    super.key,
    required this.enquiryData,
    required this.from,
  });

  @override
  State<CreateEnquiryPdf> createState() => _CreateEnquiryPdfState();
}

class _CreateEnquiryPdfState extends State<CreateEnquiryPdf> {
  double totalTax = 0.0, totalAmtDue = 0.0, subTotal = 0.0, productTax = 0.0;
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool roundOffAmt = false;
  List<ProductModel> productList = [];
  List<TermsModel> termsList = [];
  List<OtherchargesModel> otherChargeList = [];
  String enqDate = "", enqNumber = "";
  DateTime selectedDate = DateTime.now();
  CustomerModel customerModel = CustomerModel();
  bool isBtnLoading = false;

  final TextEditingController _ctlOtherCharge = TextEditingController();
  final TextEditingController _ctlOtherChargeAmt = TextEditingController();
  final TextEditingController _ctlTaxInPercent = TextEditingController();

  bool isChecked = false;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    _ctlOtherCharge.text =
        await LocalPreferences().getOtherChargesLabel() ?? "";
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final provider =
          Provider.of<CreateEnquiryProvider>(context, listen: false);
      provider.getManageBusinessData(context).then((value) {
        provider.getHomeData(context).then((value) {
          if (widget.enquiryData != "") {
            var listOfData = EnquiryHelper().getEnquiryData(
                enquiryData: widget.enquiryData,
                from: widget.from,
                enqNum: provider.enqNum);

            customerModel = listOfData[0];

            productList = listOfData[1];

            otherChargeList = listOfData[2];

            termsList = listOfData[3];

            enqDate = listOfData[4];
            enqNumber = listOfData[5];
            roundOffAmt = listOfData[6];
            totalAmtDue = listOfData[7];
            totalTax = listOfData[8];
            taxAndAmtCalculator();
          } else {
            enqDate = DateFormat('yyyy-MM-dd').format(selectedDate);
            enqNumber = provider.enqNum;
          }
        });
      });
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked == null) {
      return;
    }
    if (picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  _addCustomer(BuildContext context) async {
    customerModel = await EnquiryHelper().addCustomer(context);
    setState(() {});
  }

  _addProduct(BuildContext context) async {
    productList = await EnquiryHelper().addProduct(context, productList);
    taxAndAmtCalculator();
  }

  _editProduct(BuildContext context, ProductModel productModel) async {
    productList =
        await EnquiryHelper().editProduct(context, productList, productModel);
    taxAndAmtCalculator();
  }

  _addTerms(BuildContext context) async {
    termsList = await EnquiryHelper().addTerms(context, termsList);
    taxAndAmtCalculator();
  }

  taxAndAmtCalculator() {
    var calculatedData = EnquiryHelper().calculationFunction(
        roundOftotalAmtDue: totalAmtDue.toInt(),
        totalAmtDue: totalAmtDue,
        totalTax: totalTax,
        subTotal: subTotal,
        productTax: productTax,
        otherChargeList: otherChargeList,
        productList: productList);

    roundOftotalAmtDue = calculatedData[0];
    totalAmtDue = calculatedData[1];
    totalTax = calculatedData[2];
    subTotal = calculatedData[3];
    productTax = calculatedData[4];

    setState(() {});
  }

  bool findcharges(String id) {
    for (var i in otherChargeList) {
      if (id == i.id.toString()) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final provider = Provider.of<CreateEnquiryProvider>(
      context,
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: commonAppBar(
        context: context,
        heading: 'Create Enquiry',
      ),
      body: provider.isLoading
          ? Center(
              child: progressIndicator(context),
            )
          : Column(
              children: [
                SizedBox(
                  height: 5.h,
                ),
                GestureDetector(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.r)),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 15.w),
                    child: ClipPath(
                      clipper: ShapeBorderClipper(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r))),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: yellowColor, width: 8),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.w, vertical: 8.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Enquiry No.',
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor),
                                ),
                                SizedBox(
                                  height: 4.h,
                                ),
                                Text(
                                  enqNumber,
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                      color: secondary),
                                )
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Enquiry Date',
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor),
                                ),
                                SizedBox(
                                  height: 4.h,
                                ),
                                Text(
                                  enqDate,
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                      color: secondary),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Expanded(
                  child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: EdgeInsets.only(top: 8.h, bottom: 30.h),
                        child: Column(
                          children: [
                            AddCardHelper(
                              heading: "To",
                              onPressed: () {
                                _addCustomer(context);
                              },
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            customerModel.companyName == null
                                ? Container()
                                : Stack(
                                    children: [
                                      Card(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 15.w),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                            side: BorderSide(color: secondary)),
                                        child: Padding(
                                          padding: EdgeInsets.all(15.sp),
                                          child: SizedBox(
                                            width: size.width,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  customerModel.customerName!,
                                                  style: headerTextStyle(),
                                                ),
                                                SizedBox(height: 10.h),
                                                Text(
                                                  customerModel.companyName!,
                                                  style: subTextStyle(),
                                                ),
                                                SizedBox(height: 2.h),
                                                Text(
                                                  customerModel.mobile!,
                                                  style: subTextStyle(),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 20,
                                        child: IconButton(
                                            onPressed: () {
                                              customerModel = CustomerModel(
                                                  companyName: null,
                                                  customerName: null,
                                                  email: null,
                                                  mobile: null,
                                                  addressOne: null,
                                                  addressTwo: null,
                                                  otherInfo: null,
                                                  gstin: null,
                                                  state: null,
                                                  shippingAddress: null);
                                              setState(() {});
                                            },
                                            icon: const Icon(
                                                CupertinoIcons.delete)),
                                      )
                                    ],
                                  ),
                            SizedBox(
                              height: 15.h,
                            ),
                            AddCardHelper(
                              heading: "Products",
                              onPressed: () {
                                _addProduct(context);
                              },
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            productList.isNotEmpty
                                ? ListView.separated(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    separatorBuilder: (context, index) {
                                      return SizedBox(
                                        height: 10.h,
                                      );
                                    },
                                    shrinkWrap: true,
                                    itemCount: productList.length,
                                    itemBuilder: (context, index) {
                                      return Stack(
                                        children: [
                                          Card(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 15.w),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                                side: BorderSide(
                                                    color: secondary)),
                                            child: InkWell(
                                              onTap: () {
                                                _editProduct(context,
                                                    productList[index]);
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.all(15.sp),
                                                child: SizedBox(
                                                  width: size.width,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        productList[index]
                                                            .productName!,
                                                        style:
                                                            headerTextStyle(),
                                                      ),
                                                      SizedBox(height: 10.h),
                                                      RowHelperCard(
                                                          title: "Amount",
                                                          value:
                                                              '${productList[index].productQuantity!} x \u{20B9}${productList[index].productPrice!} = \u{20B9}${productList[index].productTotal!}'),
                                                      SizedBox(height: 2.h),
                                                      RowHelperCard(
                                                          title:
                                                              "Tax (${productList[index].productGST!}%)",
                                                          value:
                                                              "\u{20B9}${productList[index].productAppliedGST!}"),
                                                      SizedBox(height: 2.h),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            "Total amount",
                                                            style:
                                                                subTextStyle(),
                                                          ),
                                                          Text(
                                                            "\u{20B9}${productList[index].productTaxAmount!}",
                                                            style:
                                                                headerTextStyle(),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            right: 20,
                                            child: IconButton(
                                                onPressed: () {
                                                  if (productList.isNotEmpty) {
                                                    productList.removeAt(index);
                                                  }

                                                  taxAndAmtCalculator();
                                                },
                                                icon: const Icon(
                                                    CupertinoIcons.delete)),
                                          )
                                        ],
                                      );
                                    },
                                  )
                                : Container(),
                            // productList.isEmpty
                            //     ? SizedBox(
                            //         height: 15.h,
                            //       )
                            //     : const SizedBox(),
                            SizedBox(
                              height: 15.h,
                            ),
                            AddCardHelper(
                              heading: "Other Charge",
                              onPressed: () {
                                setState(() {
                                  isChecked = false;
                                  _ctlOtherChargeAmt.clear();
                                  _ctlTaxInPercent.clear();
                                });
                                _otherCharges(context);
                              },
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            otherChargeList.isNotEmpty
                                ? ListView.separated(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    separatorBuilder: (context, index) {
                                      return SizedBox(
                                        height: 10.h,
                                      );
                                    },
                                    shrinkWrap: true,
                                    itemCount: otherChargeList.length,
                                    itemBuilder: (context, index) {
                                      var data = otherChargeList[index];
                                      return Card(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 15.w),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                            side: BorderSide(color: secondary)),
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              isChecked = data.isTaxable!;
                                              _ctlOtherCharge.text =
                                                  data.title!;
                                              _ctlOtherChargeAmt.text =
                                                  data.amount!;
                                              _ctlTaxInPercent.text = data.tax!;
                                            });
                                            _editCharges(context, data);
                                          },
                                          child: Padding(
                                            padding: !data.isTaxable!
                                                ? EdgeInsets.symmetric(
                                                    horizontal: 10.sp,
                                                    vertical: 0.sp)
                                                : EdgeInsets.symmetric(
                                                    horizontal: 10.sp,
                                                    vertical: 5.sp),
                                            child: SizedBox(
                                              width: size.width,
                                              child: Row(
                                                children: [
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        data.title!,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14.sp,
                                                            color: secondary),
                                                      ),
                                                      !data.isTaxable!
                                                          ? Container()
                                                          : SizedBox(
                                                              height: 3.h,
                                                            ),
                                                      !data.isTaxable!
                                                          ? Container()
                                                          : Text(
                                                              "Tax (${data.tax!}%):",
                                                              style:
                                                                  subTextStyle(),
                                                            ),
                                                    ],
                                                  ),
                                                  const Spacer(),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        "\u{20B9}${data.amount!}",
                                                        style:
                                                            headerTextStyle(),
                                                      ),
                                                      !data.isTaxable!
                                                          ? Container()
                                                          : SizedBox(
                                                              height: 3.h,
                                                            ),
                                                      !data.isTaxable!
                                                          ? Container()
                                                          : Text(
                                                              "\u{20B9}${data.taxAmt!}",
                                                              style:
                                                                  subTextStyle(),
                                                            ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: 2.w,
                                                  ),
                                                  IconButton(
                                                      onPressed: () {
                                                        if (otherChargeList
                                                            .isNotEmpty) {
                                                          otherChargeList
                                                              .removeAt(index);
                                                        }

                                                        taxAndAmtCalculator();
                                                      },
                                                      icon: Icon(
                                                        CupertinoIcons.delete,
                                                        size: 18.sp,
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : Container(),
                            SizedBox(
                              height: 15.h,
                            ),
                            AddCardHelper(
                              heading: "Terms & Conditions",
                              onPressed: () {
                                _addTerms(context);
                              },
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            termsList.isNotEmpty
                                ? ListView.separated(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    separatorBuilder: (context, index) {
                                      return SizedBox(
                                        height: 10.h,
                                      );
                                    },
                                    shrinkWrap: true,
                                    itemCount: termsList.length,
                                    itemBuilder: (context, index) {
                                      return Card(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 15.w),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                            side: BorderSide(color: secondary)),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 15.sp,
                                              horizontal: 12.sp),
                                          child: SizedBox(
                                            width: size.width,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: size.width * 0.75,
                                                  child: Text(
                                                    termsList[index].term!,
                                                    style: TextStyle(
                                                        color: secondary,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                const Spacer(),
                                                InkWell(
                                                    onTap: () {
                                                      termsList.removeWhere(
                                                          (element) =>
                                                              element.termId ==
                                                              termsList[index]
                                                                  .termId);

                                                      setState(() {});
                                                    },
                                                    child: const Icon(
                                                        CupertinoIcons.delete)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : Container(),
                            SizedBox(
                              height: 120.h,
                            ),
                          ],
                        ),
                      )),
                ),
                SizedBox(
                  height: 10.h,
                ),
              ],
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: secondary, borderRadius: BorderRadius.circular(25.r)),
        margin: const EdgeInsets.only(
            left: 8.0, right: 8.0, bottom: 10), // Optional margin for padding
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 8.sp),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              productList.isNotEmpty || otherChargeList.isNotEmpty
                  ? SizedBox(
                      width: double.infinity,
                      child: CheckboxListTile(
                        dense: true,
                        side: MaterialStateBorderSide.resolveWith(
                          (states) => BorderSide(width: 2.0, color: whiteColor),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 0.w, vertical: 0),
                        checkColor: secondary,
                        checkboxShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        activeColor: whiteColor,
                        controlAffinity: ListTileControlAffinity.trailing,
                        title: Text(
                          "Round Off Amount",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold),
                        ),
                        value: roundOffAmt,
                        onChanged: (bool? value) {
                          roundOffAmt = value!;
                          roundOftotalAmtDue = totalAmtDue.toInt();
                          taxAndAmtCalculator();
                        },
                      ),
                    )
                  : Container(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Total Tax',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        '\u{20B9}$totalTax',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Amount Due',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        roundOffAmt
                            ? '\u{20B9}$roundOftotalAmtDue'
                            : '\u{20B9}${totalAmtDue.toStringAsFixed(2)}',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  InkWell(
                    onTap: isBtnLoading
                        ? null
                        : () async {
                            setState(() {
                              isBtnLoading = true;
                            });
                            dynamic returnedData = await EnquiryHelper()
                                .createEnquiry(
                                    customerModel,
                                    context,
                                    productList,
                                    termsList,
                                    otherChargeList,
                                    roundOffAmt,
                                    totalAmtDue,
                                    selectedDate,
                                    provider.enqNum,
                                    roundOftotalAmtDue,
                                    totalTax,
                                    provider.businessModel,
                                    productTax,
                                    subTotal);

                            if (returnedData != null) {
                              provider
                                  .uploadEnquiry(
                                      context, returnedData[0], returnedData[1])
                                  .then((value) {
                                setState(() {
                                  isBtnLoading = false;
                                });
                              });
                            } else {
                              setState(() {
                                isBtnLoading = false;
                              });
                            }
                          },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 25.sp, vertical: 12.sp),
                      decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(25.r)),
                      child: isBtnLoading
                          ? const CommonButtonLoader()
                          : const Text('Generate'),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  int roundOftotalAmtDue = 0;
  _otherCharges(BuildContext context) {
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
              return Padding(
                padding: EdgeInsets.only(
                    top: 30.sp,
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    left: 15.sp,
                    right: 15.sp),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Other Charge Info',
                        style: TextStyle(
                            fontSize: 15.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      StepperTextField(
                        controllerValue: _ctlOtherCharge,
                        mLength: 20,
                        hintValue: 'Other Charges',
                        inputType: TextInputType.text,
                        validate: (val) {
                          if (val!.isEmpty) {
                            return "Field Cant be empty.";
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      StepperTextField(
                        controllerValue: _ctlOtherChargeAmt,
                        hintValue: 'Other Charge Amount',
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
                        height: 5.h,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: CheckboxListTile(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 5.w, vertical: 0),
                          checkColor: Colors.white,
                          checkboxShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          activeColor: Colors.green,
                          controlAffinity: ListTileControlAffinity.trailing,
                          title: Text(
                            "Is Taxable ?",
                            style: TextStyle(
                                color: secondary,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold),
                          ),
                          value: isChecked,
                          onChanged: (bool? value) {
                            setState(
                              () {
                                if (!value!) {
                                  _ctlTaxInPercent.clear();
                                }
                                isChecked = value;
                              },
                            );
                          },
                        ),
                      ),
                      isChecked
                          ? SizedBox(
                              height: 5.h,
                            )
                          : Container(),
                      isChecked
                          ? StepperTextField(
                              controllerValue: _ctlTaxInPercent,
                              suf: const Icon(
                                Icons.percent_rounded,
                              ),
                              hintValue: 'Tax (IN %)',
                              inputType: TextInputType.number,
                              validate: (val) {
                                if (isChecked) {
                                  if (val!.isEmpty) {
                                    return "Field Cant be empty.";
                                  } else {
                                    return null;
                                  }
                                } else {
                                  return null;
                                }
                              },
                            )
                          : Container(),
                      isChecked
                          ? SizedBox(
                              height: 15.h,
                            )
                          : Container(),
                      AppAddPartButtonWidget(
                          onTap: () {
                            final isValid = _formKey.currentState!.validate();

                            if (!isValid) {
                              return;
                            }

                            List taxAmt = [];
                            if (isChecked) {
                              taxAmt = CommonFunctions.getAmountForTax(
                                  _ctlTaxInPercent.text,
                                  double.parse(_ctlOtherChargeAmt.text));
                            } else {
                              taxAmt.insert(0, "0.0");
                              taxAmt.insert(1, "0.0");
                              _ctlTaxInPercent.clear();
                            }

                            otherChargeList.add(OtherchargesModel(
                                id: otherChargeList.length + 1,
                                title: _ctlOtherCharge.text,
                                amount: _ctlOtherChargeAmt.text,
                                tax: _ctlTaxInPercent.text,
                                taxAmt: taxAmt[1].toString(),
                                isTaxable: isChecked));

                            taxAndAmtCalculator();

                            Navigator.pop(context);
                          },
                          btnText: 'Save'),
                      SizedBox(
                        height: 25.h,
                      ),
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

  _editCharges(BuildContext context, OtherchargesModel model) {
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
              return Padding(
                padding: EdgeInsets.only(
                    top: 30.sp,
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    left: 15.sp,
                    right: 15.sp),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Other Charge Info',
                        style: TextStyle(
                            fontSize: 15.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      StepperTextField(
                        mLength: 20,
                        controllerValue: _ctlOtherCharge,
                        hintValue: 'Other Charges',
                        inputType: TextInputType.text,
                        validate: (val) {
                          if (val!.isEmpty) {
                            return "Field Cant be empty.";
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      StepperTextField(
                        controllerValue: _ctlOtherChargeAmt,
                        hintValue: 'Other Charge Amount',
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
                        height: 5.h,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: CheckboxListTile(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 5.w, vertical: 0),
                          checkColor: Colors.white,
                          checkboxShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          activeColor: Colors.green,
                          controlAffinity: ListTileControlAffinity.trailing,
                          title: Text(
                            "Is Taxable ?",
                            style: TextStyle(
                                color: secondary,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold),
                          ),
                          value: isChecked,
                          onChanged: (bool? value) {
                            setState(
                              () {
                                isChecked = value!;
                              },
                            );
                          },
                        ),
                      ),
                      isChecked
                          ? SizedBox(
                              height: 5.h,
                            )
                          : Container(),
                      isChecked
                          ? StepperTextField(
                              controllerValue: _ctlTaxInPercent,
                              suf: const Icon(
                                Icons.percent_rounded,
                              ),
                              hintValue: 'Tax (IN %)',
                              inputType: TextInputType.number,
                              validate: (val) {
                                if (isChecked) {
                                  if (val!.isEmpty) {
                                    return "Field Cant be empty.";
                                  } else {
                                    return null;
                                  }
                                } else {
                                  return null;
                                }
                              },
                            )
                          : Container(),
                      isChecked
                          ? SizedBox(
                              height: 15.h,
                            )
                          : Container(),
                      AppAddPartButtonWidget(
                          onTap: () {
                            final isValid = _formKey.currentState!.validate();

                            if (!isValid) {
                              return;
                            }
                            List taxAmt = [];
                            if (isChecked) {
                              taxAmt = CommonFunctions.getAmountForTax(
                                  _ctlTaxInPercent.text,
                                  double.parse(_ctlOtherChargeAmt.text));
                            } else {
                              _ctlTaxInPercent.clear();
                              taxAmt.insert(0, "0.0");
                              taxAmt.insert(1, "0.0");
                            }

                            if (findcharges(model.id.toString())) {
                              int indexOfBob = otherChargeList.indexWhere(
                                  (element) =>
                                      element.id.toString() ==
                                      model.id.toString());
                              otherChargeList[indexOfBob] = OtherchargesModel(
                                  id: model.id,
                                  title: _ctlOtherCharge.text,
                                  amount: _ctlOtherChargeAmt.text,
                                  tax: _ctlTaxInPercent.text,
                                  taxAmt: taxAmt[1].toString(),
                                  isTaxable: isChecked);
                            }
                            taxAndAmtCalculator();

                            Navigator.pop(context);
                          },
                          btnText: 'Save'),
                      SizedBox(
                        height: 25.h,
                      ),
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
