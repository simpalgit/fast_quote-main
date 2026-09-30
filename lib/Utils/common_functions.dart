import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fast_quote/Screens/Settings/Components/Profile/profile_model.dart';
import 'package:fast_quote/Utils/constants.dart';
import 'package:fast_quote/Utils/local_shared_preferences.dart';
import 'package:fast_quote/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart' as NavigationService;
import 'package:shared_preferences/shared_preferences.dart';

import 'route_names.dart';

class CommonFunctions {
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static var globalContext = NavigationService.navigatorKey.currentContext!;

  String getCurrentDateTime() {
    var now = DateTime.now();

    String currentTime = DateFormat('dd-MM-yyyy hh:mm:ss').format(now);

    return currentTime;
  }

  String getCurrentDate() {
    var now = DateTime.now();

    String currentTime = DateFormat('dd-MM-yyyy').format(now);

    return currentTime;
  }

  void sessionTimeOut(BuildContext context) async {
    LocalPreferences().setLoginBool(false);

    final preferences = await SharedPreferences.getInstance();
    await preferences.clear();

    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteNames.splashScreen,
        (route) => false,
      );
    }
  }

  void logOut(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      RouteNames.splashScreen,
      (route) => false,
    );
  }

  Future deleteImageFromCache(String url) async {
    await CachedNetworkImage.evictFromCache(url);
  }

  static double discountOnFlatFunction(
    BuildContext context,
    String value,
    double totalAmount,
  ) {
    double finalAmount = 0.0;
    if (value.isEmpty) {
      value = "0";
    }

    if (value.isEmpty) {
      return 0.0;
    } else if (value.isNotEmpty) {
      var temp = double.parse(value);
      if (temp > totalAmount) {
        CommonFunctions.showErrorSnackbar(
          context,
          "Added Discount Amount is greater than price.",
        );

        return 0.0;
      } else {
        finalAmount = totalAmount - temp;
        return finalAmount;
      }
    } else {
      return 0.0;
    }
  }

  static double discountOnPercentageFunction(
    BuildContext context,
    String value,
    double totalAmount,
  ) {
    double finalAmount = 0.0;
    int discount = 0;
    if (value.isNotEmpty) {
      discount = int.parse(value);
    }

    if (value.isEmpty) {
      return 0.0;
    } else if (discount == 0) {
      return totalAmount;
    } else if (discount > 100) {
      CommonFunctions.showErrorSnackbar(
        context,
        "Discount is greater than 100.",
      );
      return 0.0;
    } else if (value.isNotEmpty) {
      var temp = totalAmount;
      var disc = discount;
      var passedDisc = disc / 100;

      var amt = temp * passedDisc;

      return amt;
    } else {
      return 0.0;
    }
  }

  static double discountOnPercentage(
    BuildContext context,
    String value,
    double totalAmount,
  ) {
    double finalAmount = 0.0;
    int discount = int.parse(value);

    if (value.isEmpty) {
      return 0.0;
    } else if (discount > 100) {
      CommonFunctions.showErrorSnackbar(
        context,
        "Discount is greater than 100.",
      );
      return 0.0;
    } else if (value.isNotEmpty) {
      var temp = totalAmount;
      var disc = discount;
      var passedDisc = disc / 100;

      var amt = temp * passedDisc;

      return amt;
    } else {
      return 0.0;
    }
  }

  static void showErrorSnackbar(BuildContext context, String msg) {
    ScaffoldMessenger.of(globalContext).clearSnackBars();
    ScaffoldMessenger.of(globalContext).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: TextStyle(
            color: whiteColor,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: Colors.red.withOpacity(.8),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void showSuccessSnackbar(String msg) {
    ScaffoldMessenger.of(globalContext).clearSnackBars();
    ScaffoldMessenger.of(globalContext).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: TextStyle(
            color: whiteColor,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: Colors.green.withOpacity(.8),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void showWarningSnackbar(BuildContext context, String msg) {
    if (context.mounted) {
      ScaffoldMessenger.of(globalContext).clearSnackBars();
      ScaffoldMessenger.of(globalContext).showSnackBar(
        SnackBar(
          content: Text(
            msg,
            style: TextStyle(
              color: whiteColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          backgroundColor: secondary,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  int calculateRemainingDays(DateTime startDate, DateTime endDate) {
    DateTime start = DateTime(startDate.year, startDate.month, startDate.day);
    DateTime end = DateTime(endDate.year, endDate.month, endDate.day);

    final difference = end.difference(start).inDays;
    return difference;
  }

  static warningSnackBar({required String remainingDays}) {
    String passedMessage = "", passedTitle = "";

    if (remainingDays == "0") {
      passedTitle = "Your Subscription will Expire Today.";
      passedMessage =
          "Renew your subscription to continue enjoying premium features.";
    } else {
      passedTitle = "Your Subscription will Expire in $remainingDays Days";

      passedMessage =
          'Renew your subscription to continue enjoying premium features after $remainingDays Days!';
    }
    return SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      duration: const Duration(seconds: 5),
      content: AwesomeSnackbarContent(
        // titleFontSize: 14.sp,
        // messageFontSize: 13.sp,
        title: passedTitle,
        message: passedMessage,
        contentType: ContentType.help,
      ),
    );
  }

  static errorSnackBar() {
    return const SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      duration: Duration(seconds: 5),
      content: AwesomeSnackbarContent(
        // titleFontSize: 14.sp,
        // messageFontSize: 13.sp,
        title: 'Your Subscription is Expired',
        message:
            'Renew your subscription to continue enjoying premium features.',
        contentType: ContentType.failure,
      ),
    );
  }

  static void showProgressBar(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
  }

  static void showShareDialogue({
    required BuildContext context,
    required VoidCallback generalClick,
    required VoidCallback unSavedButonClick,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: generalClick,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/images/dialogue_share.svg",
                        height: 50,
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        'General Share\nfor Sharing',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: secondary,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                const VerticalDivider(
                  color: Color.fromARGB(255, 172, 172, 172),
                  thickness: 2,
                ),
                const SizedBox(width: 20),
                InkWell(
                  onTap: unSavedButonClick,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/images/whatsapp_dialogue.svg",
                        height: 50,
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        'Share with\nunsaved number',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: secondary,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static getAmountForTax(String tax, double total) {
    double taxAmount = 0.0;
    if (total == 0.0) {
      var amt = (total * double.parse(tax)) / 100;
      taxAmount = total + amt;
      return [taxAmount, amt];
    } else {
      var amt = (total * double.parse(tax)) / 100;
      taxAmount = total + amt;
      return [taxAmount, amt];
    }
  }

  Future<dynamic> pickAndCropImage({required String from}) async {
    final picker = ImagePicker();
    final XFile? pickedFile;
    if (from == "camera") {
      pickedFile = await picker.pickImage(source: ImageSource.camera);
    } else {
      pickedFile = await picker.pickImage(source: ImageSource.gallery);
    }

    if (pickedFile != null) {
      // Crop the picked image
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: primaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9,
            ],
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: 'Crop Image',
            minimumAspectRatio: 1.0,
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9,
            ],
          ),
        ],
      );

      if (croppedFile != null) {
        // Do something with the cropped image (e.g., display it or upload it)

        return croppedFile;
      } else {
        return null;
      }
    }
  }

  Future<ProfileModel> getStoredProfileData() async {
    String helper = await LocalPreferences().getProfileData() ?? "";

    Map<String, dynamic> userMap = jsonDecode(helper);

    ProfileModel user = ProfileModel.fromGetJson(userMap, {});

    return user;
  }

  showPopUp({
    required BuildContext context,
    required double screenHeight,
    required double screenWidth,
    required VoidCallback onCameraClick,
    required VoidCallback onGalleryClick,
  }) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      '____',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ColumnImageTextHelper(
                          imagePath: 'assets/images/bycamera.svg',
                          title: 'Camera',
                          onCLicked: onCameraClick,
                          sHeight: screenHeight,
                        ),

                        const Divider(thickness: 1.5),
                        ColumnImageTextHelper(
                          imagePath: 'assets/images/bygallery.svg',
                          title: 'Gallery',
                          onCLicked: onGalleryClick,
                          sHeight: screenHeight,
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  showPopUpSignature({
    required BuildContext context,
    required double screenHeight,
    required double screenWidth,
    required VoidCallback onCameraClick,
    required VoidCallback onGalleryClick,
    required VoidCallback onSignatureClick,
  }) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      '____',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ColumnImageTextHelper(
                          imagePath: 'assets/images/bycamera.svg',
                          title: 'Camera',
                          onCLicked: onCameraClick,
                          sHeight: screenHeight,
                        ),
                        const Divider(thickness: 1.5),
                        ColumnImageTextHelper(
                          imagePath: 'assets/images/bygallery.svg',
                          title: 'Gallery',
                          onCLicked: onGalleryClick,
                          sHeight: screenHeight,
                        ),
                        const Divider(thickness: 1.5),
                        ColumnImageTextHelper(
                          imagePath: 'assets/images/add_signature.svg',
                          title: 'Create Signature',
                          onCLicked: onSignatureClick,
                          sHeight: screenHeight,
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ColumnImageTextHelper extends StatelessWidget {
  final double? sHeight;
  final String? imagePath;
  final String? title;
  final VoidCallback? onCLicked;
  const ColumnImageTextHelper({
    super.key,
    this.sHeight,
    this.imagePath,
    this.onCLicked,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onCLicked,
      child: Row(
        children: [
          SvgPicture.asset(imagePath!, height: sHeight! * 0.04),
          const SizedBox(width: 15),
          Text(
            title!,
            style: TextStyle(color: secondary, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class ColumnAssetsImageTextHelper extends StatelessWidget {
  final double? sHeight;
  final String? imagePath;
  final String? title;
  final VoidCallback? onCLicked;
  const ColumnAssetsImageTextHelper({
    super.key,
    this.sHeight,
    this.imagePath,
    this.onCLicked,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onCLicked,
      child: Column(
        children: [
          Image.asset(imagePath!, height: sHeight! * 0.1),
          const SizedBox(width: 15),
          Text(
            title!,
            style: TextStyle(color: secondary, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
