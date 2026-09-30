import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fast_quote/Utils/constants.dart';
import 'package:fast_quote/Widgets/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:shimmer/shimmer.dart';

class UploadProfileImagesHelper extends StatelessWidget {
  final String? imagePath;

  final VoidCallback uploadImage, removeImage;
  final CroppedFile? passedfile;
  const UploadProfileImagesHelper(
      {super.key,
      required this.uploadImage,
      required this.removeImage,
      this.passedfile,
      this.imagePath = ""});

  @override
  Widget build(BuildContext context) {
    return passedfile == null
        ? imagePath != ""
            ? Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(0.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: secondary)),
                    height: 130,
                    width: 130,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CustomImage(path: imagePath!),
                    ),
                  ),
                ],
              )
            : Padding(
                padding: const EdgeInsets.all(15.0),
                child: InkWell(
                  onTap: uploadImage,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: secondary,
                        ),
                        borderRadius: BorderRadius.circular(15)),
                    height: 140,
                    width: 150,
                    child: Text(
                      '+ Upload',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: secondary),
                    ),
                  ),
                ),
              )
        : Column(
            children: [
              Container(
                margin: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: secondary)),
                height: 150,
                width: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: InkWell(
                    onTap: uploadImage,
                    child: Image.file(
                      File(passedfile!.path),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              InkWell(
                  onTap: removeImage,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: const Text(
                      'Remove',
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
            ],
          );
  }
}

class UploadImagesHelper extends StatelessWidget {
  final String imagenum;
  final String? imagePath;

  final VoidCallback uploadImage, removeImage;
  final CroppedFile? passedfile;
  const UploadImagesHelper(
      {super.key,
      required this.imagenum,
      required this.uploadImage,
      required this.removeImage,
      this.passedfile,
      this.imagePath = ""});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          imagenum,
          style: TextStyle(
              fontWeight: FontWeight.bold, letterSpacing: 1, color: secondary),
        ),
        passedfile == null
            ? imagePath != ""
                ? Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: secondary)),
                        height: 150,
                        width: 150,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          // child: CustomImage(path: imagePath!),
                          // child: CustomImage(path: imagePath!),
                          child: CachedNetworkImage(
                              imageUrl: imagePath!,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => SizedBox(
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
                              errorWidget: (context, url, error) => Container(
                                  color: primaryColor,
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'Add\nLogo',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ))),
                        ),
                      ),
                      InkWell(
                          onTap: uploadImage,
                          child: Container(
                            decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: const Text(
                              'Upload',
                              style: TextStyle(color: Colors.white),
                            ),
                          )),
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: InkWell(
                      onTap: uploadImage,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: secondary,
                            ),
                            borderRadius: BorderRadius.circular(15)),
                        height: 140,
                        width: 150,
                        child: Text(
                          '+ Upload',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: secondary),
                        ),
                      ),
                    ),
                  )
            : Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: secondary)),
                    height: 150,
                    width: 150,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: InkWell(
                        onTap: uploadImage,
                        child: Image.file(
                          File(passedfile!.path),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                      onTap: removeImage,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: const Text(
                          'Remove',
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                ],
              )
      ],
    );
  }
}

class UploadSignatureHelper extends StatelessWidget {
  final String imagenum;
  final String? imagePath;
  final VoidCallback uploadImage, removeImage;
  final CroppedFile? passedfile;
  final dynamic signatureMemory;
  const UploadSignatureHelper(
      {super.key,
      required this.imagenum,
      required this.uploadImage,
      required this.removeImage,
      this.passedfile,
      this.signatureMemory,
      this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          imagenum,
          style: TextStyle(
              fontWeight: FontWeight.bold, letterSpacing: 1, color: secondary),
        ),
        passedfile == null
            ? imagePath != ""
                ? signatureMemory != null
                    ? Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: secondary)),
                            height: 150,
                            width: 150,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: signatureMemory,
                            ),
                          ),
                          InkWell(
                              onTap: uploadImage,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(12)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: const Text(
                                  'Upload',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )),
                        ],
                      )
                    : Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: secondary)),
                            height: 150,
                            width: 150,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              // child: Image.network(imagePath!),
                              // child: CustomImage(path: imagePath!),
                              child: CachedNetworkImage(
                                imageUrl: imagePath!,
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
                                errorWidget: (context, url, error) => Container(
                                    color: primaryColor,
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'Add\nSignature',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ),
                            ),
                          ),
                          InkWell(
                              onTap: uploadImage,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(12)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: const Text(
                                  'Upload',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )),
                        ],
                      )
                : signatureMemory != null
                    ? Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: secondary)),
                            height: 150,
                            width: 150,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: signatureMemory,
                            ),
                          ),
                          InkWell(
                              onTap: uploadImage,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(12)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: const Text(
                                  'Upload',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )),
                        ],
                      )
                    : Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: InkWell(
                          onTap: uploadImage,
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: secondary,
                                ),
                                borderRadius: BorderRadius.circular(15)),
                            height: 140,
                            width: 150,
                            child: Text(
                              '+ Upload',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: secondary),
                            ),
                          ),
                        ),
                      )
            : Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: secondary)),
                    height: 150,
                    width: 150,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: InkWell(
                        onTap: uploadImage,
                        child: Image.file(
                          File(passedfile!.path),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                      onTap: removeImage,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: const Text(
                          'Remove',
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                ],
              ),
      ],
    );
  }
}
