// import 'package:flutter/material.dart';
//
// class NavItemData {
//   final IconData icon;
//   final IconData activeIcon;
//   final String label;
//
//   const NavItemData({
//     required this.icon,
//     required this.activeIcon,
//     required this.label,
//   });
// }
//
// /// Bottom navigation bar with 6 tabs: Dashboard, Leads, Quotations,
// /// Follow-ups, Reports, More. StatefulWidget so each item can animate
// /// on tap independently of parent rebuilds.
// class FastQuoteBottomNav extends StatefulWidget {
//   final int currentIndex;
//   final ValueChanged<int> onTap;
//
//   const FastQuoteBottomNav({
//     super.key,
//     required this.currentIndex,
//     required this.onTap,
//   });
//
//   static const List<NavItemData> items = [
//     NavItemData(
//         icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Dashboard'),
//     NavItemData(
//         icon: Icons.people_outline,
//         activeIcon: Icons.people,
//         label: 'Leads'),
//     NavItemData(
//         icon: Icons.description_outlined,
//         activeIcon: Icons.description,
//         label: 'Quotations'),
//     NavItemData(
//         icon: Icons.notifications_none_rounded,
//         activeIcon: Icons.notifications,
//         label: 'Follow-ups'),
//     NavItemData(
//         icon: Icons.pie_chart_outline,
//         activeIcon: Icons.pie_chart,
//         label: 'Reports'),
//     NavItemData(
//         icon: Icons.more_horiz, activeIcon: Icons.more_horiz, label: 'More'),
//   ];
//
//   @override
//   State<FastQuoteBottomNav> createState() => _FastQuoteBottomNavState();
// }
//
// class _FastQuoteBottomNavState extends State<FastQuoteBottomNav> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         color: AppColors.cardWhite,
//         border: Border(top: BorderSide(color: AppColors.border)),
//       ),
//       child: SafeArea(
//         top: false,
//         child: SizedBox(
//           height: 62,
//           child: Row(
//             children: List.generate(FastQuoteBottomNav.items.length, (index) {
//               final item = FastQuoteBottomNav.items[index];
//               final bool selected = widget.currentIndex == index;
//               final Color color =
//                   selected ? AppColors.primaryBlue : AppColors.textLightGrey;
//               return Expanded(
//                 child: InkWell(
//                   onTap: () => widget.onTap(index),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(selected ? item.activeIcon : item.icon,
//                           color: color, size: 23),
//                       const SizedBox(height: 3),
//                       Text(
//                         item.label,
//                         style: TextStyle(
//                           fontSize: 10.5,
//                           color: color,
//                           fontWeight:
//                               selected ? FontWeight.w700 : FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }),
//           ),
//         ),
//       ),
//     );
//   }
// }
