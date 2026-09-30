import 'dart:async';

import 'package:fast_quote/Utils/common_functions.dart';
import 'package:fast_quote/Utils/constants.dart';
import 'package:fast_quote/Utils/generate_pdf/pdf_api.dart';
import 'package:fast_quote/Utils/route_names.dart';
import 'package:fast_quote/Widgets/common_appbar.dart';
import 'package:fast_quote/Widgets/error_found_widget.dart';
import 'package:fast_quote/Widgets/no_data_found.dart';
import 'package:fast_quote/Widgets/shimmer_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'challan_list_provider.dart';

class ChallanList extends StatefulWidget {
  const ChallanList({super.key});

  @override
  State<ChallanList> createState() => _ChallanListState();
}

class _ChallanListState extends State<ChallanList> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = Provider.of<ChallanListProvider>(context, listen: false);
      provider.getChallanData(context);
    });
    super.initState();
  }

  navigateToView(dynamic data, dynamic file) async {
    await Navigator.pushNamed(context, RouteNames.challanViewPage, arguments: {
      "file": file,
      "invoiceData": data.data,
      "invoiceListModel": data,
      "isSavedAsTemplate": false
    }).then(onRefresh);
  }

  FutureOr onRefresh(dynamic value) {
    final provider = Provider.of<ChallanListProvider>(context, listen: false);
    provider.getChallanData(context);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChallanListProvider>(
      context,
    );
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: commonAppBar(
        context: context,
        heading: 'Challan List',
      ),
      body: provider.isLoading
          ? ListView.separated(
              physics: const BouncingScrollPhysics(),
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: 5.h,
                );
              },
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
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
          : provider.errorEnable
              ? ErrorFoundWidget(
                  errorString: provider.errorText,
                  onTap: () {
                    provider.getChallanData(context);
                  })
              : Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                      child: TextField(
                        controller: provider.searchController,
                        decoration: InputDecoration(
                            hintText: 'Search Challan...',
                            suffixIcon: Icon(
                              Icons.search,
                              color: primaryColor,
                            ),
                            contentPadding: const EdgeInsets.only(left: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(color: Colors.grey),
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
                    provider.noDataFound
                        ? const NoDataFoundScreen(
                            passedData: 'No Challan Found ..',
                          )
                        : Expanded(
                            child: ListView.separated(
                                itemCount: provider.searchResultList.length,
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    height: 10.h,
                                  );
                                },
                                padding: EdgeInsets.symmetric(
                                    vertical: 5.h, horizontal: 0.w),
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  var data = provider.searchResultList[index];
                                  return Card(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10.w),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                        side: BorderSide(color: secondary)),
                                    child: InkWell(
                                      onTap: () async {
                                        try {
                                          final file =
                                              await PdfApi.loadNetworkFile(
                                                  data.invoicePdf);

                                          navigateToView(data, file);
                                        } catch (error) {
                                          CommonFunctions.showErrorSnackbar(
                                              context, "Network Error..");
                                        }
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(15.sp),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              data.companyName!,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13.sp,
                                                  color: secondary),
                                            ),
                                            const Spacer(),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  data.invoiceNum!,
                                                  style: TextStyle(
                                                      fontSize: 12.sp,
                                                      color: secondary),
                                                ),
                                                SizedBox(
                                                  height: 4.h,
                                                ),
                                                Text(
                                                  data.invoiceDate!,
                                                  style: TextStyle(
                                                      fontSize: 12.sp,
                                                      color: secondary),
                                                ),
                                                SizedBox(
                                                  height: 4.h,
                                                ),
                                                // Text(
                                                //   "\u{20B9}${data.!}",
                                                //   style: TextStyle(
                                                //       fontSize: 12.sp,
                                                //       color: secondary),
                                                // ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                  ],
                ),
    );
  }
}
