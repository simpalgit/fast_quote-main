import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../widgets/app_header.dart';
import '../widgets/stat_card.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  int _selectedTab = 0;
  final List<String> _tabs = const ['Overview', 'Quotations', 'Leads', 'Orders', 'Sales', 'Follow-ups'];
  final List<IconData> _tabIcons = const [
    Icons.bar_chart, Icons.description_outlined, Icons.people_outline,
    Icons.calendar_today_outlined, Icons.shopping_cart_outlined, Icons.grid_view_outlined,
  ];

  void _showSnack(String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(label), duration: const Duration(seconds: 1)),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Reports & Analytics', style: AppText.h1),
                    SizedBox(height: 4),
                    Text('Track your sales performance and business insights', style: AppText.subtitle),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () => _showSnack('Change date range'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.cardWhite,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: const Row(
                children: [
                  Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.textGrey),
                  SizedBox(width: 8),
                  Expanded(child: Text('01 Jul 2026 - 21 Jul 2026', style: TextStyle(fontSize: 12.5))),
                  Icon(Icons.expand_more, size: 18, color: AppColors.textGrey),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          _tabBar(),
          const SizedBox(height: 16),
          if (_selectedTab == 0) ..._overviewContent() else _placeholderTab(),
        ],
      ),
    );
  }

  Widget _placeholderTab() {
    return SizedBox(
      height: 240,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_tabIcons[_selectedTab], size: 40, color: AppColors.textLightGrey),
            const SizedBox(height: 10),
            Text('${_tabs[_selectedTab]} report coming soon', style: AppText.subtitle),
          ],
        ),
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
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () => setState(() => _selectedTab = i),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: selected ? AppColors.blueBg : AppColors.cardWhite,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: selected ? AppColors.primaryBlue : AppColors.border),
                ),
                child: Row(
                  children: [
                    Icon(_tabIcons[i], size: 16, color: selected ? AppColors.primaryBlue : AppColors.textGrey),
                    const SizedBox(width: 6),
                    Text(_tabs[i], style: TextStyle(
                        fontSize: 12.5,
                        color: selected ? AppColors.primaryBlue : AppColors.textGrey,
                        fontWeight: selected ? FontWeight.w700 : FontWeight.w500)),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  List<Widget> _overviewContent() {
    return [
      _statGrid(),
      const SizedBox(height: 16),
      LayoutBuilder(builder: (context, constraints) {
        final isWide = constraints.maxWidth > 700;
        final trend = _quotationValueTrendCard();
        final donut = _quotationsStatusCard();
        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: trend),
              const SizedBox(width: 12),
              Expanded(flex: 2, child: donut),
            ],
          );
        }
        return Column(children: [trend, const SizedBox(height: 12), donut]);
      }),
      const SizedBox(height: 12),
      LayoutBuilder(builder: (context, constraints) {
        final isWide = constraints.maxWidth > 700;
        final sp = _topSalespersonsCard();
        final leads = _leadsBySourceCard();
        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: sp),
              const SizedBox(width: 12),
              Expanded(child: leads),
            ],
          );
        }
        return Column(children: [sp, const SizedBox(height: 12), leads]);
      }),
      const SizedBox(height: 12),
      _popularReportsCard(),
    ];
  }

  Widget _statGrid() {
    final stats = [
      {'label': 'Total Leads', 'value': '136', 'trend': '18% vs last 20 days', 'up': true, 'icon': Icons.groups_outlined, 'color': AppColors.primaryBlue, 'bg': AppColors.blueBg},
      {'label': 'Quotations Created', 'value': '48', 'trend': '22% vs last 20 days', 'up': true, 'icon': Icons.description_outlined, 'color': AppColors.green, 'bg': AppColors.greenBg},
      {'label': 'Quotation Value', 'value': '₹ 24.75 L', 'trend': '25% vs last 20 days', 'up': true, 'icon': Icons.currency_rupee, 'color': AppColors.orange, 'bg': AppColors.orangeBg},
      {'label': 'Accepted Quotations', 'value': '16', 'trend': '23% vs last 20 days', 'up': true, 'icon': Icons.check_circle_outline, 'color': AppColors.green, 'bg': AppColors.greenBg},
      {'label': 'Conversion Rate', 'value': '33.33%', 'trend': '10% vs last 20 days', 'up': true, 'icon': Icons.trending_up, 'color': AppColors.purple, 'bg': AppColors.purpleBg},
      {'label': 'Orders Won', 'value': '12', 'trend': '9% vs last 20 days', 'up': true, 'icon': Icons.shopping_cart_outlined, 'color': AppColors.primaryBlue, 'bg': AppColors.blueBg},
      {'label': 'Revenue', 'value': '₹ 18.40 L', 'trend': '20% vs last 20 days', 'up': true, 'icon': Icons.account_balance_wallet_outlined, 'color': AppColors.primaryBlue, 'bg': AppColors.blueBg},
      {'label': 'Average Order Value', 'value': '₹ 1.53 L', 'trend': '11% vs last 20 days', 'up': true, 'icon': Icons.bar_chart, 'color': AppColors.orange, 'bg': AppColors.orangeBg},
      {'label': 'Pending Follow-ups', 'value': '24', 'trend': '14% vs last 20 days', 'up': false, 'icon': Icons.notifications_active_outlined, 'color': AppColors.red, 'bg': AppColors.redBg},
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: stats.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.55,
      ),
      itemBuilder: (context, i) {
        final s = stats[i];
        return StatCard(
          label: s['label'] as String,
          value: s['value'] as String,
          icon: s['icon'] as IconData,
          iconColor: s['color'] as Color,
          iconBg: s['bg'] as Color,
          trendText: s['trend'] as String,
          trendUp: s['up'] as bool,
        );
      },
    );
  }

  Widget _quotationValueTrendCard() {
    final points = <double>[2, 6, 9, 8, 12, 15, 13, 16, 14, 18, 22.4, 20, 24.75];
    final labels = ['01 Jul', '', '', '06 Jul', '', '', '11 Jul', '', '', '16 Jul', '', '', '21 Jul'];
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Quotation Value Trend', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
              _dropdownChip('Line'),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: LineChartWidget(points: points, labels: labels, peakLabel: '16 Jul', peakValue: '₹ 22.40 L'),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 10, height: 3, color: AppColors.primaryBlue),
              const SizedBox(width: 6),
              const Text('Quotation Value (₹)', style: AppText.small),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quotationsStatusCard() {
    final segments = [
      {'label': 'Draft', 'value': 8, 'color': AppColors.textGrey},
      {'label': 'Sent', 'value': 18, 'color': AppColors.primaryBlue},
      {'label': 'Accepted', 'value': 16, 'color': AppColors.green},
      {'label': 'Rejected', 'value': 4, 'color': AppColors.red},
      {'label': 'Expired', 'value': 2, 'color': AppColors.orange},
    ];
    final total = segments.fold<int>(0, (sum, s) => sum + (s['value'] as int));
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Quotations Status', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
              _dropdownChip('Donut'),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 160,
            child: DonutChartWidget(
              values: segments.map((s) => (s['value'] as int).toDouble()).toList(),
              colors: segments.map((s) => s['color'] as Color).toList(),
              centerValue: '$total',
              centerLabel: 'Total',
            ),
          ),
          const SizedBox(height: 12),
          ...segments.map((s) {
            final pct = ((s['value'] as int) / total * 100);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  Container(width: 8, height: 8, decoration: BoxDecoration(color: s['color'] as Color, shape: BoxShape.circle)),
                  const SizedBox(width: 8),
                  Expanded(child: Text(s['label'] as String, style: AppText.small)),
                  Text('${s['value']} (${pct.toStringAsFixed(1)}%)',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _dropdownChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.border)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: AppText.small),
          const SizedBox(width: 4),
          const Icon(Icons.expand_more, size: 14, color: AppColors.textGrey),
        ],
      ),
    );
  }

  Widget _topSalespersonsCard() {
    final people = [
      {'name': 'Binod Yadav', 'value': '₹ 8.75 L', 'quotes': '18 Quotes', 'won': '6 Won', 'color': AppColors.primaryBlue},
      {'name': 'Rohit Sharma', 'value': '₹ 6.40 L', 'quotes': '14 Quotes', 'won': '4 Won', 'color': AppColors.green},
      {'name': 'Amit Verma', 'value': '₹ 4.30 L', 'quotes': '10 Quotes', 'won': '3 Won', 'color': AppColors.orange},
      {'name': 'Neha Gupta', 'value': '₹ 3.10 L', 'quotes': '8 Quotes', 'won': '2 Won', 'color': AppColors.purple},
      {'name': 'Deepak Mehta', 'value': '₹ 2.60 L', 'quotes': '6 Quotes', 'won': '1 Won', 'color': AppColors.teal},
    ];
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Top Salespersons', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
              _dropdownChip('This Month'),
            ],
          ),
          const SizedBox(height: 12),
          ...List.generate(people.length, (i) {
            final p = people[i];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Text('${i + 1}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textGrey, fontSize: 13)),
                  const SizedBox(width: 10),
                  InitialsAvatar(
                    initials: (p['name'] as String).split(' ').map((e) => e[0]).take(2).join(),
                    color: p['color'] as Color,
                    radius: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p['name'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                        Text('${p['quotes']}   ${p['won']}', style: AppText.small),
                      ],
                    ),
                  ),
                  Text(p['value'] as String, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.green, fontSize: 13)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _leadsBySourceCard() {
    final sources = [
      {'label': 'Website', 'value': 56, 'pct': 41},
      {'label': 'Referral', 'value': 34, 'pct': 25},
      {'label': 'Trade Show', 'value': 20, 'pct': 15},
      {'label': 'Walk-in', 'value': 14, 'pct': 10},
      {'label': 'WhatsApp', 'value': 8, 'pct': 6},
      {'label': 'Others', 'value': 4, 'pct': 3},
    ];
    final maxValue = 60.0;
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Leads by Source', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
              _dropdownChip('Bar'),
            ],
          ),
          const SizedBox(height: 16),
          ...sources.map((s) {
            final value = s['value'] as int;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  SizedBox(width: 70, child: Text(s['label'] as String, style: AppText.small)),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: value / maxValue,
                        minHeight: 14,
                        backgroundColor: AppColors.background,
                        valueColor: const AlwaysStoppedAnimation(AppColors.primaryBlue),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 60,
                    child: Text('$value (${s['pct']}%)', style: AppText.small, textAlign: TextAlign.right),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _popularReportsCard() {
    final reports = [
      {'label': 'Quotation Report', 'sub': 'Detailed quotation list', 'icon': Icons.description_outlined, 'color': AppColors.purple, 'bg': AppColors.purpleBg},
      {'label': 'Customer Report', 'sub': 'Customer-wise summary', 'icon': Icons.groups_outlined, 'color': AppColors.teal, 'bg': AppColors.tealBg},
      {'label': 'Product Report', 'sub': 'Product-wise sales', 'icon': Icons.inventory_2_outlined, 'color': AppColors.orange, 'bg': AppColors.orangeBg},
      {'label': 'Salesperson Report', 'sub': 'Performance by salesman', 'icon': Icons.person_outline, 'color': AppColors.primaryBlue, 'bg': AppColors.blueBg},
      {'label': 'Won / Lost Report', 'sub': 'Analysis of won & lost', 'icon': Icons.emoji_events_outlined, 'color': Colors.amber.shade800, 'bg': AppColors.orangeBg},
      {'label': 'Follow-up Report', 'sub': 'Follow-up activity report', 'icon': Icons.access_time, 'color': AppColors.primaryBlue, 'bg': AppColors.blueBg},
    ];
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Popular Reports', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
              InkWell(
                onTap: () => _showSnack('View All Reports'),
                child: const Text('View All Reports', style: TextStyle(color: AppColors.primaryBlue, fontSize: 12.5, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: reports.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 3.0,
            ),
            itemBuilder: (context, i) {
              final r = reports[i];
              return InkWell(
                onTap: () => _showSnack(r['label'] as String),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: r['bg'] as Color, borderRadius: BorderRadius.circular(8)),
                        child: Icon(r['icon'] as IconData, color: r['color'] as Color, size: 17),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(r['label'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                            Text(r['sub'] as String, style: AppText.small, maxLines: 1, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Custom-painted line chart (no external chart package needed).
/// StatefulWidget so it can track which point the user is tapping/hovering.
class LineChartWidget extends StatefulWidget {
  final List<double> points;
  final List<String> labels;
  final String peakLabel;
  final String peakValue;

  const LineChartWidget({
    super.key,
    required this.points,
    required this.labels,
    required this.peakLabel,
    required this.peakValue,
  });

  @override
  State<LineChartWidget> createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  int? _touchedIndex;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTapDown: (details) {
            final width = constraints.maxWidth - 30;
            final step = width / (widget.points.length - 1);
            final idx = ((details.localPosition.dx - 30) / step).round().clamp(0, widget.points.length - 1);
            setState(() => _touchedIndex = idx);
          },
          child: CustomPaint(
            size: Size(constraints.maxWidth, constraints.maxHeight),
            painter: _LineChartPainter(points: widget.points, touchedIndex: _touchedIndex),
          ),
        );
      },
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> points;
  final int? touchedIndex;

  _LineChartPainter({required this.points, required this.touchedIndex});

  @override
  void paint(Canvas canvas, Size size) {
    const leftPad = 30.0;
    const bottomPad = 20.0;
    final chartWidth = size.width - leftPad;
    final chartHeight = size.height - bottomPad;
    final maxVal = points.reduce((a, b) => a > b ? a : b) * 1.1;

    // Grid lines + Y labels
    final gridPaint = Paint()..color = AppColors.border..strokeWidth = 1;
    final textStyle = TextStyle(color: AppColors.textLightGrey, fontSize: 9);
    for (int i = 0; i <= 4; i++) {
      final y = chartHeight - (chartHeight * i / 4);
      canvas.drawLine(Offset(leftPad, y), Offset(size.width, y), gridPaint);
      final label = ((maxVal * i / 4)).toStringAsFixed(0);
      final tp = TextPainter(
        text: TextSpan(text: '${label}L', style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(0, y - 5));
    }

    final stepX = chartWidth / (points.length - 1);
    final path = Path();
    final fillPath = Path();
    final offsets = <Offset>[];

    for (int i = 0; i < points.length; i++) {
      final x = leftPad + stepX * i;
      final y = chartHeight - (points[i] / maxVal * chartHeight);
      offsets.add(Offset(x, y));
      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, chartHeight);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }
    fillPath.lineTo(offsets.last.dx, chartHeight);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [AppColors.primaryBlue.withOpacity(0.25), AppColors.primaryBlue.withOpacity(0.0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, chartHeight));
    canvas.drawPath(fillPath, fillPaint);

    final linePaint = Paint()
      ..color = AppColors.primaryBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, linePaint);

    final dotPaint = Paint()..color = AppColors.primaryBlue;
    for (int i = 0; i < offsets.length; i++) {
      final isTouched = touchedIndex == i;
      canvas.drawCircle(offsets[i], isTouched ? 5 : 2.5, dotPaint);
      if (isTouched) {
        canvas.drawCircle(offsets[i], 8, Paint()..color = AppColors.primaryBlue.withOpacity(0.2));
        final tp = TextPainter(
          text: TextSpan(
              text: '₹${points[i].toStringAsFixed(2)} L',
              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
          textDirection: TextDirection.ltr,
        )..layout();
        final bubbleRect = Rect.fromCenter(
          center: Offset(offsets[i].dx, offsets[i].dy - 18),
          width: tp.width + 16,
          height: 22,
        );
        canvas.drawRRect(RRect.fromRectAndRadius(bubbleRect, const Radius.circular(6)),
            Paint()..color = AppColors.darkNavy);
        tp.paint(canvas, Offset(bubbleRect.left + 8, bubbleRect.top + 5));
      }
    }
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) =>
      oldDelegate.touchedIndex != touchedIndex || oldDelegate.points != points;
}

/// Custom-painted donut chart. StatefulWidget so tapping a segment can
/// highlight it (simple interactive touch handling via GestureDetector).
class DonutChartWidget extends StatefulWidget {
  final List<double> values;
  final List<Color> colors;
  final String centerValue;
  final String centerLabel;

  const DonutChartWidget({
    super.key,
    required this.values,
    required this.colors,
    required this.centerValue,
    required this.centerLabel,
  });

  @override
  State<DonutChartWidget> createState() => _DonutChartWidgetState();
}

class _DonutChartWidgetState extends State<DonutChartWidget> {
  int? _selected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) => setState(() => _selected = _selected == null ? 0 : null),
      child: CustomPaint(
        size: const Size(double.infinity, 160),
        painter: _DonutPainter(values: widget.values, colors: widget.colors, selected: _selected),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.centerValue, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Text(widget.centerLabel, style: AppText.small),
            ],
          ),
        ),
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  final List<double> values;
  final List<Color> colors;
  final int? selected;

  _DonutPainter({required this.values, required this.colors, this.selected});

  @override
  void paint(Canvas canvas, Size size) {
    final total = values.fold<double>(0, (a, b) => a + b);
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.height / 2) - 4;
    const strokeWidth = 26.0;
    double startAngle = -3.14159 / 2;

    for (int i = 0; i < values.length; i++) {
      final sweep = (values[i] / total) * 2 * 3.14159;
      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.stroke
        ..strokeWidth = selected == i ? strokeWidth + 6 : strokeWidth
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(
        Rect.fromCircle(radius: radius, center: center),
        startAngle,
        sweep,
        false,
        paint,
      );
      startAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) =>
      oldDelegate.selected != selected || oldDelegate.values != values;
}
