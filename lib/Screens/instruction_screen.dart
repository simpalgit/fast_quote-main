import 'package:animate_do/animate_do.dart';
import 'package:fast_quote/Utils/constants.dart';
import 'package:fast_quote/Widgets/common_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InstructionsScreen extends StatefulWidget {
  const InstructionsScreen({super.key});

  @override
  State<InstructionsScreen> createState() => _InstructionsScreenState();
}

class _InstructionsScreenState extends State<InstructionsScreen> {
  normalTextSpan(String passedText) {
    return TextSpan(text: passedText, style: TextStyle(fontSize: 14.sp));
  }

  boldTextSpan(String passedText) {
    return TextSpan(
        text: passedText,
        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold));
  }

  normalText(String passedText) {
    return Text(passedText, style: TextStyle(fontSize: 14.sp));
  }

  normalSmallText(String passedText) {
    return Text(passedText, style: TextStyle(fontSize: 12.sp));
  }

  boldText(String passedText) {
    return Text(passedText,
        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold));
  }

  verticalSpacing12() {
    return SizedBox(
      height: 12.h,
    );
  }

  verticalSpacing6() {
    return SizedBox(
      height: 6.h,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(
        context: context,
        heading: 'Instructions',
      ),
      body: Container(
        padding:
            EdgeInsets.only(left: 15.w, right: 15.w, bottom: 5.h, top: 12.h),
        width: double.infinity,
        height: double.infinity,
        color: whiteColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
              FadeIn(
                delay: const Duration(milliseconds: 500),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BoldText(
                      text: "Step 1 :",
                    ),
                    verticalSpacing12(),
                    Text.rich(
                      TextSpan(
                        children: [
                          normalTextSpan("Welcome to "),
                          boldTextSpan("Fast Quotation and Invoice Maker "),
                          normalTextSpan(
                              ", the quickest and most efficient way to generate quotations and invoices for your business. In this guide, we'll take you through the simple registration process and show you how to set up your account for optimal usage.")
                        ],
                      ),
                    ),
                    verticalSpacing12(),
                    Text.rich(
                      TextSpan(
                        children: [
                          normalTextSpan(
                              "To get started, the first thing you need to do is download the "),
                          boldTextSpan("Fast Quotation and Invoice Maker "),
                          normalTextSpan(
                              "from the Google Play Store for Android or the Apple App Store for iOS devices.")
                        ],
                      ),
                    ),
                    verticalSpacing12(),
                    normalText(
                        "Once the app is downloaded, open it and begin the registration process."),
                    verticalSpacing12(),
                    const IndexWithTextHelper(
                      index: "1. ",
                      passedText:
                          "Enter your mobile and email address, a strong password, and other required information.",
                    ),
                    verticalSpacing6(),
                    const IndexWithTextHelper(
                      index: "2. ",
                      passedText:
                          "You’ll receive a OTP for mobile verification, enter OTP to verify your mobile number.",
                    ),
                    verticalSpacing12(),
                    normalText(
                        "After your Mobile verify, enter password and confirm password  and  Click the 'Sign Up' button to create your account."),
                    verticalSpacing6(),
                    normalText(
                        "Log in using your mobile no as a username and your  password."),
                    verticalSpacing6(),
                  ],
                ),
              ),
              FadeIn(
                delay: const Duration(milliseconds: 700),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    verticalSpacing6(),
                    boldText("Setting up Your Business :"),
                    verticalSpacing6(),
                    normalText(
                        "Now, let's get your business set up for generating quotations and invoices."),
                    verticalSpacing6(),
                    const IndexWithTextHelper(
                      index: "1. ",
                      passedText:
                          "On the app's dashboard, locate the 'Settings' menu.",
                    ),
                    verticalSpacing6(),
                    const IndexWithTextHelper(
                      index: "2. ",
                      passedText:
                          "Within 'Settings,' find 'Manage Business' and click on it.",
                    ),
                    verticalSpacing6(),
                    const IndexWithTextHelper(
                      index: "3. ",
                      passedText:
                          "Fill in all the necessary fields with your business information, including your company name, address, contact details, and more.",
                    ),
                    verticalSpacing6(),
                    const IndexWithTextHelper(
                      index: "4. ",
                      passedText:
                          "Don't forget to upload your company logo and your signature for that personal touch.",
                    ),
                    verticalSpacing6(),
                  ],
                ),
              ),
              FadeIn(
                delay: const Duration(milliseconds: 900),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    verticalSpacing6(),
                    boldText("Quotation and Invoice Setup :"),
                    verticalSpacing6(),
                    normalText(
                        "With your business information entry at the place , need to go on  'Quotation setting and Invoice Settings' menu."),
                    verticalSpacing6(),
                    const IndexWithTextHelper(
                      index: "1. ",
                      passedText:
                          "Fill in all relevant details such as your business's legal information, tax details, and top and bottom massages.",
                    ),
                    verticalSpacing6(),
                    const IndexWithTextHelper(
                      index: "2. ",
                      passedText:
                          "After It return to dashboard and Add Terms: Enter your standard business terms and conditions, so they can be quickly included in every quotation and invoice",
                    ),
                    verticalSpacing6(),
                    const IndexWithTextHelper(
                      index: "3. ",
                      passedText:
                          "Add Products: Create a list of frequently used products and their details, making it easy to add them to your documents without entering the same information repeatedly.",
                    ),
                    verticalSpacing6(),
                    Text.rich(
                      TextSpan(
                        children: [
                          normalTextSpan(
                              "And there you have it! You're all set to create quick and professional quotations and invoices using"),
                          boldTextSpan("Fast Quotation and Invoice Maker "),
                          normalTextSpan(
                              "Enjoy the efficiency and convenience of managing your business transactions with ease.")
                        ],
                      ),
                    ),
                    verticalSpacing6(),
                  ],
                ),
              ),
              FadeIn(
                delay: const Duration(milliseconds: 1000),
                child: Divider(
                  color: blackColor,
                ),
              ),
              FadeIn(
                delay: const Duration(milliseconds: 1100),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    verticalSpacing6(),
                    const BoldText(
                      text: "Step 2 :",
                    ),
                    verticalSpacing12(),
                    boldText(
                        "Now we’ll go to Inquiry / leads entry   in just a few steps."),
                    verticalSpacing12(),
                    const IndexWithTextHelper(
                      index: "1. ",
                      passedText:
                          "From the app's dashboard, look for the ' Create Inquiries/ Leads' option and click on it.",
                    ),
                    verticalSpacing6(),
                    normalText(
                        "Now, you can create a new inquiry. If you're creating a new inquiry, start by entering the customer's name. You can also select an existing customer  or add new customer name."),
                    verticalSpacing6(),
                    const IndexWithTextHelper(
                      index: "1. ",
                      passedText:
                          "Next, select the product related to this inquiry. You can choose from a list of products offered by your business.",
                    ),
                    verticalSpacing6(),
                    normalText(
                        "To make your inquiry as accurate as possible, you can add other charges such as travel expenses or wrapping fees."),
                    verticalSpacing6(),
                    const IndexWithTextHelper(
                      index: "1. ",
                      passedText:
                          "Click on 'Add Other Charges' and specify the details. If these charges are taxable, make sure to check the 'Is Taxable' option.",
                    ),
                    verticalSpacing6(),
                    normalText(
                        "Before generating the inquiry, specify the terms and any additional notes. Choose the appropriate terms that apply to this inquiry."),
                    verticalSpacing6(),
                    normalText(
                        "Once you've entered all the necessary information, you're ready to generate the inquiry."),
                    verticalSpacing6(),
                    const IndexWithTextHelper(
                      index: "1. ",
                      passedText:
                          "Double-check all the details to ensure accuracy.",
                    ),
                    verticalSpacing6(),
                    const IndexWithTextHelper(
                      index: "2. ",
                      passedText:
                          "When you're satisfied with the inquiry, click on the 'Generate' button.",
                    ),
                    verticalSpacing6(),
                    Text.rich(
                      TextSpan(
                        children: [
                          normalTextSpan(
                              "Congratulations! You've successfully entered an inquiry or lead in "),
                          boldTextSpan("Fast Quotation and Invoice Maker. "),
                          normalTextSpan(
                              "This streamlined process allows you to capture and manage customer inquiries efficiently and you can check it in any time by click on Enquiry list.")
                        ],
                      ),
                    ),
                    verticalSpacing6(),
                  ],
                ),
              ),
              FadeIn(
                delay: const Duration(milliseconds: 1100),
                child: Divider(
                  color: blackColor,
                ),
              ),
              FadeIn(
                delay: const Duration(milliseconds: 1200),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    verticalSpacing6(),
                    const BoldText(
                      text: "Step 3 :",
                    ),
                    verticalSpacing12(),
                    boldText("Now we’ll go to quotation making."),
                    verticalSpacing12(),
                    normalText(
                        "In this , we'll show you two ways to make quotations: by converting inquiries to quotations and by creating entirely new quotations."),
                    verticalSpacing12(),
                    boldText("Converting Inquiries to Quotations :"),
                    verticalSpacing6(),
                    normalText(
                        "Let's start by converting inquiries into quotations."),
                    verticalSpacing6(),
                    const IndexWithTextHelper(
                      index: "1. ",
                      passedText:
                          "If you have an inquiry in your app, navigate to it.",
                    ),
                    verticalSpacing6(),
                    const IndexWithTextHelper(
                      index: "2. ",
                      passedText:
                          "Within the inquiry, you have the option to add any applicable discounts.",
                    ),
                    verticalSpacing6(),
                    const IndexWithTextHelper(
                      index: "3. ",
                      passedText:
                          "Choose the payment terms for this quotation from a list of available quotation terms and conditions.",
                    ),
                    verticalSpacing6(),
                    const IndexWithTextHelper(
                      index: "4. ",
                      passedText:
                          "Once you've set your discount and terms, simply click the 'Generate' button, and your quotation is ready.",
                    ),
                    verticalSpacing12(),
                    boldText("Creating a New Quotation :"),
                    verticalSpacing6(),
                    normalText(
                        "If you prefer to create a new quotation, follow these steps."),
                    verticalSpacing6(),
                    const IndexWithTextHelper(
                      index: "1. ",
                      passedText:
                          "Begin by creating a new quotation or selecting an existing customer's name.",
                    ),
                    verticalSpacing6(),
                    const IndexWithTextHelper(
                      index: "2. ",
                      passedText:
                          "Select the product you want to include in the quotation.",
                    ),
                    verticalSpacing6(),
                    const IndexWithTextHelper(
                      index: "3. ",
                      passedText:
                          "If you have any discounts to apply, add them. If not, simply enter '0'.",
                    ),
                    verticalSpacing6(),
                    const IndexWithTextHelper(
                      index: "4. ",
                      passedText:
                          "Add other charges like travel expenses or wrapping fees if necessary. If these charges are taxable, make sure to check the 'Is Taxable' option and enter tax % or taxable amount.",
                    ),
                    verticalSpacing6(),
                    const IndexWithTextHelper(
                      index: "5. ",
                      passedText:
                          "Choose your payment terms for this quotation from the available quotation terms and conditions.",
                    ),
                    verticalSpacing6(),
                    const IndexWithTextHelper(
                      index: "6. ",
                      passedText: "Review all the details to ensure accuracy.",
                    ),
                    verticalSpacing6(),
                    const IndexWithTextHelper(
                      index: "7. ",
                      passedText:
                          "When you're satisfied with the quotation, click the 'Generate' button.",
                    ),
                    verticalSpacing6(),
                    Text.rich(
                      TextSpan(
                        children: [
                          normalTextSpan(
                              "And there you have it! Whether you're converting inquiries into quotations or creating new quotation "),
                          boldTextSpan("Fast Quotation and Invoice Maker. "),
                          normalTextSpan("makes the process quick and easy.")
                        ],
                      ),
                    ),
                    verticalSpacing6(),
                    normalSmallText(
                        "Creating a script to explain the process of creating invoices in a fast quotation and invoice app."),
                    verticalSpacing6(),
                  ],
                ),
              ),
              FadeIn(
                delay: const Duration(milliseconds: 1300),
                child: Divider(
                  color: blackColor,
                ),
              ),
              FadeIn(
                delay: const Duration(milliseconds: 1400),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    verticalSpacing6(),
                    const BoldText(
                      text: "Step 4 :",
                    ),
                    verticalSpacing12(),
                    boldText("Now we’ll go to create Invoice Section."),
                    verticalSpacing12(),
                    normalText(
                        "In this section, we'll walk you through two methods for creating invoices: converting quotations to invoices and creating entirely new invoices."),
                    verticalSpacing12(),
                    boldText("Converting Quotations to Invoices :"),
                    verticalSpacing6(),
                    normalText(
                        "Let's start with the process of converting quotations into invoices."),
                    verticalSpacing6(),
                    const IndexWithTextHelper(
                      index: "1. ",
                      passedText:
                          "Access the quotation you'd like to convert to an invoice within the app.",
                    ),
                    verticalSpacing6(),
                    const IndexWithTextHelper(
                      index: "2. ",
                      passedText:
                          "Select the desired  term from the available invoice term list.",
                    ),
                    verticalSpacing6(),
                    const IndexWithTextHelper(
                      index: "3. ",
                      passedText:
                          "If there's any additional paid  information, such as an advance payment or other relevant data, enter it as required.",
                    ),
                    verticalSpacing6(),
                    const IndexWithTextHelper(
                      index: "4. ",
                      passedText:
                          "After verifying all the details, click the 'Generate' button, and your invoice is ready.",
                    ),
                    verticalSpacing12(),
                    boldText("Creating a New Invoice :"),
                    verticalSpacing6(),
                    normalText(
                        "If you prefer to create a brand-new invoice, follow these steps."),
                    verticalSpacing6(),
                    const IndexWithTextHelper(
                      index: "1. ",
                      passedText:
                          "Begin by creating a new invoice or selecting an existing customer's name.",
                    ),
                    verticalSpacing6(),
                    const IndexWithTextHelper(
                      index: "2. ",
                      passedText:
                          "Select the product to include in the invoice.",
                    ),
                    verticalSpacing6(),
                    const IndexWithTextHelper(
                      index: "3. ",
                      passedText:
                          "If you have any discounts to apply, add them. If not, enter '0' as the discount.",
                    ),
                    verticalSpacing6(),
                    const IndexWithTextHelper(
                      index: "4. ",
                      passedText:
                          "Add other charges like travel expenses or wrapping fees if applicable. Ensure to mark them as taxable if they are.",
                    ),
                    verticalSpacing6(),
                    const IndexWithTextHelper(
                      index: "5. ",
                      passedText:
                          "Select the  terms for this invoice from the available invoice term list.",
                    ),
                    verticalSpacing6(),
                    const IndexWithTextHelper(
                      index: "6. ",
                      passedText:
                          "Include any relevant paid  information, such as advance payments or other details .",
                    ),
                    verticalSpacing6(),
                    const IndexWithTextHelper(
                      index: "7. ",
                      passedText:
                          "After reviewing all the details for accuracy, click the 'Generate' button.",
                    ),
                    verticalSpacing6(),
                    Text.rich(
                      TextSpan(
                        children: [
                          normalTextSpan("And there you have it! With "),
                          boldTextSpan("Fast Quotation and Invoice Maker. "),
                        ],
                      ),
                    ),
                    verticalSpacing6(),
                    normalSmallText(
                        "creating invoices is a breeze. Whether you're converting quotations to invoices or generating entirely new invoices, our app streamlines the process for you."),
                    verticalSpacing6(),
                  ],
                ),
              ),
              FadeIn(
                delay: const Duration(milliseconds: 1300),
                child: Divider(
                  color: blackColor,
                ),
              ),
              FadeIn(
                delay: const Duration(milliseconds: 1400),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    verticalSpacing6(),
                    const BoldText(
                      text: "Step 5 :",
                    ),
                    verticalSpacing12(),
                    boldText(
                        "Now we’ll go to create Delivery Challan  Section"),
                    verticalSpacing12(),
                    normalText(
                        "In this section , we'll explore how you can create delivery challans from existing invoices with ease."),
                    verticalSpacing12(),
                    boldText("Converting an Invoice to a Delivery Challan :"),
                    verticalSpacing6(),
                    normalText(
                        "Let's dive into the process of converting an existing invoice into a delivery challan."),
                    verticalSpacing6(),
                    const IndexWithTextHelper(
                      index: "1. ",
                      passedText:
                          "Start by locating the invoice you want to convert into a delivery challan within the app.",
                    ),
                    verticalSpacing6(),
                    const IndexWithTextHelper(
                      index: "2. ",
                      passedText:
                          "After selecting the invoice, you'll find an option to 'Convert to  Challan.' Click on this option.",
                    ),
                    verticalSpacing6(),
                    const IndexWithTextHelper(
                      index: "3. ",
                      passedText:
                          "Instantly, all the details from the selected invoice will be displayed on your screen.",
                    ),
                    verticalSpacing6(),
                    const IndexWithTextHelper(
                      index: "4. ",
                      passedText:
                          "Take a moment to review and confirm that all the information is accurate and complete.",
                    ),
                    verticalSpacing12(),
                    normalText(
                        "Once you're satisfied with the details and ready to create your delivery challan, "),
                    verticalSpacing6(),
                    const IndexWithTextHelper(
                      index: "1. ",
                      passedText:
                          "Click on the 'Generate' button to initiate the process.",
                    ),
                    verticalSpacing6(),
                    const IndexWithTextHelper(
                      index: "2. ",
                      passedText:
                          "In no time, your delivery challan is ready and can be printed or shared as needed.",
                    ),
                    verticalSpacing6(),
                  ],
                ),
              ),
              FadeIn(
                delay: const Duration(milliseconds: 1500),
                child: Divider(
                  color: blackColor,
                ),
              ),
              FadeIn(
                  child: Column(
                children: [
                  verticalSpacing6(),
                  Text.rich(
                    TextSpan(
                      children: [
                        boldTextSpan("Fast Quotation and Invoice Maker. "),
                        normalTextSpan(
                            "simplifies the process of  create enquiry , creating Quotation and invoice with creating delivery challans from existing invoices, ensuring a seamless transition in your business transactions."),
                      ],
                    ),
                  ),
                  verticalSpacing6(),
                  Text.rich(
                    TextSpan(
                      children: [
                        normalTextSpan("Thank you for choosing "),
                        boldTextSpan("Fast Quotation and Invoice Maker. "),
                        normalTextSpan(
                            "If you have any questions or need further assistance, feel free to reach out to our support team. Happy quoting and invoicing!"),
                      ],
                    ),
                  ),
                  verticalSpacing6(),
                ],
              )),
              verticalSpacing12(),
            ],
          ),
        ),
      ),
    );
  }
}

class BoldText extends StatelessWidget {
  final String text;
  const BoldText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
    );
  }
}

class IndexWithTextHelper extends StatelessWidget {
  final String index, passedText;
  const IndexWithTextHelper(
      {super.key, required this.index, required this.passedText});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(index,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
        Expanded(child: Text(passedText, style: TextStyle(fontSize: 14.sp)))
      ],
    );
  }
}
