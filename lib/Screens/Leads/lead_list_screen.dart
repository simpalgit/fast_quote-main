import 'package:flutter/material.dart';

import '../../Widgets/app_header.dart';
import '../../Widgets/stat_card.dart';
import '../../app_colors.dart';


class Lead {
  final String initials;
  final Color color;
  final String company;
  final String contact;
  final String phone;
  final String email;
  final String source;
  final String value;
  final String status;
  final Color statusColor;
  final Color statusBg;
  final String date;
  final String owner;
  final String stage; // used for tab filtering

  const Lead({
    required this.initials,
    required this.color,
    required this.company,
    required this.contact,
    required this.phone,
    required this.email,
    required this.source,
    required this.value,
    required this.status,
    required this.statusColor,
    required this.statusBg,
    required this.date,
    required this.owner,
    required this.stage,
  });
}

class LeadsScreen extends StatefulWidget {
  const LeadsScreen({super.key});

  @override
  State<LeadsScreen> createState() => _LeadsScreenState();
}

class _LeadsScreenState extends State<LeadsScreen> {
  int _selectedTab = 0;
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';

  final List<String> _tabs = const [
    'All Leads', 'New', 'Follow-up', 'Negotiation', 'Won', 'Lost'
  ];

  final List<Lead> _leads = const [
    Lead(
      initials: 'AB', color: AppColors.primaryBlue,
      company: 'ABC Industries Pvt Ltd', contact: 'Mr. Amit Bansal',
      phone: '9876543210', email: 'amit@abcindustries.com',
      source: 'Website', value: '₹ 8,50,000',
      status: 'Follow-up Due', statusColor: AppColors.purple, statusBg: AppColors.purpleBg,
      date: '21 Jul 2026', owner: 'Binod Yadav', stage: 'Follow-up',
    ),
    Lead(
      initials: 'DE', color: AppColors.green,
      company: 'Delta Engineering', contact: 'Mr. Deepak Mehta',
      phone: '9820012345', email: 'deepak@deltaengg.com',
      source: 'Referral', value: '₹ 5,20,000',
      status: 'Negotiation', statusColor: AppColors.orange, statusBg: AppColors.orangeBg,
      date: '22 Jul 2026', owner: 'Rohit Sharma', stage: 'Negotiation',
    ),
    Lead(
      initials: 'XY', color: AppColors.orange,
      company: 'XYZ Corporation', contact: 'Mr. Yogesh Kulkarni',
      phone: '9811122233', email: 'yogesh@xyzcorp.com',
      source: 'Trade Show', value: '₹ 12,00,000',
      status: 'New Lead', statusColor: AppColors.primaryBlue, statusBg: AppColors.blueBg,
      date: '23 Jul 2026', owner: 'Binod Yadav', stage: 'New',
    ),
    Lead(
      initials: 'GL', color: AppColors.purple,
      company: 'Global Tech Solutions', contact: 'Ms. Neha Gupta',
      phone: '9870011223', email: 'neha@globaltech.com',
      source: 'LinkedIn', value: '₹ 3,75,000',
      status: 'Cold Follow-up', statusColor: AppColors.textGrey, statusBg: AppColors.background,
      date: '24 Jul 2026', owner: 'Rohit Sharma', stage: 'Follow-up',
    ),
    Lead(
      initials: 'PR', color: AppColors.teal,
      company: 'Prime Solutions Pvt Ltd', contact: 'Mr. Prakash Nair',
      phone: '9899989898', email: 'prakash@primesolutions.com',
      source: 'Walk-in', value: '₹ 6,80,000',
      status: 'Won', statusColor: AppColors.green, statusBg: AppColors.greenBg,
      date: '18 Jul 2026', owner: 'Binod Yadav', stage: 'Won',
    ),
  ];

  List<Lead> get _filtered {
    var list = _leads;
    if (_selectedTab != 0) {
      list = list.where((l) => l.stage == _tabs[_selectedTab]).toList();
    }
    if (_query.isNotEmpty) {
      final q = _query.toLowerCase();
      list = list.where((l) =>
      l.company.toLowerCase().contains(q) ||
          l.contact.toLowerCase().contains(q) ||
          l.phone.contains(q) ||
          l.email.toLowerCase().contains(q)).toList();
    }
    return list;
  }

