import 'package:fast_quote/Screens/Leads/lead_list_screen.dart';
import 'package:fast_quote/Utils/common_functions.dart';
import 'package:fast_quote/Utils/constants.dart';
import 'package:fast_quote/Utils/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// The 5 primary sections of the app, matching the FastQuote bottom nav
/// design: Dashboard | Leads | Quotations | Reports | More.
enum AppTab { dashboard, leads, quotations, reports, more }

/// Shared bottom navigation bar. Each screen (HomeScreen, LeadListScreen, ...)
/// includes this widget in its own Scaffold and passes its own [currentTab]
/// so the right icon is highlighted. Tapping a different tab swaps the whole
/// screen via pushReplacement so the stack never grows unbounded.
class AppBottomNav extends StatelessWidget {
  final AppTab currentTab;
  const AppBottomNav({super.key, required this.currentTab});

  void _onTap(BuildContext context, AppTab tab) {
    if (tab == currentTab) return;

    switch (tab) {
      case AppTab.dashboard:
        Navigator.pushReplacementNamed(context, RouteNames.homeScreen);
        break;
      case AppTab.leads:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LeadsScreen()),
        );
        break;
      case AppTab.quotations:
        Navigator.pushReplacementNamed(context, RouteNames.quotationList);
        break;
      case AppTab.reports:
        CommonFunctions.showWarningSnackbar(context, "Reports — Coming soon..");
        break;
      case AppTab.more:
        Navigator.pushReplacementNamed(context, RouteNames.settingsScreen);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        height: 62.h,
        decoration: BoxDecoration(
          color: whiteColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Row(
          children: [
            _navItem(context, AppTab.dashboard, Icons.home_rounded, "Dashboard"),
            _navItem(context, AppTab.leads, Icons.groups_rounded, "Leads"),
            _navItem(context, AppTab.quotations, Icons.description_rounded, "Quotations"),
            _navItem(context, AppTab.reports, Icons.pie_chart_rounded, "Reports"),
            _navItem(context, AppTab.more, Icons.more_horiz_rounded, "More"),
          ],
        ),
      ),
    );
  }

  Widget _navItem(BuildContext context, AppTab tab, IconData icon, String label) {
    final bool isActive = tab == currentTab;
    final Color color = isActive ? primaryColor : greyColor;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onTap(context, tab),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 6.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 22.sp),
                SizedBox(height: 3.h),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 10.5.sp,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
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
