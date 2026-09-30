import 'package:fast_quote/Screens/Template/Components/EnquiryTemplate/enquiry_template.dart';
import 'package:fast_quote/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'Components/InvoiceTemplate/invoice_template.dart';
import 'Components/QuotationTemplate/quotation_template.dart';

class TemplatesScreen extends StatefulWidget {
  const TemplatesScreen({super.key});

  @override
  State<TemplatesScreen> createState() => _TemplatesScreenState();
}

class _TemplatesScreenState extends State<TemplatesScreen>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    controller = TabController(
      length: 3,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        'Saved Templates',
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
                    Tab(
                      child: Text(
                        "Enquiry\nTemplates",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Quotation\nTemplates",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Invoice\nTemplates",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: controller,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              EnquiryTemplateScreen(),
              QuotationTemplate(),
              InvoiceTemplate(),
            ],
          ),
        ),
      ),
    );
  }
}
