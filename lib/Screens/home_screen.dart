import 'dart:async';

import 'package:fast_quote/Screens/Leads/lead_list_screen.dart';
import 'package:fast_quote/Screens/Leads/lead_model.dart';
import 'package:fast_quote/Screens/Settings/Components/Profile/profile_provider.dart';
import 'package:fast_quote/Utils/common_functions.dart';
import 'package:fast_quote/Utils/constants.dart';
import 'package:fast_quote/Utils/in_app_tour_target.dart';
import 'package:fast_quote/Utils/local_shared_preferences.dart';
import 'package:fast_quote/Utils/route_names.dart';
import 'package:fast_quote/Widgets/Anime/fade_in_anime.dart';
import 'package:fast_quote/Widgets/animated_dialogue.dart';
import 'package:fast_quote/Widgets/app_bottom_nav.dart';
import 'package:fast_quote/Widgets/no_internet_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'Auth/internet_provider.dart';

class HomeScreen extends StatefulWidget {
  final ValueChanged<int>? onNavigateToTab;

  const HomeScreen({super.key, this.onNavigateToTab});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final stepsToStart = GlobalKey();
  final customerSupKey = GlobalKey();
  final listOfDataKey = GlobalKey();
  final customerKey = GlobalKey();
  final productKey = GlobalKey();
  final termsKey = GlobalKey();
  final settingsKey = GlobalKey();
  final mainKey = GlobalKey();
  bool tutorialMark = false;

  int _selectedIndex = 0;

  late TutorialCoachMark tutorialCoachMark;

  // ---------------------------------------------------------------------
  // Tutorial / app-tour
  // ---------------------------------------------------------------------

  void _initHomeScreenAppTour(bool isVisible) {
    tutorialCoachMark = TutorialCoachMark(
      targets: addHomeTargetsPage(
        isStepsVisible: isVisible,
        stepsToStart: stepsToStart,
        customerSupKey: customerSupKey,
        listOfDataKey: listOfDataKey,
        customerKey: customerKey,
        productKey: productKey,
        termsKey: termsKey,
        settingsKey: settingsKey,
        mainKey: mainKey,
      ),
      colorShadow: primaryColor,
      paddingFocus: 10,
      hideSkip: false,
      opacityShadow: 0.8,
      textStyleSkip: TextStyle(fontWeight: FontWeight.bold, color: whiteColor),
      onFinish: () {
        LocalPreferences().setTutorialCompleteBool(true);
      },
      onSkip: () {
        LocalPreferences().setTutorialCompleteBool(true);
        return true;
      },
    );
  }

