import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

List<TargetFocus> addHomeTargetsPage({
  required bool isStepsVisible,
  required GlobalKey stepsToStart,
  required GlobalKey customerSupKey,
  required GlobalKey listOfDataKey,
  required GlobalKey customerKey,
  required GlobalKey productKey,
  required GlobalKey termsKey,
  required GlobalKey settingsKey,
  required GlobalKey mainKey,
}) {
  List<TargetFocus> targets = [];

  !isStepsVisible
      ? targets.add(TargetFocus(
          keyTarget: stepsToStart,
          alignSkip: Alignment.bottomRight,
          radius: 10,
          shape: ShapeLightFocus.RRect,
          contents: [
              TargetContent(
                align: ContentAlign.bottom,
                builder: (context, controller) {
                  return Container(
                    alignment: Alignment.center,
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Steps to start using our app",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        )
                      ],
                    ),
                  );
                },
              )
            ]))
      : null;

  targets.add(TargetFocus(
      keyTarget: listOfDataKey,
      alignSkip: Alignment.bottomRight,
      radius: 10,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) {
            return Container(
              alignment: Alignment.center,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "This numbers will indicate how many Enquiries , Quotations and invoices you have created until now.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )
                ],
              ),
            );
          },
        )
      ]));

  targets.add(TargetFocus(
      keyTarget: customerKey,
      alignSkip: Alignment.bottomRight,
      radius: 10,
      shape: ShapeLightFocus.Circle,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) {
            return Container(
              alignment: Alignment.center,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "You can take a look of your Customer. also can add,remove,update Customer data",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )
                ],
              ),
            );
          },
        )
      ]));
  targets.add(TargetFocus(
      keyTarget: productKey,
      alignSkip: Alignment.bottomRight,
      radius: 10,
      shape: ShapeLightFocus.Circle,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) {
            return Container(
              alignment: Alignment.center,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "You can take a look of your Poducts. also can add,remove,update Products.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )
                ],
              ),
            );
          },
        )
      ]));

  targets.add(TargetFocus(
      keyTarget: termsKey,
      alignSkip: Alignment.bottomRight,
      radius: 10,
      shape: ShapeLightFocus.Circle,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) {
            return Container(
              alignment: Alignment.center,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "You can take a look of your Terms & Conditions. also can add,remove,update Terms & Conditions",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )
                ],
              ),
            );
          },
        )
      ]));

  targets.add(TargetFocus(
      keyTarget: settingsKey,
      alignSkip: Alignment.bottomRight,
      radius: 10,
      shape: ShapeLightFocus.Circle,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) {
            return Container(
              alignment: Alignment.center,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Your Settings are available here ..",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )
                ],
              ),
            );
          },
        )
      ]));

  targets.add(TargetFocus(
      keyTarget: mainKey,
      alignSkip: Alignment.topRight,
      radius: 10,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: ContentAlign.top,
          builder: (context, controller) {
            return Container(
              alignment: Alignment.center,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "In this section you can create multiple Enquiries,Quotations & Invoice and in Lists all created Enquiries,Quotations & Invoices",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )
                ],
              ),
            );
          },
        )
      ]));

  targets.add(TargetFocus(
      keyTarget: customerSupKey,
      alignSkip: Alignment.bottomRight,
      radius: 10,
      shape: ShapeLightFocus.Circle,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) {
            return Container(
              alignment: Alignment.center,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "And finally our Customer support",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )
                ],
              ),
            );
          },
        )
      ]));

  return targets;
}
