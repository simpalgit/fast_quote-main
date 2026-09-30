import 'package:fast_quote/Screens/Settings/Components/PaymentHistory/payment_history_provider.dart';
import 'package:fast_quote/Utils/constants.dart';
import 'package:fast_quote/Widgets/common_appbar.dart';
import 'package:fast_quote/Widgets/error_found_widget.dart';
import 'package:fast_quote/Widgets/no_data_found.dart';
import 'package:fast_quote/Widgets/shimmer_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class PaymmentHistory extends StatefulWidget {
  const PaymmentHistory({super.key});

  @override
  State<PaymmentHistory> createState() => _PaymmentHistoryState();
}

class _PaymmentHistoryState extends State<PaymmentHistory> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var historyProvider =
          Provider.of<PaymmentHistoryProvider>(context, listen: false);

      historyProvider.getPaymentHistory(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<PaymmentHistoryProvider>(
      context,
    );
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: commonAppBar(
        context: context,
        heading: 'Payment History',
      ),
      body: provider.errorEnable
          ? ErrorFoundWidget(
              errorString: provider.errorText,
              onTap: () {
                provider.getPaymentHistory(context);
              })
          : provider.isLoading
              ? ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 2.h,
                    );
                  },
                  padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          side: BorderSide(color: secondary)),
                      child: Padding(
                        padding: EdgeInsets.all(15.sp),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShimmerBox(width: double.infinity, height: 7.h),
                            SizedBox(height: 10.h),
                            ShimmerBox(width: size.width / 2, height: 7.h),
                            SizedBox(height: 5.h),
                            ShimmerBox(width: size.width / 3, height: 7.h),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : Column(
                  children: [
                    provider.noDataFound
                        ? const NoDataFoundScreen(
                            passedData: 'No History Found ..',
                          )
                        : Expanded(
                            child:
                             ListView.separated(
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  height: 5.h,
                                );
                              },
                              padding: EdgeInsets.symmetric(
                                  vertical: 5.h, horizontal: 5.w),
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: provider.historyModelList.length,
                              itemBuilder: (context, index) {
                                var data = provider.historyModelList[index];
                                return
                                 Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                      side: BorderSide(color: secondary)),
                                  child: InkWell(
                                    onTap: () {},
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
                                            Text(
                                              "Payment Status :",
                                              style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color: secondary,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              width: 10.w,
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 10),
                                              decoration: BoxDecoration(
                                                  color: data.cardColor,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  8.r),
                                                          topRight:
                                                              Radius.circular(
                                                                  8.r))),
                                              child: Text(
                                                data.state!,
                                                style: subTextStyleTwo(
                                                    Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 15.h,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15.sp),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "TransId : ${data.transactionId!}",
                                                style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: secondary,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 5.h,
                                              ),
                                              Text(
                                                "Subscription : ${data.subscriptionName!}",
                                                style: TextStyle(
                                                    fontSize: 13.sp,
                                                    color: secondary,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              SizedBox(
                                                height: 5.h,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "Payment Date : ",
                                                    style: TextStyle(
                                                        fontSize: 13.sp,
                                                        color: secondary,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  Text(
                                                    data.paymentDate!,
                                                    style: TextStyle(
                                                        fontSize: 13.sp,
                                                        color: secondary,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5.h,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "Amount : ",
                                                    style: TextStyle(
                                                        fontSize: 13.sp,
                                                        color: secondary,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  Text(
                                                    "\u{20B9}${data.amount!}",
                                                    style: TextStyle(
                                                        fontSize: 13.sp,
                                                        color: primaryColor,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              data.state == "FAILED"
                                                  ? SizedBox(
                                                      height: 5.h,
                                                    )
                                                  : const SizedBox(),
                                              data.state == "FAILED"
                                                  ? Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Reason : ",
                                                          style: TextStyle(
                                                              fontSize: 13.sp,
                                                              color: secondary,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                            data.responseCodeDescription!,
                                                            style: TextStyle(
                                                                fontSize: 13.sp,
                                                                color:
                                                                    Colors.red,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : const SizedBox(),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15.h,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                  ],
                ),
    );
  }
}
