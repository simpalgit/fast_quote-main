import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:fast_quote/Screens/Settings/Components/ManageBusiness/manage_business_provider.dart';
import 'package:fast_quote/Utils/common_functions.dart';
import 'package:fast_quote/Utils/constants.dart';
import 'package:fast_quote/Widgets/add_part_button.dart';
import 'package:fast_quote/Widgets/common_appbar.dart';
import 'package:fast_quote/Widgets/error_found_widget.dart';
import 'package:fast_quote/Widgets/input_fields.dart';
import 'package:fast_quote/Widgets/upload_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';

class ManageBusinessScreen extends StatefulWidget {
  const ManageBusinessScreen({super.key});

  @override
  State<ManageBusinessScreen> createState() => _ManageBusinessScreenState();
}

class _ManageBusinessScreenState extends State<ManageBusinessScreen> {
  bool colorChange = false, createdSignature = false;
  var signatureMemory;
  final GlobalKey<FormState> _formKey = GlobalKey();

  final SignatureController _controller = SignatureController(
      penStrokeWidth: 2,
      penColor: secondary,
      exportBackgroundColor: Colors.white);
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final provider =
          Provider.of<ManageBusinessProvider>(context, listen: false);

      DefaultCacheManager().emptyCache();
      provider.getStates(context);
    });
    super.initState();
  }

  CroppedFile? addLogo, addSignature;
  File? signatureFile;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final provider = Provider.of<ManageBusinessProvider>(context);
    return Scaffold(
      appBar: commonAppBar(context: context, heading: "Manage Business"),
      body: colorChange
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 20.h),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        UploadImagesHelper(
                          imagenum: 'Logo',
                          uploadImage: () {
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
                                    setState(() {
                                      colorChange = false;

                                      if (value != null) {
                                        addLogo = value;
                                      }
                                    });
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
                                    setState(() {
                                      colorChange = false;

                                      if (value != null) {
                                        addLogo = value;
                                      }
                                    });
                                  });
                                });
                          },
                          removeImage: () {
                            addLogo = null;
                            setState(() {});
                          },
                          passedfile: addLogo,
                          imagePath: provider.businessLogo,
                        ),
                        UploadSignatureHelper(
                          signatureMemory: signatureMemory,
                          imagePath: provider.businessSignature,
                          imagenum: 'Signature',
                          uploadImage: () {
                            CommonFunctions().showPopUpSignature(
                                context: context,
                                screenHeight: size.height,
                                screenWidth: size.width,
                                onSignatureClick: () {
                                  Navigator.pop(context);
                                  _uploadSignature(context, size, provider)
                                      .then((value) {
                                    setState(() {});
                                  });
                                },
                                onCameraClick: () async {
                                  Navigator.pop(context);
                                  setState(() {
                                    colorChange = true;
                                  });
                                  await CommonFunctions()
                                      .pickAndCropImage(from: "camera")
                                      .then((value) {
                                    setState(() {
                                      colorChange = false;
                                      _controller.clear();
                                      if (value != null) {
                                        addSignature = value;
                                      }
                                      createdSignature = false;
                                      signatureMemory = null;
                                    });
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
                                    setState(() {
                                      colorChange = false;
                                      createdSignature = false;
                                      signatureMemory = null;
                                      _controller.clear();
                                      if (value != null) {
                                        addSignature = value;
                                      }
                                    });
                                  });
                                });
                          },
                          removeImage: () {
                            addSignature = null;
                            setState(() {});
                          },
                          passedfile: addSignature,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * 0.02),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            StepperTextField(
                              controllerValue: provider.ctlBusinessName,
                              inputType: TextInputType.text,
                              validate: (val) {
                                if (val!.isEmpty) {
                                  return "Field Cant be empty";
                                } else {
                                  return null;
                                }
                              },
                              hintValue: "Business Name",
                              onChange: (p0) {},
                            ),
                            provider.errorBusinessName.isEmpty
                                ? Container()
                                : ErrorText(error: provider.errorBusinessName),
                            SizedBox(
                              height: 15.h,
                            ),
                            StepperTextField(
                              controllerValue: provider.ctlContactName,
                              inputType: TextInputType.text,
                              validate: (val) {
                                if (val!.isEmpty) {
                                  return "Field Cant be empty";
                                } else {
                                  return null;
                                }
                              },
                              hintValue: "Contact Name",
                              onChange: (p0) {},
                            ),
                            provider.errorContactName.isEmpty
                                ? Container()
                                : ErrorText(error: provider.errorContactName),
                            SizedBox(
                              height: 15.h,
                            ),
                            StepperTextField(
                              controllerValue: provider.ctlEmail,
                              inputType: TextInputType.text,
                              validate: (val) {
                                if (val!.isEmpty) {
                                  return "Field Cant be empty";
                                } else {
                                  return null;
                                }
                              },
                              hintValue: "Email",
                              onChange: (p0) {},
                            ),
                            provider.errorEmail.isEmpty
                                ? Container()
                                : ErrorText(error: provider.errorEmail),
                            SizedBox(
                              height: 15.h,
                            ),
                            StepperTextField(
                              controllerValue: provider.ctlMobile,
                              inputType: TextInputType.phone,
                              validate: (val) {
                                if (val!.isEmpty) {
                                  return "Field Cant be empty";
                                } else if (val.length > 10) {
                                  return "mobile number length should be 10 digits";
                                } else {
                                  return null;
                                }
                              },
                              hintValue: "Phone number",
                              onChange: (p0) {},
                            ),
                            provider.errorPhone.isEmpty
                                ? Container()
                                : ErrorText(error: provider.errorPhone),
                            SizedBox(
                              height: 15.h,
                            ),
                            StepperTextField(
                              controllerValue: provider.ctlAddressOne,
                              inputType: TextInputType.streetAddress,
                              validate: (val) {
                                return null;
                              },
                              hintValue: "Address One",
                              onChange: (p0) {},
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            StepperTextField(
                              controllerValue: provider.ctlAddressTwo,
                              inputType: TextInputType.streetAddress,
                              validate: (val) {
                                return null;
                              },
                              hintValue: "Address Two",
                              onChange: (p0) {},
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            StepperTextField(
                              controllerValue: provider.ctlAddressThree,
                              inputType: TextInputType.streetAddress,
                              validate: (val) {
                                return null;
                              },
                              hintValue: "Address Three",
                              onChange: (p0) {},
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            StepperTextField(
                              controllerValue: provider.ctlOtherInfo,
                              inputType: TextInputType.text,
                              validate: (val) {
                                return null;
                              },
                              hintValue: "Other Info",
                              onChange: (p0) {},
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            StepperTextField(
                              controllerValue: provider.ctlBusinessLabel,
                              inputType: TextInputType.text,
                              validate: (val) {
                                return null;
                              },
                              hintValue: "GSTIN/PAN/VAT/Business Label",
                              onChange: (p0) {},
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            StepperTextField(
                              controllerValue: provider.ctlBusinessNumber,
                              inputType: TextInputType.text,
                              validate: (val) {
                                return null;
                              },
                              hintValue: "GSTIN/PAN/VAT/Business Number",
                              onChange: (p0) {},
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            StepperTextField(
                              rOnly: true,
                              onTap: () {
                                _selectState(context, provider);
                              },
                              controllerValue: provider.ctlStateName,
                              hintValue: 'State',
                              inputType: TextInputType.streetAddress,
                              validate: (val) {
                                if (val!.isEmpty) {
                                  return "Field Cant be empty";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            provider.errorState.isEmpty
                                ? Container()
                                : ErrorText(error: provider.errorState),
                            SizedBox(
                              height: 8.h,
                            ),
                            const Divider(
                              thickness: 2,
                            ),
                            SizedBox(
                              height: 8.h,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Bank Details',
                                style: TextStyle(
                                    fontSize: 13.sp,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                            SizedBox(
                              height: 8.h,
                            ),
                            BankTextField(
                              controllerValue: provider.ctlBankDetail,
                              inputType: TextInputType.multiline,
                              actionNext: TextInputAction.newline,
                              maxLine: 4,
                              validate: (val) {
                                return null;
                              },
                              hintValue:
                                  "Account Name : #### #### ####\nAccount Number : #### #### ####\nBank Name : #### #### ####",
                              onChange: (p0) {},
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            AppAddPartButtonWidget(
                                onTap: () {
                                  if (createdSignature == false) {
                                    provider.uploadBusinessData(
                                        context, addLogo, addSignature);
                                  } else {
                                    provider.uploadBusinessData(
                                        context, addLogo, signatureFile);
                                  }
                                  // _uploadSignature(context, size, provider);
                                },
                                btnText: 'Save'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )),
    );
  }

  _selectState(BuildContext context, ManageBusinessProvider provider) {
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
              var filteredData = [];
              if (provider.ctlStateName.text.isEmpty) {
                filteredData = provider.stateList;
              } else {
                filteredData = provider.stateList
                    .where((e) => (e.name
                        .toLowerCase()
                        .contains(provider.ctlStateName.text.toLowerCase())))
                    .toList();
              }

              return Padding(
                padding: EdgeInsets.only(
                    top: 30.sp,
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    left: 15.sp,
                    right: 15.sp),
                child: SizedBox(
                  height: 350.h,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Select State',
                        style: TextStyle(fontSize: 20.sp),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 0, left: 20, right: 20)
                                .w,
                        child: TextFormField(
                          controller: provider.ctlStateName,
                          style: TextStyle(
                              fontSize: 15.sp,
                              color: secondary,
                              fontWeight: FontWeight.w400),
                          decoration: InputDecoration(
                              hintText: 'Search product...',
                              suffixIcon: Icon(
                                Icons.search,
                                color: primaryColor,
                              ),
                              contentPadding: const EdgeInsets.only(left: 20),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide:
                                    BorderSide(color: secondary, width: 1.5),
                              ),
                              fillColor: Colors.white,
                              filled: true),
                          onChanged: (String value) {
                            setState(() {/*areaSearch = value.toString();*/});
                          },
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                            itemCount: filteredData.length,
                            physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            itemBuilder: (context, index) {
                              return ListTile(
                                onTap: () {
                                  provider.stateOnClick(
                                      filteredData[index], context);
                                },
                                title: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.w),
                                  child:
                                      Text(filteredData[index].name.toString()),
                                ),
                              );
                            }),
                      )
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

  Future _uploadSignature(
      BuildContext context, Size size, ManageBusinessProvider provider) {
    return showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          // <-- SEE HERE
          borderRadius: BorderRadius.vertical(
            top: const Radius.circular(25.0).r,
          ),
        ),
        builder: (BuildContext context) {
          _controller.clear();

          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setStates) {
            return Container(
              padding: const EdgeInsets.only(
                      left: 30, right: 30, top: 30, bottom: 20)
                  .w,
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.vertical(
                  top: const Radius.circular(25.0).r,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 30.h,
                          width: 50.w,
                          margin: const EdgeInsets.only(right: 10).w,
                          decoration: BoxDecoration(
                              color: lightPrimary,
                              borderRadius: BorderRadius.circular(10).r),
                          child: Center(
                            child: Icon(
                              Icons.arrow_back_sharp,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    "Draw signature here",
                    style: Style.headLineStyle2.copyWith(
                        color: blackColor, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  SizedBox(
                    height: 200.h,
                    width: 300.w,
                    child: Stack(
                      children: [
                        Signature(
                          backgroundColor: grey200,
                          controller: _controller,
                        ),
                        Positioned(
                            bottom: 10.w,
                            right: 10.w,
                            child: InkWell(
                              onTap: () {
                                _controller.clear();
                                // _signaturePadKey.currentState!.clear();
                              },
                              child: Container(
                                height: 25.h,
                                width: 80.w,
                                decoration: BoxDecoration(
                                    color: grey300,
                                    borderRadius: BorderRadius.circular(5).r),
                                child: Center(
                                  child: Text(
                                    "Clear",
                                    style: Style.headLineStyle1
                                        .copyWith(color: primaryColor),
                                  ),
                                ),
                              ),
                            ))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  SizedBox(
                    height: 40.h,
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10).r),
                            elevation: 0,
                            foregroundColor: whiteColor,
                            backgroundColor: primaryColor),
                        onPressed: () async {
                          // if (addSignature != null) {
                          //   provider.uploadBusinessData(
                          //       context, addLogo, addSignature);
                          // } else {
                          //   addSignature = null;
                          //   Future<File> writeToFile(ByteData data) async {
                          //     //   final buffer = data.buffer;
                          //     Directory tempDir = await getTemporaryDirectory();
                          //     String tempPath = tempDir.path;
                          //     var filePath = '$tempPath/signature.png';
                          //     return File(filePath).writeAsBytes(
                          //         data.buffer.asUint8List(
                          //             data.offsetInBytes, data.lengthInBytes),
                          //         flush: true);
                          //   }

                          //   if (_controller.isEmpty) {
                          //     provider.uploadBusinessData(
                          //         context, addLogo, null);

                          //     //_getComplaintDetails();
                          //   } else {
                          //     var image = await _controller.toImage();
                          //     final bytes = await image!
                          //         .toByteData(format: ui.ImageByteFormat.png);
                          //     var file = await writeToFile(bytes!);

                          //     var signatureMemory =
                          //         Image.memory(bytes.buffer.asUint8List());

                          //     provider.uploadBusinessData(
                          //         context, addLogo, file);
                          //   }
                          // }

                          Future<File> writeToFile(ByteData data) async {
                            //   final buffer = data.buffer;
                            Directory tempDir = await getTemporaryDirectory();
                            String tempPath = tempDir.path;
                            var filePath = '$tempPath/signature.png';
                            return File(filePath).writeAsBytes(
                                data.buffer.asUint8List(
                                    data.offsetInBytes, data.lengthInBytes),
                                flush: true);
                          }

                          if (_controller.isEmpty) {
                            setState(
                              () {
                                createdSignature = false;
                                signatureMemory = null;
                              },
                            );
                            Navigator.pop(context);
                          } else {
                            var image = await _controller.toImage();
                            final bytes = await image!
                                .toByteData(format: ui.ImageByteFormat.png);
                            var file = await writeToFile(bytes!);

                            signatureMemory =
                                Image.memory(bytes.buffer.asUint8List());

                            setState(
                              () {
                                addSignature = null;
                                createdSignature = true;
                                signatureFile = file;
                              },
                            );

                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Save')),
                  ),
                ],
              ),
            );
          });
        });
  }
}
