import 'dart:async';

import 'package:fast_quote/Screens/Product/product_model.dart';
import 'package:fast_quote/Screens/Product/product_provider.dart';
import 'package:fast_quote/Utils/constants.dart';
import 'package:fast_quote/Utils/route_names.dart';
import 'package:fast_quote/Widgets/common_appbar.dart';
import 'package:fast_quote/Widgets/error_found_widget.dart';
import 'package:fast_quote/Widgets/no_data_found.dart';
import 'package:fast_quote/Widgets/shimmer_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatefulWidget {
  final String onClicked, fromPage, action;
  const ProductScreen(
      {super.key,
      required this.onClicked,
      required this.fromPage,
      required this.action});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = Provider.of<ProductProvider>(context, listen: false);
      provider.getProductData(context);
    });
    super.initState();
  }

  navigateToAddProduct() async {
    await Navigator.pushNamed(context, RouteNames.addProductScreen)
        .then(onRefresh);
  }

  navigateToEditCustomer(dynamic data) async {
    await Navigator.pushNamed(context, RouteNames.editProductScreen,
        arguments: {"model": data}).then(onRefresh);
  }

  FutureOr onRefresh(dynamic value) {
    final provider = Provider.of<ProductProvider>(context, listen: false);
    provider.getProductData(context);
  }

  _addProduct(BuildContext context, ProductModel productModel) async {
    Object? data;
    if (widget.fromPage == "Enquiry") {
      data = await Navigator.of(context)
          .pushNamed(RouteNames.addProductEnquiry, arguments: {
        "model": productModel,
      });
    } else if (widget.fromPage == "Quotation") {
      data = await Navigator.of(context).pushNamed(
          RouteNames.addProductQuotation,
          arguments: {"model": productModel, "action": widget.action});
    } else if (widget.fromPage == "Invoice") {
      data = await Navigator.of(context).pushNamed(RouteNames.addProductInvoice,
          arguments: {"model": productModel, "action": widget.action});
    }

    if (!mounted) return;

    setState(() {
      if (data != null) {
        Navigator.pop(context, data as ProductModel);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: commonAppBar(
        context: context,
        heading: 'Product',
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
                    provider.getProductData(context);
                  })
              : Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                      child: TextField(
                        controller: provider.searchController,
                        decoration: InputDecoration(
                            hintText: 'Search Product...',
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
                            passedData: 'No Product Found ..',
                          )
                        : Expanded(
                            child: ListView.separated(
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  height: 2.h,
                                );
                              },
                              padding: EdgeInsets.symmetric(
                                  vertical: 5.h, horizontal: 5.w),
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: provider.searchResultList.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                      side: BorderSide(color: secondary)),
                                  child: InkWell(
                                    onTap: widget.onClicked == "true"
                                        ? () {
                                            // Navigator.pop(
                                            //     context,
                                            //     provider
                                            //         .searchResultList[index]);
                                            _addProduct(
                                                context,
                                                provider
                                                    .searchResultList[index]);
                                          }
                                        : () {
                                            navigateToEditCustomer(provider
                                                .searchResultList[index]);
                                          },
                                    child: Padding(
                                      padding: EdgeInsets.all(15.sp),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            provider.searchResultList[index]
                                                .productName!,
                                            style: headerTextStyle(),
                                          ),
                                          SizedBox(height: 10.h),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    "Price : ",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: secondary,
                                                      fontSize: 12.sp,
                                                    ),
                                                  ),
                                                  Text(
                                                    provider
                                                        .searchResultList[index]
                                                        .productPrice!,
                                                    style: subTextStyle(),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "Unit : ",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: secondary,
                                                      fontSize: 12.sp,
                                                    ),
                                                  ),
                                                  Text(
                                                    provider
                                                        .searchResultList[index]
                                                        .productUnit!,
                                                    style: subTextStyle(),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 2.h),
                                          Row(
                                            children: [
                                              Text(
                                                "${provider.taxHintValue} : ",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: secondary,
                                                  fontSize: 12.sp,
                                                ),
                                              ),
                                              Text(
                                                provider.searchResultList[index]
                                                    .productGST!,
                                                style: subTextStyle(),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                  ],
                ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Add Product'),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        backgroundColor: primaryColor,
        onPressed: () {
          navigateToAddProduct();
        },
      ),
    );
  }
}
