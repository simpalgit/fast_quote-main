import 'package:fast_quote/Screens/Customer/customer_model.dart';
import 'package:fast_quote/Screens/Product/product_model.dart';
import 'package:fast_quote/Screens/Quotation/quotation_helper.dart';
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
import '../../Invoice/CreateInvoice/create_invoice.dart';
import 'create_quotation_provider.dart';

class CreateQuotationPdf extends StatefulWidget {
  final String quotationData, quotationNo, from, enqId;
  const CreateQuotationPdf({
    required this.quotationNo,
    required this.quotationData,
    required this.from,
    required this.enqId,
    super.key,
  });

  @override
  State<CreateQuotationPdf> createState() => _CreateQuotationPdfState();
}

class _CreateQuotationPdfState extends State<CreateQuotationPdf> {
  bool isSavedAsTemplate = false;
  double totalTax = 0.0,
      totalAmtDue = 0.0,
      subTotalTax = 0.0,
      subTotalDiscount = 0.0,
      appliedTotalTaxAmt = 0.0;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<FormState> _dialogueFormKey = GlobalKey();
  bool roundOffAmt = false, isPercentage = false;
  List<ProductModel> productList = [];
  List<TermsModel> termsList = [];
  List<OtherchargesModel> otherChargeList = [];
  String quoteDate = "", quoteNumber = "";
  double discAmt = 0.0, subTotal = 0.0;
  final TextEditingController _ctlOtherCharge = TextEditingController();
  final TextEditingController _ctlOtherChargeAmt = TextEditingController();
  final TextEditingController _ctlTaxInPercent = TextEditingController();
  final TextEditingController ctlDisc = TextEditingController();
  final TextEditingController _ctlTotalTax = TextEditingController();

  bool isChecked = true, addedDiscount = false;

  String discountStatus = "", taxStatus = "";
  bool isBtnLoading = false;
  DateTime selectedDate = DateTime.now();

  String totalApplyTax = "0";

  CustomerModel customerModel = CustomerModel();
  @override
  void initState() {
    getData();
    super.initState();
  }

  bool findcharges(String id) {
    for (var i in otherChargeList) {
      if (id == i.id.toString()) {
        return true;
      }
    }
    return false;
  }

