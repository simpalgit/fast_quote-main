import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../widgets/app_header.dart';
import '../widgets/stat_card.dart';

class FollowUpItem {
  final String initials;
  final Color color;
  final String company;
  final String quoteNo;
  final String contact;
  final String phone;
  final String date;
  final String time;
  final String status;
  final Color statusColor;
  final Color statusBg;
  final String category; // Today, Overdue, Upcoming, Completed

  const FollowUpItem({
    required this.initials,
    required this.color,
    required this.company,
    required this.quoteNo,
    required this.contact,
    required this.phone,
    required this.date,
    required this.time,
    required this.status,
    required this.statusColor,
    required this.statusBg,
    required this.category,
  });
}

class FollowUpsScreen extends StatefulWidget {
  const FollowUpsScreen({super.key});

  @override
  State<FollowUpsScreen> createState() => _FollowUpsScreenState();
}

class _FollowUpsScreenState extends State<FollowUpsScreen> {
  int _selectedTab = 0;
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';

  final List<String> _tabs = const ['All Follow-ups', 'Today', 'Overdue', 'Upcoming', 'Completed'];

  final List<FollowUpItem> _items = const [
    FollowUpItem(
      initials: 'AB', color: AppColors.primaryBlue, company: 'ABC Industries Pvt Ltd',
      quoteNo: 'FQ-2026-0024', contact: 'Mr. Amit Bansal', phone: '9876543210',
      date: '21 Jul 2026', time: '10:30 AM', status: 'Follow-up Required',
      statusColor: AppColors.primaryBlue, statusBg: AppColors.blueBg, category: 'Today',
    ),
    FollowUpItem(
      initials: 'DE', color: AppColors.green, company: 'Delta Engineering',
      quoteNo: 'FQ-2026-0018', contact: 'Mr. Deepak Mehta', phone: '9820012345',
      date: '21 Jul 2026', time: '12:00 PM', status: 'Positive Response',
      statusColor: AppColors.green, statusBg: AppColors.greenBg, category: 'Today',
    ),
    FollowUpItem(
      initials: 'XY', color: AppColors.orange, company: 'XYZ Corporation',
      quoteNo: 'FQ-2026-0012', contact: 'Mr. Yogesh Kulkarni', phone: '9811122233',
      date: '21 Jul 2026', time: '03:30 PM', status: 'Meeting Required',
      statusColor: Colors.amber, statusBg: AppColors.orangeBg, category: 'Today',
    ),
    FollowUpItem(
      initials: 'GL', color: AppColors.purple, company: 'Global Tech Solutions',
      quoteNo: 'FQ-2026-0009', contact: 'Ms. Neha Gupta', phone: '9870011223',
      date: '21 Jul 2026', time: '11:00 AM', status: 'Negotiation',
      statusColor: AppColors.orange, statusBg: AppColors.orangeBg, category: 'Overdue',
    ),
    FollowUpItem(
      initials: 'PR', color: AppColors.teal, company: 'Prime Solutions Pvt Ltd',
      quoteNo: 'FQ-2026-0007', contact: 'Mr. Prakash Nair', phone: '9899989898',
      date: '22 Jul 2026', time: '02:00 PM', status: 'PI Required',
      statusColor: AppColors.green, statusBg: AppColors.greenBg, category: 'Upcoming',
    ),
    FollowUpItem(
      initials: 'IN', color: AppColors.red, company: 'Innovative Systems',
      quoteNo: 'FQ-2026-0003', contact: 'Mr. Rohan Singh', phone: '9765432100',
      date: '23 Jul 2026', time: '10:00 AM', status: 'Cold Follow-up',
      statusColor: AppColors.red, statusBg: AppColors.redBg, category: 'Upcoming',
    ),
  ];

  List<FollowUpItem> get _filtered {
    var list = _items;
    if (_selectedTab != 0) {
      list = list.where((f) => f.category == _tabs[_selectedTab]).toList();
    }
    if (_query.isNotEmpty) {
      final q = _query.toLowerCase();
      list = list.where((f) =>
          f.company.toLowerCase().contains(q) ||
          f.quoteNo.toLowerCase().contains(q) ||
          f.phone.contains(q)).toList();
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
                const Text('Follow-ups', style: AppText.h1),
                Row(
                  children: [
                    _iconBtn(Icons.search, () => _showSnack('Search')),
                    const SizedBox(width: 8),
                    _iconBtn(Icons.filter_list, () => _showSnack('Filter')),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () => _showSnack('Add Follow-up'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('Add Follow-up', style: TextStyle(fontSize: 12)),
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
                ..._filtered.map((f) => _followUpCard(f)),
                if (_filtered.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 30),
                    child: Center(child: Text('No follow-ups found', style: AppText.subtitle)),
                  ),
                const SizedBox(height: 8),
                _statusGuideAndActions(),
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
        decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, size: 18, color: AppColors.textDark),
      ),
    );
  }

