import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../widgets/app_header.dart';
import '../widgets/stat_card.dart';
import 'new_quotation_screen.dart';

class QuotationsScreen extends StatefulWidget {
  const QuotationsScreen({super.key});

  @override
  State<QuotationsScreen> createState() => _QuotationsScreenState();
}

class _QuotationsScreenState extends State<QuotationsScreen> {
  final List<Map<String, dynamic>> _quotations = const [
    {
      'no': 'FQ-2026-0024', 'company': 'ABC Industries Pvt Ltd', 'date': '21 Jul 2026',
      'amount': '₹ 2,08,786', 'status': 'Sent', 'color': AppColors.primaryBlue, 'bg': AppColors.blueBg,
    },
    {
      'no': 'FQ-2026-0018', 'company': 'Delta Engineering', 'date': '18 Jul 2026',
      'amount': '₹ 3,45,000', 'status': 'Accepted', 'color': AppColors.green, 'bg': AppColors.greenBg,
    },
    {
      'no': 'FQ-2026-0012', 'company': 'XYZ Corporation', 'date': '15 Jul 2026',
      'amount': '₹ 5,90,200', 'status': 'Draft', 'color': AppColors.textGrey, 'bg': AppColors.background,
    },
    {
      'no': 'FQ-2026-0009', 'company': 'Global Tech Solutions', 'date': '10 Jul 2026',
      'amount': '₹ 1,25,000', 'status': 'Rejected', 'color': AppColors.red, 'bg': AppColors.redBg,
    },
    {
      'no': 'FQ-2026-0007', 'company': 'Prime Solutions Pvt Ltd', 'date': '07 Jul 2026',
      'amount': '₹ 6,80,000', 'status': 'Expired', 'color': AppColors.orange, 'bg': AppColors.orangeBg,
    },
  ];

  void _openNewQuotation() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const NewQuotationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppHeader(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openNewQuotation,
        backgroundColor: AppColors.primaryBlue,
        icon: const Icon(Icons.add),
        label: const Text('New Quotation'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Quotations', style: AppText.h1),
          const SizedBox(height: 4),
          const Text('Manage and track all your quotations', style: AppText.subtitle),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: StatCard(label: 'Total', value: '48', icon: Icons.description_outlined, iconColor: AppColors.primaryBlue, iconBg: AppColors.blueBg)),
              const SizedBox(width: 10),
              Expanded(child: StatCard(label: 'Accepted', value: '16', icon: Icons.check_circle_outline, iconColor: AppColors.green, iconBg: AppColors.greenBg)),
              const SizedBox(width: 10),
              Expanded(child: StatCard(label: 'Pending', value: '20', icon: Icons.hourglass_empty, iconColor: AppColors.orange, iconBg: AppColors.orangeBg)),
            ],
          ),
          const SizedBox(height: 20),
          ..._quotations.map((q) => _quotationCard(q)),
          const SizedBox(height: 70),
        ],
      ),
    );
  }

  Widget _quotationCard(Map<String, dynamic> q) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: SectionCard(
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: q['bg'] as Color, borderRadius: BorderRadius.circular(10)),
              child: Icon(Icons.description_outlined, color: q['color'] as Color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(q['no'] as String, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
                  Text(q['company'] as String, style: AppText.subtitle),
                  Text(q['date'] as String, style: AppText.small),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(q['amount'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 6),
                StatusChip(label: q['status'] as String, color: q['color'] as Color, bg: q['bg'] as Color),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
