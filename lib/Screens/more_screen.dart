import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../widgets/app_header.dart';

class MenuItemData {
  final String label;
  final IconData icon;
  final Color color;
  final Color bg;

  const MenuItemData({
    required this.label,
    required this.icon,
    required this.color,
    required this.bg,
  });
}

class MenuSectionData {
  final String title;
  final IconData icon;
  final List<MenuItemData> items;

  const MenuSectionData({required this.title, required this.icon, required this.items});
}

/// "More" screen: collapsible sections of grid menu items, matching
/// Images 3 & 4. Each section's expand/collapse state is tracked locally.
class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  final List<MenuSectionData> _sections = const [
    MenuSectionData(title: 'Business & Masters', icon: Icons.work_outline, items: [
      MenuItemData(label: 'Customers', icon: Icons.person_outline, color: AppColors.green, bg: AppColors.greenBg),
      MenuItemData(label: 'Products', icon: Icons.inventory_2_outlined, color: AppColors.orange, bg: AppColors.orangeBg),
      MenuItemData(label: 'Services', icon: Icons.build_outlined, color: AppColors.purple, bg: AppColors.purpleBg),
      MenuItemData(label: 'Price List', icon: Icons.currency_rupee, color: AppColors.green, bg: AppColors.greenBg),
      MenuItemData(label: 'Templates', icon: Icons.description_outlined, color: AppColors.red, bg: AppColors.redBg),
      MenuItemData(label: 'Terms & Conditions', icon: Icons.article_outlined, color: AppColors.primaryBlue, bg: AppColors.blueBg),
      MenuItemData(label: 'Taxes & Charges', icon: Icons.percent, color: AppColors.purple, bg: AppColors.purpleBg),
      MenuItemData(label: 'Units', icon: Icons.straighten, color: AppColors.orange, bg: AppColors.orangeBg),
      MenuItemData(label: 'Payment Terms', icon: Icons.payments_outlined, color: AppColors.green, bg: AppColors.greenBg),
      MenuItemData(label: 'Banks', icon: Icons.account_balance_outlined, color: AppColors.purple, bg: AppColors.purpleBg),
    ]),
    MenuSectionData(title: 'Sales & Operations', icon: Icons.show_chart, items: [
      MenuItemData(label: 'Quotations', icon: Icons.description_outlined, color: AppColors.green, bg: AppColors.greenBg),
      MenuItemData(label: 'Follow-ups', icon: Icons.access_time, color: AppColors.purple, bg: AppColors.purpleBg),
      MenuItemData(label: 'Meetings', icon: Icons.groups_outlined, color: AppColors.orange, bg: AppColors.orangeBg),
      MenuItemData(label: 'Proforma Invoices', icon: Icons.description_outlined, color: AppColors.green, bg: AppColors.greenBg),
      MenuItemData(label: 'Sales Orders', icon: Icons.assignment_outlined, color: AppColors.red, bg: AppColors.redBg),
      MenuItemData(label: 'Invoices', icon: Icons.receipt_long_outlined, color: AppColors.primaryBlue, bg: AppColors.blueBg),
      MenuItemData(label: 'Payments', icon: Icons.payments_outlined, color: AppColors.green, bg: AppColors.greenBg),
      MenuItemData(label: 'Expenses', icon: Icons.account_balance_wallet_outlined, color: AppColors.purple, bg: AppColors.purpleBg),
      MenuItemData(label: 'Reminders', icon: Icons.notifications_none, color: AppColors.orange, bg: AppColors.orangeBg),
      MenuItemData(label: 'Notes', icon: Icons.note_outlined, color: AppColors.primaryBlue, bg: AppColors.blueBg),
    ]),
    MenuSectionData(title: 'Reports & Analytics', icon: Icons.pie_chart_outline, items: [
      MenuItemData(label: 'Dashboard', icon: Icons.grid_view, color: AppColors.green, bg: AppColors.greenBg),
      MenuItemData(label: 'Reports', icon: Icons.pie_chart_outline, color: AppColors.purple, bg: AppColors.purpleBg),
      MenuItemData(label: 'Sales Performance', icon: Icons.bar_chart, color: AppColors.orange, bg: AppColors.orangeBg),
      MenuItemData(label: 'Conversion Report', icon: Icons.trending_up, color: AppColors.green, bg: AppColors.greenBg),
      MenuItemData(label: 'Activity Log', icon: Icons.list_alt, color: AppColors.red, bg: AppColors.redBg),
    ]),
    MenuSectionData(title: 'Communication', icon: Icons.chat_bubble_outline, items: [
      MenuItemData(label: 'WhatsApp Logs', icon: Icons.chat_bubble_outline, color: AppColors.green, bg: AppColors.greenBg),
      MenuItemData(label: 'Email Logs', icon: Icons.mail_outline, color: AppColors.purple, bg: AppColors.purpleBg),
      MenuItemData(label: 'SMS Logs', icon: Icons.sms_outlined, color: AppColors.orange, bg: AppColors.orangeBg),
      MenuItemData(label: 'Call Logs', icon: Icons.call_outlined, color: AppColors.green, bg: AppColors.greenBg),
      MenuItemData(label: 'Notifications', icon: Icons.notifications_none, color: AppColors.red, bg: AppColors.redBg),
    ]),
    MenuSectionData(title: 'Settings & Administration', icon: Icons.settings_outlined, items: [
      MenuItemData(label: 'Users & Roles', icon: Icons.people_outline, color: AppColors.green, bg: AppColors.greenBg),
      MenuItemData(label: 'Team Management', icon: Icons.groups_2_outlined, color: AppColors.purple, bg: AppColors.purpleBg),
      MenuItemData(label: 'Permissions', icon: Icons.shield_outlined, color: AppColors.orange, bg: AppColors.orangeBg),
      MenuItemData(label: 'Company Settings', icon: Icons.apartment_outlined, color: AppColors.green, bg: AppColors.greenBg),
      MenuItemData(label: 'App Settings', icon: Icons.settings_outlined, color: AppColors.purple, bg: AppColors.purpleBg),
    ]),
  ];

  late List<bool> _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = List.generate(_sections.length, (_) => true);
  }

  void _showSnack(String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(label), duration: const Duration(seconds: 1)),
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.red, foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(ctx);
              _showSnack('Logged out');
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppHeader(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('More', style: AppText.h1),
          const SizedBox(height: 14),
          ...List.generate(_sections.length, (i) => _sectionCard(i)),
          const SizedBox(height: 6),
          _simpleTile('My Profile', Icons.person_outline, () => _showSnack('My Profile')),
          _simpleTile('Subscription & Plan', Icons.workspace_premium_outlined, () => _showSnack('Subscription & Plan'), color: AppColors.green),
          _simpleTile('Help & Support', Icons.help_outline, () => _showSnack('Help & Support'), color: AppColors.purple),
          _simpleTile('Refer & Earn', Icons.card_giftcard_outlined, () => _showSnack('Refer & Earn'), color: AppColors.orange),
          _simpleTile('Logout', Icons.logout, _confirmLogout, color: AppColors.red),
        ],
      ),
    );
  }

  Widget _sectionCard(int index) {
    final section = _sections[index];
    final expanded = _expanded[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded[index] = !expanded),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Icon(section.icon, size: 18, color: AppColors.primaryBlue),
                  const SizedBox(width: 10),
                  Expanded(child: Text(section.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5))),
                  Icon(expanded ? Icons.expand_less : Icons.expand_more, color: AppColors.textGrey),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: expanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            firstChild: Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: section.items.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 4,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, i) {
                  final item = section.items[i];
                  return InkWell(
                    onTap: () => _showSnack(item.label),
                    child: Column(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(color: item.bg, borderRadius: BorderRadius.circular(12)),
                          child: Icon(item.icon, color: item.color, size: 19),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.label,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 10, color: AppColors.textDark),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            secondChild: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _simpleTile(String label, IconData icon, VoidCallback onTap, {Color color = AppColors.primaryBlue}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: color),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        trailing: const Icon(Icons.chevron_right, color: AppColors.textLightGrey),
      ),
    );
  }
}