  getData() async {
    _ctlOtherCharge.text =
        await LocalPreferences().getOtherChargesLabel() ?? "";
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final provider =
          Provider.of<CreateQuotationProvider>(context, listen: false);
      provider.getManageBusinessData(context).then((value) {
        provider.getHomeData(context).then((value) {
          provider.getQuotationSettingsData(context).then((value) {
            discountStatus = provider.quoteInvSettingModel.discount!;
            taxStatus = provider.quoteInvSettingModel.tax!;
            if (widget.quotationData != "") {
              if (widget.from == "Quotation" || widget.from == "Template") {
                var listOfData = QuotationHelper().getDataFromQuotation(
                    context: context,
                    enquiryData: widget.quotationData,
                    discountStatus: discountStatus,
                    taxStatus: taxStatus,
                    quoteNum: provider.quoteNum,
                    addedDiscount: addedDiscount,
                    isPercentage: isPercentage,
                    from: widget.from);

                customerModel = listOfData[0];

                productList = listOfData[1];
                otherChargeList = listOfData[2];

                termsList = listOfData[3];
                quoteDate = listOfData[4];
                quoteNumber = listOfData[5];
                roundOffAmt = listOfData[6];

                totalApplyTax = listOfData[7].toString();
                _ctlTotalTax.text = listOfData[7].toString();

                ctlDisc.text = listOfData[8].toString();

                isPercentage = listOfData[9];
                addedDiscount = listOfData[10];

                taxAndAmtCalculator();
              } else {
                var listOfData = QuotationHelper().getConvertToQuotationData(
                    context: context,
                    enquiryData: widget.quotationData,
                    discountStatus: discountStatus,
                    taxStatus: taxStatus,
                    quoteNum: provider.quoteNum);

                customerModel = listOfData[0];

                productList = listOfData[1];

                otherChargeList = listOfData[2];

                termsList = listOfData[3];

                quoteDate = listOfData[4];
                quoteNumber = listOfData[5];
                roundOffAmt = listOfData[6];

                totalApplyTax = "0";
                _ctlTotalTax.text = "0";

                discAmt = 0.0;
                ctlDisc.text = "0";

                taxAndAmtCalculator();
              }
            } else {
              isSavedAsTemplate = false;
              quoteDate = DateFormat('yyyy-MM-dd').format(selectedDate);
              quoteNumber = provider.quoteNum;
            }
          });
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

  addCustomer(BuildContext context) async {
    customerModel = await QuotationHelper().addCustomer(context);
    setState(() {});
  }

  _addProduct(BuildContext context) async {
    productList =
        await QuotationHelper().addProduct(context, productList, "Create");
    taxAndAmtCalculator();
  }

  _editProduct(BuildContext context, ProductModel productModel) async {
    productList = await QuotationHelper()
        .editProduct(context, productList, productModel, "Create");
    taxAndAmtCalculator();
  }

  _addTerms(BuildContext context) async {
    termsList = await QuotationHelper().addTerms(context, termsList);
    taxAndAmtCalculator();
  }

  taxAndAmtCalculator() async {
    var calculatedData = await QuotationHelper().calculationFunction(
        context: context,
        roundOftotalAmtDue: roundOftotalAmtDue,
        totalAmtDue: totalAmtDue,
        totalTax: totalTax,
        subTotal: subTotal,
        subTotalTax: subTotalTax,
        subTotalDiscount: subTotalDiscount,
        otherChargeList: otherChargeList,
        productList: productList,
        taxStatus: taxStatus,
        discountStatus: discountStatus,
        ctlTotalTax: _ctlTotalTax.text,
        ctlDisc: ctlDisc.text,
        isPercentage: isPercentage,
        discAmt: discAmt,
        totalApplyTax: totalApplyTax,
        appliedTotalTaxAmt: appliedTotalTaxAmt);

    roundOftotalAmtDue = calculatedData[0];
    totalAmtDue = calculatedData[1];
    totalTax = calculatedData[2];
    subTotal = calculatedData[3];
    subTotalTax = calculatedData[4];
    subTotalDiscount = calculatedData[5];
    otherChargeList = calculatedData[6];
    _ctlTotalTax.text = calculatedData[7];
    ctlDisc.text = calculatedData[8];
    isPercentage = calculatedData[9];
    discAmt = calculatedData[10];
    totalApplyTax = calculatedData[11];
    appliedTotalTaxAmt = calculatedData[12];

    setState(() {});
  }

  @override
  void dispose() {
    _ctlOtherCharge.dispose();
    _ctlOtherChargeAmt.dispose();
    _ctlTaxInPercent.dispose();
    ctlDisc.dispose();
    _ctlTotalTax.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final provider = Provider.of<CreateQuotationProvider>(
      context,
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: commonAppBar(
        context: context,
        heading: 'Create Quotation',
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
                                  'Quotation No.',
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor),
                                ),
                                SizedBox(
                                  height: 4.h,
                                ),
                                Text(
                                  quoteNumber,
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
                                  'Quotation Date',
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor),
                                ),
                                SizedBox(
                                  height: 4.h,
                                ),
                                Text(
                                  quoteDate,
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
                            taxStatus == "On Total"
                                ? Padding(
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 10)),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  backgroundColor: bgColor,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      15.0))),
                                                  contentPadding:
                                                      const EdgeInsets
                                                              .symmetric(
                                                          vertical: 22,
                                                          horizontal: 15),
                                                  content: Form(
                                                    key: _dialogueFormKey,
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              'Apply Tax',
                                                              style: TextStyle(
                                                                  color:
                                                                      secondary,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            const Spacer(),
                                                            InkWell(
                                                              onTap: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Container(
                                                                  decoration: BoxDecoration(
                                                                      border: Border.all(
                                                                          color:
                                                                              secondary),
                                                                      shape: BoxShape
                                                                          .circle),
                                                                  child: Icon(
                                                                    Icons.close,
                                                                    color:
                                                                        secondary,
                                                                  )),
                                                            ),
                                                            SizedBox(
                                                              width: 10.w,
                                                            )
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 12.h,
                                                        ),
                                                        ModelTextField(
                                                          mLength: 3,
                                                          suf: const Icon(Icons
                                                              .percent_rounded),
                                                          controllerValue:
                                                              _ctlTotalTax,
                                                          hintValue: 'Tax',
                                                          inputType:
                                                              TextInputType
                                                                  .number,
                                                          validateValue:
                                                              'Enter Tax.',
                                                        ),
                                                        SizedBox(
                                                          height: 12.h,
                                                        ),
                                                        ElevatedButton(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      15,
                                                                  vertical: 10),
                                                              shape: const RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              15.0))),
                                                            ),
                                                            onPressed: () {
                                                              final isValid =
                                                                  _dialogueFormKey
                                                                      .currentState!
                                                                      .validate();
                                                              if (!isValid) {
                                                                return;
                                                              }
                                                              setState(() {
                                                                totalApplyTax =
                                                                    _ctlTotalTax
                                                                        .text;
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                              taxAndAmtCalculator();
                                                            },
                                                            child: const Text(
                                                                'Apply'))
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          child: Text(
                                            'Applied Tax on Disc Amt\n($totalApplyTax%)',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: whiteColor,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ),
                                  )
                                : Container(),
                            SizedBox(
                              height: 8.h,
                            ),
                            AddCardHelper(
                              heading: "To",
                              onPressed: () {
                                addCustomer(context);
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
                                _addProduct(
                                  context,
                                );
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
                                                _editProduct(
                                                  context,
                                                  productList[index],
                                                );
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
                                                      discountStatus ==
                                                              "Per item"
                                                          ? RowHelperCard(
                                                              title: productList[
                                                                              index]
                                                                          .discountType ==
                                                                      "Percentage"
                                                                  ? "Disc (${productList[index].discountPercentage!}%)"
                                                                  : "Disc",
                                                              value:
                                                                  "- \u{20B9}${productList[index].discountAmt!}")
                                                          : Container(),
                                                      productList[index]
                                                              .isDiscount!
                                                          ? SizedBox(
                                                              height: 2.h)
                                                          : Container(),
                                                      taxStatus == "Per item"
                                                          ? RowHelperCard(
                                                              title:
                                                                  "Tax (${productList[index].productGST!}%)",
                                                              value:
                                                                  "\u{20B9}${productList[index].productAppliedGST!}")
                                                          : const SizedBox(),
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
                            SizedBox(
                              height: 15.h,
                            ),
                            discountStatus == "On Total"
                                ? InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          backgroundColor: Colors.white,
                                          shape: const RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: Colors.black87),
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
                                                          MediaQuery.of(context)
                                                              .viewInsets
                                                              .bottom),
                                                  child: StatefulBuilder(
                                                      builder:
                                                          (context, setState) {
                                                    return Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
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
                                                              child: Text(
                                                                'Add Quotation Discount',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black87,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    letterSpacing:
                                                                        1.5,
                                                                    fontSize:
                                                                        15.sp),
                                                              ),
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Container(
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      border: Border.all(
                                                                          color: Colors
                                                                              .black87),
                                                                      shape: BoxShape
                                                                          .circle),
                                                                  child: const Icon(
                                                                      Icons
                                                                          .close)),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 20.h,
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  contentPadding:
                                                                      const EdgeInsets
                                                                          .symmetric(
                                                                    vertical: 5,
                                                                  ),
                                                                  content:
                                                                      Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      ListTile(
                                                                        title:
                                                                            const Text(
                                                                          'Percentage',
                                                                        ),
                                                                        onTap:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            isPercentage =
                                                                                true;
                                                                            ctlDisc.clear();
                                                                          });
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                      ),
                                                                      ListTile(
                                                                        title: const Text(
                                                                            'Flat Amount'),
                                                                        onTap:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            isPercentage =
                                                                                false;
                                                                            ctlDisc.clear();
                                                                          });
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                          },
                                                          child: Card(
                                                            margin:
                                                                EdgeInsets.zero,
                                                            color: Colors.white,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(12
                                                                            .r),
                                                                side: const BorderSide(
                                                                    color: Colors
                                                                        .grey)),
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          15.0,
                                                                      horizontal:
                                                                          12.w),
                                                              child: Column(
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                        isPercentage
                                                                            ? 'Add Discount (Percentage)'
                                                                            : 'Add Discount (Flat Amt)',
                                                                        style:
                                                                            const TextStyle(
                                                                          color:
                                                                              Colors.black87,
                                                                        ),
                                                                      ),
                                                                      const Icon(
                                                                        CupertinoIcons
                                                                            .chevron_forward,
                                                                        size:
                                                                            18,
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
                                                          controllerValue:
                                                              ctlDisc,
                                                          hintValue: isPercentage
                                                              ? 'Discount (in %)'
                                                              : 'Flat Amount',
                                                          inputType:
                                                              TextInputType
                                                                  .number,
                                                          validate: (val) {
                                                            return null;
                                                          },
                                                          onChange: (value) {
                                                            if (value == ".") {
                                                              setState(() {
                                                                ctlDisc.clear();
                                                              });
                                                            }
                                                          },
                                                        ),
                                                        SizedBox(
                                                          height: 20.h,
                                                        ),
                                                        AppAddPartButtonWidget(
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context);
                                                              setState(
                                                                () {
                                                                  addedDiscount =
                                                                      true;
                                                                },
                                                              );
                                                              taxAndAmtCalculator();
                                                            },
                                                            btnText:
                                                                'Add Discount'),
                                                        SizedBox(
                                                          height: 20.h,
                                                        ),
                                                      ],
                                                    );
                                                  }),
                                                ),
                                              ));
                                    },
                                    child: Column(
                                      children: [
                                        const AddCardHelper(
                                          heading: "Discount on Product total",
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        addedDiscount
                                            ? Card(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 15.w),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.r),
                                                    side: BorderSide(
                                                        color: secondary)),
                                                child: Padding(
                                                  padding:
                                                      EdgeInsets.all(15.sp),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        isPercentage
                                                            ? 'Total discount (${ctlDisc.text} %)'
                                                            : 'Total discount',
                                                        style: TextStyle(
                                                            color: secondary,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      const Spacer(),
                                                      Text(
                                                        '- \u{20B9}${discAmt.toStringAsFixed(2)}',
                                                        style: TextStyle(
                                                            color: secondary,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              addedDiscount =
                                                                  false;
                                                              ctlDisc.clear();
                                                              isPercentage =
                                                                  false;
                                                            });
                                                            taxAndAmtCalculator();
                                                          },
                                                          child: const Icon(
                                                              Icons.delete))
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : Container()
                                      ],
                                    ),
                                  )
                                : Container(),
                            discountStatus == "On Total"
                                ? SizedBox(
                                    height: 10.h,
                                  )
                                : Container(),
                            AddCardHelper(
                              heading: "Other Charge",
                              onPressed: () {
                                setState(() {
                                  isChecked = false;
                                  _ctlOtherChargeAmt.clear();
                                  _ctlTaxInPercent.clear();
                                });
                                _otherCharges(context, provider);
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
                                            _editCharges(
                                                context, data, provider);
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
                          setState(
                            () {
                              roundOffAmt = value!;
                              roundOftotalAmtDue = totalAmtDue.toInt();

                              taxAndAmtCalculator();
                            },
                          );
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
                        '\u{20B9}${totalTax.toStringAsFixed(2)}',
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

                            if (ctlDisc.text.isEmpty) {
                              ctlDisc.text = "0";
                            }

                            dynamic returnedData = await QuotationHelper()
                                .createQuotation(
                                    customerModel: customerModel,
                                    context: context,
                                    productList: productList,
                                    termsList: termsList,
                                    otherChargeList: otherChargeList,
                                    roundOffAmt: roundOffAmt,
                                    totalAmtDue: totalAmtDue,
                                    selectedDate: selectedDate,
                                    quoteNumber: quoteNumber,
                                    roundOftotalAmtDue: roundOftotalAmtDue,
                                    totalTax: totalTax,
                                    businessModel: provider.businessModel,
                                    quoteInvSettingModel:
                                        provider.quoteInvSettingModel,
                                    subTotal: subTotal,
                                    subTotalTax: subTotalTax,
                                    addedDiscount: addedDiscount,
                                    isPercentage: isPercentage,
                                    ctlDisc: ctlDisc.text,
                                    discAmt: discAmt,
                                    subTotalDiscount: subTotalDiscount,
                                    appliedTotalTaxAmt: appliedTotalTaxAmt,
                                    totalApplyTax: totalApplyTax);
                            if (returnedData != null) {
                              provider
                                  .uploadQuotation(context, returnedData[0],
                                      returnedData[1], widget.enqId)
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
  _otherCharges(BuildContext context, CreateQuotationProvider provider) {
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
                            List<double> taxAmt = [];
                            if (isChecked) {
                              taxAmt = CommonFunctions.getAmountForTax(
                                  _ctlTaxInPercent.text,
                                  double.parse(_ctlOtherChargeAmt.text));
                            } else {
                              taxAmt.insert(0, 0.0);
                              taxAmt.insert(1, 0.0);
                              _ctlTaxInPercent.clear();
                            }

                            otherChargeList.add(OtherchargesModel(
                                id: otherChargeList.length + 1,
                                title: _ctlOtherCharge.text,
                                amount: _ctlOtherChargeAmt.text,
                                tax: _ctlTaxInPercent.text,
                                taxAmt: taxAmt[1].toStringAsFixed(2),
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

  _editCharges(BuildContext context, OtherchargesModel model,
      CreateQuotationProvider provider) {
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
