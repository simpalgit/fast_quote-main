import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fast_quote/Screens/Settings/Components/Profile/profile_provider.dart';
import 'package:fast_quote/Utils/common_functions.dart';
import 'package:fast_quote/Utils/constants.dart';
import 'package:fast_quote/Utils/route_names.dart';
import 'package:fast_quote/Widgets/add_part_button.dart';
import 'package:fast_quote/Widgets/common_loaders.dart';
import 'package:fast_quote/Widgets/error_found_widget.dart';
import 'package:fast_quote/Widgets/input_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../Widgets/common_appbar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  CroppedFile? profileImage;
  bool colorChange = false;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = Provider.of<ProfileProvider>(context, listen: false);
      provider.getProfileStoredData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileProvider>(
      context,
    );
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: commonAppBar(
        context: context,
        heading: 'Edit Profile',
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: colorChange || provider.isBtnLoading
            ? SizedBox(
                width: size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      'Please Wait ..',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: primaryColor),
                    )
                  ],
                ),
              )
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20.h,
                      ),
                      Stack(
                        children: [
                          FadeIn(
                              delay: const Duration(milliseconds: 300),
                              child: 
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(size.height * 0.3),
                                child: CachedNetworkImage(
                                  height: size.height * .14,
                                  width: size.height * .14,
                                  fit: BoxFit.fill,
                                  imageUrl: provider.profileImage,
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          SizedBox(
                                    width: 25,
                                    height: 25,
                                    child: Shimmer.fromColors(
                                      baseColor: Colors.black12,
                                      highlightColor: Colors.white,
                                      enabled: true,
                                      child: Container(
                                        width: 25,
                                        height: 25,
                                        decoration: const BoxDecoration(
                                            color: kWhite,
                                            shape: BoxShape.circle),
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                          color: primaryColor,
                                          alignment: Alignment.center,
                                          child: const Text(
                                            'Add\nProfile',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          )),
                                ),
                              )),
                          Positioned(
                              top: 0,
                              right: -25,
                              child: MaterialButton(
                                elevation: 1,
                                shape: const CircleBorder(
                                    side: BorderSide(color: Colors.black)),
                                onPressed: () {
                                  CommonFunctions().showPopUp(
                                      context: context,
                                      screenHeight: size.height,
                                      screenWidth: size.width,
                                      onCameraClick: () async {
                                        Navigator.pop(context);
                                        setState(() {
                                          colorChange = true;
                                        });
                                        await CommonFunctions()
                                            .pickAndCropImage(from: "camera")
                                            .then((value) {
                                          if (value == null) {
                                            setState(() {
                                              colorChange = false;
                                            });
                                          } else {
                                            provider
                                                .updateProfileImage(
                                                    context, value)
                                                .then((value) {
                                              setState(() {
                                                colorChange = false;
                                              });
                                            });
                                          }
                                        });
                                      },
                                      onGalleryClick: () async {
                                        Navigator.pop(context);
                                        setState(() {
                                          colorChange = true;
                                        });
                                        await CommonFunctions()
                                            .pickAndCropImage(from: "gallery")
                                            .then((value) {
                                          if (value == null) {
                                            setState(() {
                                              colorChange = false;
                                            });
                                          } else {
                                            provider
                                                .updateProfileImage(
                                                    context, value)
                                                .then((value) {
                                              setState(() {
                                                colorChange = false;
                                              });
                                            });
                                          }
                                        });
                                      });
                                },
                                color: Colors.white,
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.black,
                                ),
                              ))
                        ],
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      StepperTextField(
                        controllerValue: provider.ctlUserName,
                        inputType: TextInputType.text,
                        validate: (val) {
                          if (val!.isEmpty) {
                            return "Field Cant be empty";
                          } else {
                            return null;
                          }
                        },
                        hintValue: "Customer Name",
                        onChange: (p0) {},
                      ),
                      provider.errorNameText.isEmpty
                          ? Container()
                          : ErrorText(error: provider.errorNameText),
                      SizedBox(
                        height: 10.h,
                      ),
                      StepperTextField(
                        rOnly: true,
                        controllerValue: provider.ctlMobile,
                        inputType: TextInputType.phone,
                        validate: (val) {
                          if (val!.isEmpty) {
                            return "Field Cant be empty";
                          } else if (val.length < 10) {
                            return "mobile num 10";
                          } else {
                            return null;
                          }
                        },
                        mLength: 10,
                        hintValue: "Mobile",
                      ),
                      provider.errorMobileText.isEmpty
                          ? Container()
                          : ErrorText(error: provider.errorMobileText),
                      SizedBox(
                        height: 10.h,
                      ),
                      StepperTextField(
                        controllerValue: provider.ctlEmail,
                        hintValue: 'Email',
                        inputType: TextInputType.emailAddress,
                        validate: (val) {
                          return null;
                        },
                      ),
                      provider.errorEmailText.isEmpty
                          ? Container()
                          : ErrorText(error: provider.errorEmailText),
                      SizedBox(
                        height: 20.h,
                      ),
                      provider.isBtnLoading
                          ? const CommonButtonLoader()
                          : AppAddPartButtonWidget(
                              onTap: provider.isBtnLoading
                                  ? null
                                  : () {
                                      provider.updateProfile(context);
                                    },
                              btnText: 'Update'),
                      SizedBox(
                        height: 10.h,
                      ),
                      AppButtonSecondary(
                          onTap: () {
                            Navigator.pushNamed(
                                context, RouteNames.changePassword);
                          },
                          btnText: 'Change Password'),
                    ],
                  ),
                )),
      ),
    );
  }
}