  Widget _statStrip() {
    final stats = [
      {'label': 'Today', 'value': '12', 'icon': Icons.access_time, 'color': AppColors.primaryBlue, 'bg': AppColors.blueBg},
      {'label': 'This Week', 'value': '24', 'icon': Icons.calendar_today_outlined, 'color': AppColors.purple, 'bg': AppColors.purpleBg},
      {'label': 'Overdue', 'value': '8', 'icon': Icons.notifications_active_outlined, 'color': AppColors.red, 'bg': AppColors.redBg},
      {'label': 'Completed', 'value': '36', 'icon': Icons.check_circle_outline, 'color': AppColors.green, 'bg': AppColors.greenBg},
      {'label': 'Total', 'value': '128', 'icon': Icons.star_border, 'color': AppColors.orange, 'bg': AppColors.orangeBg},
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
            width: 130,
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
                  Text(_tabs[i], style: TextStyle(
                      color: selected ? AppColors.primaryBlue : AppColors.textGrey,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 13.5)),
                  const SizedBox(height: 6),
                  Container(height: 2.5, width: 30, color: selected ? AppColors.primaryBlue : Colors.transparent),
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
              hintText: 'Search by customer, quotation no., mobile...',
              hintStyle: const TextStyle(fontSize: 12, color: AppColors.textLightGrey),
              prefixIcon: const Icon(Icons.search, size: 20),
              filled: true,
              fillColor: AppColors.cardWhite,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
            ),
          ),
        ),
        const SizedBox(width: 10),
        InkWell(
          onTap: () => _showSnack('Sort'),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
            decoration: BoxDecoration(color: AppColors.cardWhite, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
            child: const Row(
              children: [
                Icon(Icons.swap_vert, size: 16, color: AppColors.textGrey),
                SizedBox(width: 4),
                Text('Next Follow-up', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _followUpCard(FollowUpItem f) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: SectionCard(
        child: Row(
          children: [
            InitialsAvatar(initials: f.initials, color: f.color),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(f.company, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  Text('Quotation: ${f.quoteNo}', style: AppText.small),
                  Text('${f.contact}   ${f.phone}', style: AppText.subtitle),
                  const SizedBox(height: 6),
                  StatusChip(label: f.status, color: f.statusColor, bg: f.statusBg),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text('Next Follow-up', style: AppText.small),
                Text(f.date, style: const TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.w600, fontSize: 12.5)),
                Text(f.time, style: AppText.small),
                const SizedBox(height: 8),
                Row(
                  children: [
                    InkWell(onTap: () => _showSnack('WhatsApp'), child: const Icon(Icons.chat_bubble, color: AppColors.green, size: 20)),
                    const SizedBox(width: 10),
                    InkWell(onTap: () => _showSnack('Call'), child: const Icon(Icons.call, color: AppColors.primaryBlue, size: 20)),
                    const SizedBox(width: 6),
                    const Icon(Icons.chevron_right, color: AppColors.textLightGrey, size: 18),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusGuideAndActions() {
    final statuses = [
      {'label': 'Follow-up Required', 'icon': Icons.access_time, 'color': AppColors.primaryBlue},
      {'label': 'Positive Response', 'icon': Icons.thumb_up_outlined, 'color': AppColors.green},
      {'label': 'Negotiation', 'icon': Icons.handshake_outlined, 'color': AppColors.purple},
      {'label': 'Meeting Required', 'icon': Icons.groups_outlined, 'color': Colors.amber.shade800},
      {'label': 'PI Required', 'icon': Icons.description_outlined, 'color': AppColors.green},
      {'label': 'Cold Follow-up', 'icon': Icons.ac_unit, 'color': AppColors.primaryBlue},
      {'label': 'Won', 'icon': Icons.emoji_events_outlined, 'color': AppColors.green},
    ];
    final actions = [
      {'label': 'Send\nWhatsApp', 'icon': Icons.chat_bubble_outline, 'color': AppColors.green},
      {'label': 'Send\nEmail', 'icon': Icons.mail_outline, 'color': AppColors.purple},
      {'label': 'Schedule\nCall', 'icon': Icons.call_outlined, 'color': AppColors.primaryBlue},
      {'label': 'Add\nNote', 'icon': Icons.note_add_outlined, 'color': AppColors.orange},
      {'label': 'Mark as\nCompleted', 'icon': Icons.check_circle_outline, 'color': AppColors.green},
    ];
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: AppColors.blueBg, borderRadius: BorderRadius.circular(14)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Follow-up Status Guide', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 18,
                runSpacing: 12,
                children: statuses.map((s) {
                  return Column(
                    children: [
                      Icon(s['icon'] as IconData, color: s['color'] as Color, size: 20),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: 66,
                        child: Text(s['label'] as String, textAlign: TextAlign.center, style: AppText.small),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Quick Follow-up Actions', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
              const SizedBox(height: 12),
              Row(
                children: actions.map((a) {
                  return Expanded(
                    child: InkWell(
                      onTap: () => _showSnack(a['label'] as String),
                      child: Column(
                        children: [
                          Icon(a['icon'] as IconData, color: a['color'] as Color, size: 20),
                          const SizedBox(height: 6),
                          Text(a['label'] as String, textAlign: TextAlign.center, style: AppText.small),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