  void _showSnack(String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(label), duration: const Duration(seconds: 1)),
    );
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppHeader(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Leads', style: AppText.h1),
                Row(
                  children: [
                    _iconBtn(Icons.search, () => _showSnack('Search')),
                    const SizedBox(width: 8),
                    _iconBtn(Icons.filter_list, () => _showSnack('Filter')),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () => _showSnack('Add Lead'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('Add Lead', style: TextStyle(fontSize: 12.5)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              children: [
                _statStrip(),
                const SizedBox(height: 14),
                _tabBar(),
                const SizedBox(height: 12),
                _searchAndSort(),
                const SizedBox(height: 12),
                ..._filtered.map((l) => _leadCard(l)),
                if (_filtered.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 30),
                    child: Center(child: Text('No leads found', style: AppText.subtitle)),
                  ),
                const SizedBox(height: 8),
                _leadStatusGuideAndActions(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 18, color: AppColors.textDark),
      ),
    );
  }

  Widget _statStrip() {
    final stats = [
      {'label': 'Total Leads', 'value': '${_leads.length}', 'icon': Icons.groups_outlined, 'color': AppColors.primaryBlue, 'bg': AppColors.blueBg},
      {'label': 'New Leads', 'value': '12', 'icon': Icons.filter_alt_outlined, 'color': AppColors.green, 'bg': AppColors.greenBg},
      {'label': 'Follow-ups Due', 'value': '18', 'icon': Icons.calendar_today_outlined, 'color': AppColors.orange, 'bg': AppColors.orangeBg},
      {'label': 'Won Leads', 'value': '7', 'icon': Icons.emoji_events_outlined, 'color': AppColors.primaryBlue, 'bg': AppColors.blueBg},
      {'label': 'Lost Leads', 'value': '5', 'icon': Icons.cancel_outlined, 'color': AppColors.red, 'bg': AppColors.redBg},
    ];
    return SizedBox(
      height: 92,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: stats.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final s = stats[i];
          return SizedBox(
            width: 140,
            child: StatCard(
              label: s['label'] as String,
              value: s['value'] as String,
              icon: s['icon'] as IconData,
              iconColor: s['color'] as Color,
              iconBg: s['bg'] as Color,
            ),
          );
        },
      ),
    );
  }

  Widget _tabBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_tabs.length, (i) {
          final selected = _selectedTab == i;
          return Padding(
            padding: const EdgeInsets.only(right: 20),
            child: InkWell(
              onTap: () => setState(() => _selectedTab = i),
              child: Column(
                children: [
                  Text(
                    _tabs[i],
                    style: TextStyle(
                      color: selected ? AppColors.primaryBlue : AppColors.textGrey,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 13.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 2.5,
                    width: 30,
                    color: selected ? AppColors.primaryBlue : Colors.transparent,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _searchAndSort() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchCtrl,
            onChanged: (v) => setState(() => _query = v),
            decoration: InputDecoration(
              hintText: 'Search leads by name, company, mobile, email...',
              hintStyle: const TextStyle(fontSize: 12.5, color: AppColors.textLightGrey),
              prefixIcon: const Icon(Icons.search, size: 20),
              filled: true,
              fillColor: AppColors.cardWhite,
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.border),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        InkWell(
          onTap: () => _showSnack('Sort'),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
            decoration: BoxDecoration(
              color: AppColors.cardWhite,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: const Row(
              children: [
                Icon(Icons.swap_vert, size: 16, color: AppColors.textGrey),
                SizedBox(width: 4),
                Text('Latest', style: TextStyle(fontSize: 12.5)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _leadCard(Lead l) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: SectionCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InitialsAvatar(initials: l.initials, color: l.color),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.company,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(l.contact, style: AppText.subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text(
                    '${l.phone}   ${l.email}',
                    style: AppText.small,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),

                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center, // Fixed property name
                    children: [
                      StatusChip(
                        label: 'Source: ${l.source}',
                        color: AppColors.textGrey,
                        bg: AppColors.background,
                      ),
                      Text(
                        'Value: ${l.value}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.green,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(width: 8), // Padding added to prevent touching edges
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                StatusChip(label: l.status, color: l.statusColor, bg: l.statusBg),
                const SizedBox(height: 8),
                Text(l.date, style: AppText.small),
                const SizedBox(height: 4),
                Text(l.owner, style: AppText.small),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Widget _leadStatusGuideAndActions() {
    final statuses = [
      {'label': 'New Lead', 'color': AppColors.primaryBlue},
      {'label': 'Follow-up Required', 'color': AppColors.purple},
      {'label': 'Negotiation', 'color': AppColors.orange},
      {'label': 'PI Required', 'color': AppColors.green},
      {'label': 'Cold Follow-up', 'color': AppColors.textGrey},
      {'label': 'Won', 'color': AppColors.green},
      {'label': 'Meeting Required', 'color': Colors.amber},
      {'label': 'Lost/Cancelled', 'color': AppColors.red},
    ];
    final actions = [
      {'label': 'Import Leads', 'icon': Icons.file_upload_outlined},
      {'label': 'Lead Sources', 'icon': Icons.groups_outlined},
      {'label': 'Export Leads', 'icon': Icons.file_download_outlined},
      {'label': 'Lead Status Settings', 'icon': Icons.settings_outlined},
    ];
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.blueBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Lead Status Guide', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: statuses.map((s) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 8, height: 8, decoration: BoxDecoration(color: s['color'] as Color, shape: BoxShape.circle)),
                  const SizedBox(width: 6),
                  Text(s['label'] as String, style: AppText.small),
                ],
              );
            }).toList(),
          ),
          const Divider(height: 26),
          const Text('Quick Actions', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
          const SizedBox(height: 10),
          ...actions.map((a) => InkWell(
            onTap: () => _showSnack(a['label'] as String),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Icon(a['icon'] as IconData, size: 17, color: AppColors.primaryBlue),
                  const SizedBox(width: 10),
                  Expanded(child: Text(a['label'] as String, style: const TextStyle(fontSize: 13))),
                  const Icon(Icons.chevron_right, size: 18, color: AppColors.textLightGrey),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }
}
