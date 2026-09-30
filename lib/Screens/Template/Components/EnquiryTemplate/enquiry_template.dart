import 'dart:async';

import 'package:fast_quote/Screens/Template/Components/EnquiryTemplate/enquiry_template_provider.dart';
import 'package:fast_quote/Utils/common_functions.dart';
import 'package:fast_quote/Utils/constants.dart';
import 'package:fast_quote/Utils/generate_pdf/pdf_api.dart';
import 'package:fast_quote/Utils/route_names.dart';
import 'package:fast_quote/Widgets/error_found_widget.dart';
import 'package:fast_quote/Widgets/no_data_found.dart';
import 'package:fast_quote/Widgets/shimmer_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class EnquiryTemplateScreen extends StatefulWidget {
  const EnquiryTemplateScreen({super.key});

  @override
  State<EnquiryTemplateScreen> createState() => _EnquiryTemplateScreenState();
}

class _EnquiryTemplateScreenState extends State<EnquiryTemplateScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final provider =
          Provider.of<EnquiryTemplateProvider>(context, listen: false);
      provider.getEnquiryData(context);
    });
    super.initState();
  }

  navigateToView(dynamic data, dynamic file) async {
    await Navigator.pushNamed(context, RouteNames.enquiryTemplateViewPage,
        arguments: {
          "file": file,
          "enquiryData": data.data,
          "enquiryListModel": data,
        }).then(onRefresh);
  }

  FutureOr onRefresh(dynamic value) {
    final provider =
        Provider.of<EnquiryTemplateProvider>(context, listen: false);
    provider.getEnquiryData(context);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EnquiryTemplateProvider>(
      context,
    );
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: provider.isLoading
          ? ListView.separated(
              physics: const BouncingScrollPhysics(),
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: 5,
                );
              },
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              itemCount: 5,
              itemBuilder: (context, index) {
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      side: const BorderSide(
                          color: Color.fromARGB(255, 221, 221, 221))),
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerBox(width: double.infinity, height: 7),
                        SizedBox(height: 8),
                        ShimmerBox(width: size.width / 2, height: 7),
                        SizedBox(height: 8),
                        ShimmerBox(width: size.width / 3, height: 7),
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
                    provider.getEnquiryData(context);
                  })
              : Column(
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: TextField(
                        controller: provider.searchController,
                        decoration: InputDecoration(
                            hintText: 'Search Enquiry...',
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
                            passedData: 'No Enquiry Template Saved ..',
                          )
                        : Expanded(
                            child: ListView.separated(
                                itemCount: provider.searchResultList.length,
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    height: 10,
                                  );
                                },
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 0),
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  var data = provider.searchResultList[index];
                                  return Card(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8),
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
                                        padding: EdgeInsets.all(15),
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
                                                  fontSize: 13,
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
                                                  data.enquiryNum!,
                                                  style: TextStyle(
                                                      fontSize: 12.sp,
                                                      color: secondary),
                                                ),
                                                SizedBox(
                                                  height: 4.h,
                                                ),
                                                Text(
                                                  data.enquiryDate!,
                                                  style: TextStyle(
                                                      fontSize: 12.sp,
                                                      color: secondary),
                                                ),
                                                SizedBox(
                                                  height: 4.h,
                                                ),
                                                Text(
                                                  "\u{20B9}${data.amtDue!}",
                                                  style: TextStyle(
                                                      fontSize: 12.sp,
                                                      color: secondary),
                                                ),
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