  void _showHomeScreenAppTour() {
    Future.delayed(const Duration(seconds: 1), () {
      LocalPreferences().getTutorialCompleteBool().then((value) {
        if (value == false) {
          if (context.mounted) {
            setState(() => tutorialMark = false);
            tutorialCoachMark.show(context: context);
          }
        } else {
          setState(() => tutorialMark = false);
        }
      });
    });
  }

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: bgColor,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarColor: bgColor,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    saveInitData();
    super.initState();
  }

  // ---------------------------------------------------------------------
  // Navigation helpers
  // ---------------------------------------------------------------------

  navigateToSettings() async {
    await Navigator.pushNamed(context, RouteNames.settingsScreen).then(onRefresh);
  }

  navigateToSubscription() async {
    await Navigator.pushNamed(context, RouteNames.subscriptionScreen).then(onRefresh);
  }

  navigateToBusinessSettings() async {
    await Navigator.pushNamed(context, RouteNames.manageBusiness).then(onRefresh);
  }

  navigateToQuotationSettings() async {
    await Navigator.pushNamed(context, RouteNames.quotationSetting).then(onRefresh);
  }

  navigateToInvoiceSettings() async {
    await Navigator.pushNamed(context, RouteNames.invoiceSetting).then(onRefresh);
  }

  navigateToCreateEnquiry() async {
    await Navigator.pushNamed(
      context,
      RouteNames.createEnquiry,
      arguments: {"enquiryData": "", "from": "home"},
    ).then(onRefresh);
  }

  navigateToEnquiryList() async {
    await Navigator.pushNamed(context, RouteNames.enquiryList).then(onRefresh);
  }

  navigateToCreateQuotation() async {
    await Navigator.pushNamed(
      context,
      RouteNames.createQuotation,
      arguments: {
        "quotationData": "",
        "quotationNo": "",
        "from": "Home",
        "enqId": "",
      },
    ).then(onRefresh);
  }

  navigateToQuotationList() async {
    await Navigator.pushNamed(context, RouteNames.quotationList).then(onRefresh);
  }

  navigateToCreateInvoice() async {
    await Navigator.pushNamed(
      context,
      RouteNames.createInvoice,
      arguments: {"invoiceData": "", "invoiceNo": "", "from": "Home"},
    ).then(onRefresh);
  }

  navigateToInvoiceList() async {
    await Navigator.pushNamed(context, RouteNames.invoiceList).then(onRefresh);
  }

  navigateToSavedTemplates() async {
    await Navigator.pushNamed(context, RouteNames.templatesScreen).then(onRefresh);
  }

  FutureOr onRefresh(dynamic value) {
    saveInitData();
  }

  saveInitData() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = Provider.of<ProfileProvider>(context, listen: false);
      provider.getProfile(context).then((value) {
        setState(() => tutorialMark = true);
        provider.getHomeData(context).then((value) {
          _initHomeScreenAppTour(
            provider.isQuotationFill &&
                provider.isBusinessFill &&
                provider.isInvoiceFill,
          );
          _showHomeScreenAppTour();
        });
      });
    });

    String taxLabel = await LocalPreferences().getTaxLabel() ?? "";
    String productHsnLabel = await LocalPreferences().getProductHSNLabel() ?? "";
    String otherChargesLabel = await LocalPreferences().getOtherChargesLabel() ?? "";
    if (taxLabel.isEmpty) LocalPreferences().setTaxLabel("Tax");
    if (productHsnLabel.isEmpty) LocalPreferences().setProductHSNLabel("HSN");
    if (otherChargesLabel.isEmpty) {
      LocalPreferences().setOtherChargesLabel("Other Charges");
    }
  }

  void _handleGatedTap({
    required bool isSetupComplete,
    required VoidCallback onProceed,
    required VoidCallback onIncompleteSetup,
    required String incompleteMessage,
  }) {
    final provider = Provider.of<ProfileProvider>(context, listen: false);

    if (!isSetupComplete) {
      showDialog(
        context: context,
        builder: (_) => CustomDialog(
          onTap: () {
            Navigator.pop(context);
            onIncompleteSetup();
          },
          text: incompleteMessage,
        ),
      );
      return;
    }

    if (provider.status) {
      showDialog(
        context: context,
        builder: (_) => SubscriptionErrorCustomDialog(
          btnText: "Subscribe",
          onTap: () {
            Navigator.pop(context);
            navigateToSubscription();
          },
          text: "Your Subscription is ended.",
        ),
      );
      return;
    }

    onProceed();
  }

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    return "Good Evening";
  }

  void _onBottomBarTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (widget.onNavigateToTab != null) {
      widget.onNavigateToTab!(index);
      return;
    }

    switch (index) {
      case 0:
      // Dashboard
        break;
      case 1:
      // Leads
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LeadsScreen()),
        );
        break;
      case 2:
      // Quotations
        navigateToQuotationList();
        break;
      case 3:
      // Reports / Follow-ups
        CommonFunctions.showWarningSnackbar(context, "Reports Coming Soon..");
        break;
      case 4:
      // More
        navigateToSettings();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileProvider>(context);
    final networkStatus = Provider.of<NetworkStatus>(context);
    final setupComplete = provider.isQuotationFill &&
        provider.isBusinessFill &&
        provider.isInvoiceFill;

    return Material(
      child: Scaffold(
        backgroundColor: bgColor,
        body: networkStatus == NetworkStatus.online
            ? SafeArea(
          child: Center(
            child: Container(
              alignment: Alignment.center,
              constraints: const BoxConstraints(minWidth: 800, maxWidth: 800),
              child: AbsorbPointer(
                absorbing: tutorialMark,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      _buildTopBar(),
                      _buildWelcomeBanner(provider),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: [
                            SizedBox(height: 18.h),
                            _buildQuickActionIconsRow(provider),
                            SizedBox(height: 22.h),
                            _buildTodaysSummary(provider),
                            SizedBox(height: 22.h),
                            _buildTodaysFollowUps(),
                            SizedBox(height: 22.h),
                            _buildSalesPipeline(provider),
                            SizedBox(height: 18.h),
                            _buildAIAssistantBanner(),
                            if (!setupComplete) ...[
                              SizedBox(height: 18.h),
                              _buildStepsToStartCard(provider),
                            ],
                            SizedBox(height: 22.h),
                            _buildManageRow(),
                          ],
                        ),
                      ),
                      SizedBox(height: 22.h),
                      _buildQuickActionsPanel(provider),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
            : const NoInternetWidget(),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Bottom Navigation Bar Widget (Image Design Match)
  // ---------------------------------------------------------------------

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomBarTabSelected,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey.shade500,
        selectedLabelStyle: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w500,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_rounded),
            label: 'Leads',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_rounded),
            label: 'Quotations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart_rounded),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz_rounded),
            label: 'More',
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Top bar
  // ---------------------------------------------------------------------

  Widget _buildTopBar() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
      child: Row(
        children: [
          Icon(Icons.menu_rounded, color: primaryColor, size: 24.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Fast",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  TextSpan(
                    text: "Quote",
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              key: customerSupKey,
              borderRadius: BorderRadius.circular(20.r),
              onTap: () => Navigator.pushNamed(context, RouteNames.supportScreen),
              child: Padding(
                padding: EdgeInsets.all(6.r),
                child: Icon(Icons.notifications_none_rounded, color: Colors.black54, size: 22.sp),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          CircleAvatar(
            radius: 16.r,
            backgroundColor: primaryColor.withOpacity(0.15),
            child: Icon(Icons.person, color: primaryColor, size: 18.sp),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Dark "Welcome back" banner
  // ---------------------------------------------------------------------

  Widget _buildWelcomeBanner(ProfileProvider provider) {
    return FadeInWidget(
      duration: const Duration(milliseconds: 400),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: const Color(0xFF0F2A4A),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome back,",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.75),
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      provider.userName.isEmpty ? "there" : provider.userName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      _greeting,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.75),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Today is",
                    style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 11.sp),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    DateFormat("d MMM yyyy, EEE").format(DateTime.now()),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(Icons.calendar_month_rounded, color: Colors.white, size: 18.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Quick-action icon row
  // ---------------------------------------------------------------------

  Widget _buildQuickActionIconsRow(ProfileProvider provider) {
    final actions = <_IconActionSpec>[
      _IconActionSpec(
        title: "New\nQuotation",
        icon: Icons.add_box_rounded,
        color: primaryColor,
        onTap: () => _handleGatedTap(
          isSetupComplete: provider.isQuotationFill && provider.isBusinessFill,
          onProceed: navigateToCreateQuotation,
          onIncompleteSetup: navigateToQuotationSettings,
          incompleteMessage: "Fill Quotation and Business Settings first for creating Quotations.",
        ),
      ),
      _IconActionSpec(
        title: "Send via\nWhatsApp",
        icon: Icons.chat,
        color: const Color(0xFF25D366),
        onTap: () => CommonFunctions.showWarningSnackbar(context, "Coming Soon.."),
      ),
      _IconActionSpec(
        title: "Send via\nEmail",
        icon: Icons.mail_rounded,
        color: const Color(0xFFF2994A),
        onTap: () => CommonFunctions.showWarningSnackbar(context, "Coming Soon.."),
      ),
      _IconActionSpec(
        title: "New\nLead",
        icon: Icons.person_add_alt_1_rounded,
        color: const Color(0xFF6D28D9),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LeadsScreen()),
        ),
      ),
      _IconActionSpec(
        title: "Create\nPI",
        icon: Icons.description_rounded,
        color: const Color(0xFF16A34A),
        onTap: () => _handleGatedTap(
          isSetupComplete: provider.isInvoiceFill && provider.isBusinessFill,
          onProceed: navigateToCreateInvoice,
          onIncompleteSetup: navigateToInvoiceSettings,
          incompleteMessage: "Fill Invoice and Business Settings first for creating Invoices.",
        ),
      ),
      _IconActionSpec(
        title: "More",
        icon: Icons.grid_view_rounded,
        color: greyColor,
        onTap: navigateToSettings,
      ),
    ];

    return FadeInWidget(
      duration: const Duration(milliseconds: 500),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [for (final a in actions) _quickIconAction(a)],
      ),
    );
  }

  Widget _quickIconAction(_IconActionSpec action) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(14.r),
        onTap: action.onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: action.color.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(action.icon, color: action.color, size: 20.sp),
            ),
            SizedBox(height: 6.h),
            Text(
              action.title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // "Today's Summary"
  // ---------------------------------------------------------------------

  Widget _buildTodaysSummary(ProfileProvider provider) {
    final stats = <_SummaryStatSpec>[
      _SummaryStatSpec(Icons.groups_rounded, primaryColor, provider.enquiryLength.toString(), "Total Leads"),
      _SummaryStatSpec(Icons.description_rounded, const Color(0xFF16A34A), provider.quotationLength.toString(), "Quotations"),
      _SummaryStatSpec(Icons.currency_rupee_rounded, const Color(0xFFEA580C), "0", "Quote Value"),
      _SummaryStatSpec(Icons.event_note_rounded, const Color(0xFF7C3AED), "0", "Follow-ups Due"),
      _SummaryStatSpec(Icons.check_circle_rounded, const Color(0xFF2563EB), "0", "Accepted Quotes"),
      _SummaryStatSpec(Icons.cancel_rounded, const Color(0xFFDC2626), "0", "Rejected Quotes"),
      _SummaryStatSpec(Icons.show_chart_rounded, const Color(0xFF0D9488), "0%", "Conversion %"),
      _SummaryStatSpec(Icons.shopping_cart_rounded, const Color(0xFF2563EB), provider.invoiceLength.toString(), "Orders Won"),
      _SummaryStatSpec(Icons.savings_rounded, const Color(0xFF16A34A), "0", "Revenue"),
    ];

    return FadeInWidget(
      duration: const Duration(milliseconds: 550),
      child: Container(
        key: listOfDataKey,
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Today's Summary",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.sp, color: Colors.black87),
                ),
                Text("View All", style: TextStyle(fontSize: 12.sp, color: primaryColor, fontWeight: FontWeight.w600)),
              ],
            ),
            SizedBox(height: 12.h),
            GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 3,
              crossAxisSpacing: 8.w,
              mainAxisSpacing: 8.h,
              childAspectRatio: 1.15,
              children: [for (final s in stats) _summaryStatCell(s)],
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryStatCell(_SummaryStatSpec s) {
    return Container(
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: s.color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(s.icon, color: s.color, size: 16.sp),
          const Spacer(),
          Text(s.value, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15.sp, color: Colors.black87)),
          Text(
            s.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 9.5.sp, color: greyColor, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // "Today's Follow-ups"
  // ---------------------------------------------------------------------

  Widget _buildTodaysFollowUps() {
    final leads = LeadModel.sampleLeads().take(3).toList();

    return FadeInWidget(
      duration: const Duration(milliseconds: 600),
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Today's Follow-ups",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.sp, color: Colors.black87),
                ),
                InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LeadsScreen()),
                  ),
                  child: Text("View All", style: TextStyle(fontSize: 12.sp, color: primaryColor, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            for (final lead in leads)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 6.h),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16.r,
                      backgroundColor: primaryColor.withOpacity(0.12),
                      child: Text(
                        lead.initials,
                        style: TextStyle(color: primaryColor, fontWeight: FontWeight.w800, fontSize: 11.sp),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(lead.company, style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w700)),
                          Text(
                            lead.status.label,
                            style: TextStyle(fontSize: 11.sp, color: lead.status.color, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chat, color: const Color(0xFF25D366), size: 18.sp),
                    SizedBox(width: 10.w),
                    Icon(Icons.call_rounded, color: primaryColor, size: 18.sp),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // "Sales Pipeline"
  // ---------------------------------------------------------------------

  Widget _buildSalesPipeline(ProfileProvider provider) {
    final stages = <_PipelineStageSpec>[
      _PipelineStageSpec(Icons.groups_rounded, primaryColor, "Lead", provider.enquiryLength.toString()),
      _PipelineStageSpec(Icons.description_rounded, const Color(0xFF16A34A), "Quotation", provider.quotationLength.toString()),
      _PipelineStageSpec(Icons.forum_rounded, const Color(0xFFF2994A), "Follow-up", "0"),
      _PipelineStageSpec(Icons.handshake_rounded, const Color(0xFF7C3AED), "Negotiation", "0"),
      _PipelineStageSpec(Icons.emoji_events_rounded, const Color(0xFF16A34A), "Won", provider.invoiceLength.toString()),
    ];

    return FadeInWidget(
      duration: const Duration(milliseconds: 650),
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Sales Pipeline", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.sp, color: Colors.black87)),
            SizedBox(height: 14.h),
            Row(
              children: [
                for (int i = 0; i < stages.length; i++) ...[
                  _pipelineStage(stages[i]),
                  if (i != stages.length - 1)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child: Icon(Icons.arrow_forward_rounded, size: 14.sp, color: greyColor),
                    ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _pipelineStage(_PipelineStageSpec s) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(color: s.color.withOpacity(0.10), shape: BoxShape.circle),
            child: Icon(s.icon, color: s.color, size: 16.sp),
          ),
          SizedBox(height: 6.h),
          Text(s.label, style: TextStyle(fontSize: 9.5.sp, color: greyColor, fontWeight: FontWeight.w600)),
          Text(s.value, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w800, color: Colors.black87)),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // "AI Assistant"
  // ---------------------------------------------------------------------

  Widget _buildAIAssistantBanner() {
    return FadeInWidget(
      duration: const Duration(milliseconds: 700),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: () => CommonFunctions.showWarningSnackbar(context, "AI Assistant — Coming soon.."),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.06),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: primaryColor.withOpacity(0.15)),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(color: primaryColor.withOpacity(0.12), shape: BoxShape.circle),
                child: Icon(Icons.smart_toy_rounded, color: primaryColor, size: 20.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("AI Assistant", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.sp)),
                    Text(
                      "Need help creating a quotation or follow-up message? I can help you!",
                      style: TextStyle(fontSize: 10.5.sp, color: greyColor),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(20.r)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.auto_awesome, color: Colors.white, size: 14),
                    SizedBox(width: 4.w),
                    Text("Ask AI", style: TextStyle(color: Colors.white, fontSize: 11.5.sp, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Customer / Product / Terms / Settings row
  // ---------------------------------------------------------------------

  Widget _buildManageRow() {
    return FadeInWidget(
      duration: const Duration(milliseconds: 600),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ManageDashboard(
            key: customerKey,
            title: "Customer",
            iconString: "assets/images/customer.svg",
            onPressed: () => Navigator.of(context).pushNamed(
              RouteNames.customerScreen,
              arguments: {"from": "false"},
            ),
          ),
          ManageDashboard(
            key: productKey,
            title: "Product",
            iconString: "assets/images/product.svg",
            onPressed: () => Navigator.pushNamed(
              context,
              RouteNames.productScreen,
              arguments: {"from": "false", "fromPage": "Home", "action": "Home"},
            ),
          ),
          ManageDashboard(
            key: termsKey,
            title: "Terms",
            iconString: "assets/images/terms.svg",
            onPressed: () => Navigator.pushNamed(
              context,
              RouteNames.termsScreen,
              arguments: {"initPage": 0},
            ),
          ),
          ManageDashboard(
            key: settingsKey,
            title: "Settings",
            iconString: "assets/images/settings.svg",
            onPressed: navigateToSettings,
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // "Steps to start" onboarding card
  // ---------------------------------------------------------------------

  Widget _buildStepsToStartCard(ProfileProvider provider) {
    return Container(
      key: stepsToStart,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFFCD34D), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.check_circle_outline_rounded, color: primaryColor, size: 20.sp),
                SizedBox(width: 8.w),
                Text(
                  "Steps to start using FastQuote :",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14.sp,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            StepsToStart(
              isTrue: provider.isBusinessFill,
              step: "1. Fill your Business Settings.",
              onTap: navigateToBusinessSettings,
            ),
            SizedBox(height: 8.h),
            StepsToStart(
              isTrue: provider.isQuotationFill,
              step: "2. Fill your Quotation Settings.",
              onTap: navigateToQuotationSettings,
            ),
            SizedBox(height: 8.h),
            StepsToStart(
              isTrue: provider.isInvoiceFill,
              step: "3. Fill your Invoice Settings.",
              onTap: navigateToInvoiceSettings,
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Bottom "Quick Actions" panel
  // ---------------------------------------------------------------------

  Widget _buildQuickActionsPanel(ProfileProvider provider) {
    final quickActions = <_QuickActionSpec>[
      _QuickActionSpec(
        title: 'Create Enquiry',
        icon: 'assets/images/fileadd.svg',
        delayMs: 800,
        onPressed: () => _handleGatedTap(
          isSetupComplete: provider.isBusinessFill,
          onProceed: navigateToCreateEnquiry,
          onIncompleteSetup: navigateToBusinessSettings,
          incompleteMessage:
          "Fill the Business Settings details first for creating Enquiries.",
        ),
      ),
      _QuickActionSpec(
        title: 'Enquiry List',
        icon: 'assets/images/fileedit.svg',
        delayMs: 700,
        onPressed: () => _handleGatedTap(
          isSetupComplete: provider.isBusinessFill,
          onProceed: navigateToEnquiryList,
          onIncompleteSetup: navigateToBusinessSettings,
          incompleteMessage:
          "Fill the Business Settings details first for viewing Enquiries.",
        ),
      ),
      _QuickActionSpec(
        title: 'Create Quotation',
        icon: 'assets/images/fileadd.svg',
        delayMs: 900,
        onPressed: () => _handleGatedTap(
          isSetupComplete: provider.isQuotationFill && provider.isBusinessFill,
          onProceed: navigateToCreateQuotation,
          onIncompleteSetup: navigateToQuotationSettings,
          incompleteMessage:
          "Fill Quotation and Business Settings first for creating Quotations.",
        ),
      ),
      _QuickActionSpec(
        title: 'Quotation List',
        icon: 'assets/images/fileedit.svg',
        delayMs: 800,
        onPressed: () => _handleGatedTap(
          isSetupComplete: provider.isQuotationFill && provider.isBusinessFill,
          onProceed: navigateToQuotationList,
          onIncompleteSetup: navigateToQuotationSettings,
          incompleteMessage:
          "Fill Quotation and Business Settings first for viewing Quotations.",
        ),
      ),
      _QuickActionSpec(
        title: 'Create Invoice',
        icon: 'assets/images/fileadd.svg',
        delayMs: 1000,
        onPressed: () => _handleGatedTap(
          isSetupComplete: provider.isInvoiceFill && provider.isBusinessFill,
          onProceed: navigateToCreateInvoice,
          onIncompleteSetup: navigateToInvoiceSettings,
          incompleteMessage:
          "Fill Invoice and Business Settings first for creating Invoices.",
        ),
      ),
      _QuickActionSpec(
        title: 'Invoice List',
        icon: 'assets/images/fileedit.svg',
        delayMs: 1100,
        onPressed: () => _handleGatedTap(
          isSetupComplete: provider.isInvoiceFill && provider.isBusinessFill,
          onProceed: navigateToInvoiceList,
          onIncompleteSetup: navigateToInvoiceSettings,
          incompleteMessage:
          "Fill Invoice and Business Settings first for viewing Invoices.",
        ),
      ),
      _QuickActionSpec(
        title: 'Challan List',
        icon: 'assets/images/fileedit.svg',
        delayMs: 1100,
        onPressed: () => Navigator.pushNamed(context, RouteNames.challanList),
      ),
      _QuickActionSpec(
        title: 'Market Place',
        icon: 'assets/images/market_place.svg',
        delayMs: 1100,
        onPressed: () => CommonFunctions.showWarningSnackbar(context, "Comming Soon.."),
      ),
    ];

    return Container(
      key: mainKey,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 2,
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 22.h, bottom: 4.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Quick Actions",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                    letterSpacing: -0.2,
                  ),
                ),
                Container(
                  width: 32.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ],
            ),
          ),
          GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 3,
            childAspectRatio: 0.9,
            children: [
              for (final action in quickActions)
                FadeInWidget(
                  duration: Duration(milliseconds: action.delayMs),
                  child: DashBoardWidget(
                    onPressed: action.onPressed,
                    title: action.title,
                    iconString: action.icon,
                  ),
                ),
            ],
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}

class _QuickActionSpec {
  final String title;
  final String icon;
  final int delayMs;
  final VoidCallback onPressed;

  _QuickActionSpec({
    required this.title,
    required this.icon,
    required this.delayMs,
    required this.onPressed,
  });
}

class _IconActionSpec {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  _IconActionSpec({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

class _SummaryStatSpec {
  final IconData icon;
  final Color color;
  final String value;
  final String label;

  _SummaryStatSpec(this.icon, this.color, this.value, this.label);
}

class _PipelineStageSpec {
  final IconData icon;
  final Color color;
  final String label;
  final String value;

  _PipelineStageSpec(this.icon, this.color, this.label, this.value);
}

// ---------------------------------------------------------------------
// Reusable widgets
// ---------------------------------------------------------------------

class ModernCountCard extends StatelessWidget {
  final String count;
  final String title;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  const ModernCountCard({
    super.key,
    required this.count,
    required this.title,
    required this.gradientColors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withOpacity(0.35),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18.r),
          onTap: onTap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18.r),
            child: Stack(
              children: [
                Positioned(
                  right: -15.w,
                  top: -15.h,
                  child: Container(
                    height: 55.h,
                    width: 55.w,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  left: -20.w,
                  bottom: -20.h,
                  child: Container(
                    height: 70.h,
                    width: 70.w,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        count,
                        style: TextStyle(
                          fontSize: 21.sp,
                          fontWeight: FontWeight.w800,
                          color: whiteColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12.5.sp,
                          color: whiteColor.withOpacity(0.92),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ManageDashboard extends StatelessWidget {
  final String title, iconString;
  final VoidCallback onPressed;
  const ManageDashboard({
    super.key,
    required this.title,
    required this.iconString,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16.r),
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: primaryColor.withOpacity(0.12), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: SvgPicture.asset(
              iconString,
              colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcIn),
              height: 28.sp,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: primaryColor,
              fontSize: 12.sp,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class DashBoardWidget extends StatelessWidget {
  final String title, iconString;
  final VoidCallback onPressed;

  const DashBoardWidget({
    super.key,
    required this.onPressed,
    required this.title,
    required this.iconString,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0.r),
      child: Container(
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: primaryColor.withOpacity(0.12), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16.r),
            onTap: onPressed,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      iconString,
                      height: 24.sp,
                      width: 24.sp,
                      colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcIn),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 12.sp,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class StepsToStart extends StatelessWidget {
  final String step;
  final bool isTrue;
  final VoidCallback onTap;
  const StepsToStart({
    super.key,
    required this.isTrue,
    required this.step,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8.r),
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                step,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13.sp,
                  color: Colors.black87,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: isTrue ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                borderRadius: BorderRadius.circular(6.r),
                boxShadow: [
                  BoxShadow(
                    color: (isTrue ? const Color(0xFF10B981) : const Color(0xFFEF4444))
                        .withValues(alpha: 0.25),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                isTrue ? "Complete" : "Pending",
                style: TextStyle(
                  color: whiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 11.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}