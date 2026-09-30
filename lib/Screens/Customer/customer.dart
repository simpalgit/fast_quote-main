import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:fast_quote/Screens/Customer/customer_provider.dart';
import 'package:fast_quote/Utils/constants.dart';
import 'package:fast_quote/Utils/route_names.dart';
import 'package:fast_quote/Widgets/error_found_widget.dart';
import 'package:fast_quote/Widgets/shimmer_box.dart';
import 'package:fast_quote/Widgets/common_appbar.dart';
import 'package:fast_quote/Widgets/no_data_found.dart';

class CustomerScreen extends StatefulWidget {
  final String onClicked;
  const CustomerScreen({
    super.key,
    required this.onClicked,
  });

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = Provider.of<CustomerProvider>(context, listen: false);
      provider.getCustomerData(context);
    });
    super.initState();
  }

  navigateToAddCustomer() async {
    await Navigator.pushNamed(context, RouteNames.addCustomerScreen)
        .then(onRefresh);
  }

  navigateToEditCustomer(dynamic data) async {
    await Navigator.pushNamed(context, RouteNames.editCustomerScreen,
        arguments: {"model": data}).then(onRefresh);
  }

  FutureOr onRefresh(dynamic value) {
    final provider = Provider.of<CustomerProvider>(context, listen: false);
    provider.getCustomerData(context);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CustomerProvider>(context);
    var size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: commonAppBar(
          context: context,
          heading: 'Customer',
        ),
        body: provider.errorEnable
            ? ErrorFoundWidget(
                errorString: provider.errorText,
                onTap: () {
                  provider.getCustomerData(context);
                })
            : provider.isLoading
                ? ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 2);
                    },
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: secondary)),
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Column(
                            children: [
                              ShimmerBox(width: double.infinity, height: 7),
                              SizedBox(height: 10),
                              ShimmerBox(width: size.width / 2, height: 7),
                              SizedBox(height: 5),
                              ShimmerBox(width: size.width / 3, height: 7),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10),
                        child: TextField(
                          controller: provider.searchController,
                          decoration: InputDecoration(
                              hintText: 'Search customer...',
                              suffixIcon: Icon(Icons.search, color: primaryColor),
                              contentPadding: const EdgeInsets.only(left: 20),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(color: secondary, width: 1.5),
                              ),
                              fillColor: Colors.white,
                              filled: true),
                        ),
                      ),
                      provider.noDataFound
                          ? const NoDataFoundScreen(
                              passedData: 'No Customers Found ..',
                            )
                          : Expanded(
                              child: ListView.separated(
                                separatorBuilder: (context, index) {
                                  return SizedBox(height: 2);
                                },
                                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                physics: const BouncingScrollPhysics(),
                                itemCount: provider.searchResultList.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        side: BorderSide(color: secondary)),
                                    child: InkWell(
                                      onTap: widget.onClicked == "true"
                                          ? () {
                                              Navigator.pop(context, provider.searchResultList[index]);
                                            }
                                          : () {
                                              navigateToEditCustomer(provider.searchResultList[index]);
                                            },
                                      child: Padding(
                                        padding: EdgeInsets.all(15),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              provider.searchResultList[index].customerName!,
                                              style: headerTextStyle(),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              provider.searchResultList[index].companyName!,
                                              style: subTextStyle(),
                                            ),
                                            SizedBox(height: 2),
                                            Text(
                                              provider.searchResultList[index].mobile!,
                                              style: subTextStyle(),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: primaryColor,
          label: const Text('Add Customer'),
          onPressed: () {
            navigateToAddCustomer();
          },
        ),
      ),
    );
  }
}