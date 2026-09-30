import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../widgets/stat_card.dart';

class QuoteProduct {
  String name;
  String sku;
  String hsn;
  int qty;
  String unit;
  double rate;
  double discountPercent;
  double taxPercent;

  QuoteProduct({
    required this.name,
    required this.sku,
    required this.hsn,
    required this.qty,
    required this.unit,
    required this.rate,
    required this.discountPercent,
    required this.taxPercent,
  });

  double get baseAmount => qty * rate;
  double get afterDiscount => baseAmount - (baseAmount * discountPercent / 100);
  double get amount => afterDiscount + (afterDiscount * taxPercent / 100);
}

/// Full "New Quotation" creation screen with tabbed sections
/// (Quotation / Products / Terms & Conditions / History), matching the
/// FastQuote mockup. All state (products, discounts, charges) is kept
/// locally with StatefulWidget + setState.
class NewQuotationScreen extends StatefulWidget {
  const NewQuotationScreen({super.key});

  @override
  State<NewQuotationScreen> createState() => _NewQuotationScreenState();
}

class _NewQuotationScreenState extends State<NewQuotationScreen> {
  int _tabIndex = 0;
  final List<String> _tabs = const ['Quotation', 'Products', 'Terms & Conditions', 'History'];

  double _overallDiscountPercent = 5;
  final TextEditingController _freightCtrl = TextEditingController(text: '5000');
  final TextEditingController _installCtrl = TextEditingController(text: '7000');
  final TextEditingController _notesCtrl = TextEditingController();

  final List<QuoteProduct> _products = [
    QuoteProduct(name: 'Air Compressor Model XYZ 10HP', sku: 'AC-10HP-XYZ', hsn: '8414', qty: 2, unit: 'Nos', rate: 75000, discountPercent: 10, taxPercent: 18),
    QuoteProduct(name: 'Air Dryer Model AD-50', sku: 'AD-50', hsn: '8415', qty: 1, unit: 'Nos', rate: 45000, discountPercent: 5, taxPercent: 18),
    QuoteProduct(name: 'Line Filter Kit Standard', sku: 'LF-KIT', hsn: '8421', qty: 1, unit: 'Set', rate: 8500, discountPercent: 0, taxPercent: 18),
  ];

  double get _subTotal => _products.fold(0, (sum, p) => sum + p.baseAmount);
  double get _overallDiscountAmount => _subTotal * _overallDiscountPercent / 100;
  double get _taxableAmount => _subTotal - _overallDiscountAmount;
  double get _totalTax => _products.fold(0.0, (sum, p) {
        final base = p.baseAmount - (p.baseAmount * p.discountPercent / 100);
        return sum + (base * p.taxPercent / 100);
      });
  double get _freight => double.tryParse(_freightCtrl.text) ?? 0;
  double get _install => double.tryParse(_installCtrl.text) ?? 0;
  double get _cgst => _totalTax / 2;
  double get _sgst => _totalTax / 2;
  double get _grandTotalRaw => _taxableAmount + _totalTax + _freight + _install;
  double get _roundOff => (_grandTotalRaw.roundToDouble()) - _grandTotalRaw;
  double get _totalAmount => _grandTotalRaw + _roundOff;

  String _formatCurrency(double value) {
    return value.toStringAsFixed(2).replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d)\.)'), (m) => '${m[1]},');
  }

  void _showSnack(String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(label), duration: const Duration(seconds: 1)),
    );
  }

  void _addProductDialog() {
    final nameCtrl = TextEditingController();
    final rateCtrl = TextEditingController();
    final qtyCtrl = TextEditingController(text: '1');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Product'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Product Name')),
            TextField(controller: qtyCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Quantity')),
            TextField(controller: rateCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Rate (₹)')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.trim().isEmpty) return;
              setState(() {
                _products.add(QuoteProduct(
                  name: nameCtrl.text.trim(),
                  sku: 'SKU-${_products.length + 1}',
                  hsn: '----',
                  qty: int.tryParse(qtyCtrl.text) ?? 1,
                  unit: 'Nos',
                  rate: double.tryParse(rateCtrl.text) ?? 0,
                  discountPercent: 0,
                  taxPercent: 18,
                ));
              });
              Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _freightCtrl.dispose();
    _installCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.cardWhite,
        elevation: 0,
        foregroundColor: AppColors.textDark,
        titleSpacing: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('New Quotation', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            Text('Create professional quotation', style: AppText.small),
          ],
        ),
        actions: [
          IconButton(onPressed: () => _showSnack('Preview'), icon: const Icon(Icons.remove_red_eye_outlined)),
          IconButton(onPressed: () => _showSnack('PDF'), icon: const Icon(Icons.picture_as_pdf_outlined)),
          IconButton(onPressed: () => _showSnack('Send'), icon: const Icon(Icons.send_outlined)),
        ],
      ),
      body: Column(
        children: [
          _tabBar(),
          const Divider(height: 1, color: AppColors.border),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (_tabIndex == 0) ..._quotationTabContent(),
                if (_tabIndex == 1) ..._productsTabContent(),
                if (_tabIndex == 2) ..._termsTabContent(),
                if (_tabIndex == 3) ..._historyTabContent(),
                const SizedBox(height: 90),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _bottomActions(),
    );
  }

  Widget _tabBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(_tabs.length, (i) {
          final selected = _tabIndex == i;
          return Padding(
            padding: const EdgeInsets.only(right: 24, top: 10, bottom: 10),
            child: InkWell(
              onTap: () => setState(() => _tabIndex = i),
              child: Column(
                children: [
                  Text(_tabs[i], style: TextStyle(
                      color: selected ? AppColors.primaryBlue : AppColors.textGrey,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 13.5)),
                  const SizedBox(height: 6),
                  Container(height: 2.5, width: 24, color: selected ? AppColors.primaryBlue : Colors.transparent),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  List<Widget> _quotationTabContent() {
    return [
      SectionCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42, height: 42,
              decoration: BoxDecoration(color: AppColors.blueBg, borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.business, color: AppColors.primaryBlue),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Webvision Softech Pvt Ltd', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  const Text('201, Business Park, Vasai (E),\nPalghar - 401208, Maharashtra, India', style: AppText.small),
                  const SizedBox(height: 4),
                  const Text('+91 9876543210  ·  info@webvisionsoftech.com', style: AppText.small),
                  const Text('GSTIN: 27ABCDE1234F1Z5', style: AppText.small),
                  const SizedBox(height: 6),
                  InkWell(
                    onTap: () => _showSnack('Edit Company'),
                    child: const Text('Edit Company', style: TextStyle(color: AppColors.primaryBlue, fontSize: 12.5, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 12),
      SectionCard(
        child: Column(
          children: [
            _formRow('Quotation No.', 'FQ-2026-0024', editable: true),
            const Divider(height: 20),
            _formRow('Quotation Date', '21 Jul 2026', icon: Icons.calendar_today_outlined),
            const Divider(height: 20),
            _formRow('Valid Till', '04 Aug 2026', icon: Icons.calendar_today_outlined),
            const Divider(height: 20),
            _formRow('Reference', 'Enter Reference (Optional)', isHint: true),
          ],
        ),
      ),
      const SizedBox(height: 12),
      SectionCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.people_outline, size: 18, color: AppColors.primaryBlue),
                SizedBox(width: 6),
                Text('Customer / Lead Details', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
              ],
            ),
            const SizedBox(height: 10),
            const Text('ABC Industries Pvt Ltd', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
            const Text('Mr. Amit Bansal', style: AppText.subtitle),
            const Text('9876543210', style: AppText.subtitle),
            const Text('amit@abcindustries.com', style: AppText.subtitle),
            const Text('Unit No. 15, MIDC, Andheri (E), Mumbai - 400093', style: AppText.small),
            const SizedBox(height: 8),
            InkWell(
              onTap: () => _showSnack('View Lead Details'),
              child: const Text('View Lead Details', style: TextStyle(color: AppColors.primaryBlue, fontSize: 12.5, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
      const SizedBox(height: 12),
      _productsSection(compact: true),
      const SizedBox(height: 12),
      _discountAndTotalsSection(),
      const SizedBox(height: 12),
      SectionCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Notes', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
            const SizedBox(height: 8),
            TextField(
              controller: _notesCtrl,
              maxLength: 300,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Add notes visible to customer...',
                hintStyle: const TextStyle(fontSize: 12.5, color: AppColors.textLightGrey),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 12),
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppColors.blueBg, borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            const Icon(Icons.info_outline, color: AppColors.primaryBlue, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 12.5, color: AppColors.textDark),
                  children: [
                    const TextSpan(text: 'Amount in Words: ', style: TextStyle(fontWeight: FontWeight.w700)),
                    TextSpan(text: _amountInWords(_totalAmount)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  Widget _formRow(String label, String value, {bool editable = false, bool isHint = false, IconData? icon}) {
    return Row(
      children: [
        SizedBox(width: 120, child: Text(label, style: AppText.subtitle)),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: isHint ? FontWeight.normal : FontWeight.w600,
              color: isHint ? AppColors.textLightGrey : AppColors.textDark,
            ),
          ),
        ),
        if (editable) const Icon(Icons.edit, size: 15, color: AppColors.primaryBlue),
        if (icon != null) Icon(icon, size: 16, color: AppColors.textGrey),
      ],
    );
  }

  List<Widget> _productsTabContent() {
    return [_productsSection(compact: false)];
  }

  Widget _productsSection({required bool compact}) {
    return SectionCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.inventory_2_outlined, size: 18, color: AppColors.primaryBlue),
                  SizedBox(width: 6),
                  Text('Products / Services', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                ],
              ),
              ElevatedButton.icon(
                onPressed: _addProductDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.add, size: 15),
                label: const Text('Add Product', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...List.generate(_products.length, (i) {
            final p = _products[i];
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 34, height: 34,
                    decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.inventory_2_outlined, size: 16, color: AppColors.textGrey),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                        Text('HSN: ${p.hsn} · SKU: ${p.sku}', style: AppText.small),
                        const SizedBox(height: 4),
                        Text('${p.qty} ${p.unit} × ₹${p.rate.toStringAsFixed(0)}  ·  Disc ${p.discountPercent.toStringAsFixed(0)}%  ·  Tax ${p.taxPercent.toStringAsFixed(0)}%',
                            style: AppText.small),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('₹${_formatCurrency(p.amount)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert, size: 18, color: AppColors.textGrey),
                        onSelected: (val) {
                          if (val == 'delete') {
                            setState(() => _products.removeAt(i));
                          } else {
                            _showSnack(val);
                          }
                        },
                        itemBuilder: (ctx) => const [
                          PopupMenuItem(value: 'Edit', child: Text('Edit')),
                          PopupMenuItem(value: 'delete', child: Text('Delete')),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: _addProductDialog,
                icon: const Icon(Icons.add, size: 15),
                label: const Text('Add New Row', style: TextStyle(fontSize: 12)),
              ),
              const Spacer(),
              OutlinedButton.icon(
                onPressed: () => _showSnack('Duplicate from Existing'),
                icon: const Icon(Icons.copy_all_outlined, size: 15),
                label: const Text('Duplicate from Existing', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _discountAndTotalsSection() {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.percent, size: 18, color: AppColors.primaryBlue),
              SizedBox(width: 6),
              Text('Discount & Charges', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Expanded(child: Text('Overall Discount', style: AppText.subtitle)),
              SizedBox(
                width: 70,
                child: TextFormField(
                  initialValue: _overallDiscountPercent.toStringAsFixed(0),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    suffixText: '%',
                    contentPadding: const EdgeInsets.symmetric(vertical: 6),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onChanged: (v) => setState(() => _overallDiscountPercent = double.tryParse(v) ?? 0),
                ),
              ),
              const SizedBox(width: 10),
              Text('₹${_formatCurrency(_overallDiscountAmount)}',
                  style: const TextStyle(color: AppColors.green, fontWeight: FontWeight.w600, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 10),
          _chargeField('Freight Charges', _freightCtrl),
          const SizedBox(height: 10),
          _chargeField('Installation Charges', _installCtrl),
          const SizedBox(height: 6),
          InkWell(
            onTap: () => _showSnack('Add Other Charges'),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Add Other Charges', style: TextStyle(color: AppColors.primaryBlue, fontSize: 12.5, fontWeight: FontWeight.w600)),
                Icon(Icons.expand_more, size: 16, color: AppColors.primaryBlue),
              ],
            ),
          ),
          const Divider(height: 26),
          _totalRow('Sub Total', '₹${_formatCurrency(_subTotal)}'),
          _totalRow('Discount (Overall)', '- ₹${_formatCurrency(_overallDiscountAmount)}', color: AppColors.green),
          _totalRow('Taxable Amount', '₹${_formatCurrency(_taxableAmount)}'),
          _totalRow('CGST (9%)', '₹${_formatCurrency(_cgst)}'),
          _totalRow('SGST (9%)', '₹${_formatCurrency(_sgst)}'),
          _totalRow('Round Off', '₹${_roundOff.toStringAsFixed(2)}'),
          const Divider(height: 20),
          _totalRow('Total Amount (₹)', '₹${_formatCurrency(_totalAmount)}', bold: true, big: true),
        ],
      ),
    );
  }

  Widget _chargeField(String label, TextEditingController ctrl) {
    return Row(
      children: [
        Expanded(child: Text(label, style: AppText.subtitle)),
        SizedBox(
          width: 110,
          child: TextField(
            controller: ctrl,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.right,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              prefixText: '₹ ',
              contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _totalRow(String label, String value, {bool bold = false, bool big = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: big ? 15 : 13, fontWeight: bold ? FontWeight.w700 : FontWeight.normal, color: AppColors.textDark)),
          Text(value, style: TextStyle(
              fontSize: big ? 17 : 13,
              fontWeight: bold ? FontWeight.bold : FontWeight.w600,
              color: color ?? (big ? AppColors.primaryBlue : AppColors.textDark))),
        ],
      ),
    );
  }

  List<Widget> _termsTabContent() {
    final terms = [
      '1. Prices are valid for the period mentioned above and subject to revision thereafter.',
      '2. Payment Terms: 50% advance, balance before dispatch.',
      '3. Delivery: 2-3 weeks from receipt of confirmed order & advance.',
      '4. Warranty: 12 months from date of installation / 18 months from date of dispatch, whichever is earlier.',
      '5. Taxes as applicable at the time of billing.',
    ];
    return [
      SectionCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Terms & Conditions', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                InkWell(
                  onTap: () => _showSnack('Edit Terms'),
                  child: const Text('View / Edit', style: TextStyle(color: AppColors.primaryBlue, fontSize: 12.5, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text('Standard Terms & Conditions will be applied to this quotation.', style: AppText.subtitle),
            const SizedBox(height: 12),
            ...terms.map((t) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(t, style: const TextStyle(fontSize: 13, height: 1.4)),
                )),
          ],
        ),
      ),
    ];
  }

  List<Widget> _historyTabContent() {
    final history = [
      {'action': 'Quotation created', 'by': 'Binod Yadav', 'time': '21 Jul 2026, 09:12 AM'},
      {'action': 'Sent via WhatsApp to Mr. Amit Bansal', 'by': 'Binod Yadav', 'time': '21 Jul 2026, 09:20 AM'},
      {'action': 'Viewed by customer', 'by': 'System', 'time': '21 Jul 2026, 11:45 AM'},
    ];
    return [
      SectionCard(
        padding: EdgeInsets.zero,
        child: Column(
          children: List.generate(history.length, (i) {
            final h = history[i];
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.history, size: 18, color: AppColors.primaryBlue),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(h['action']!, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                            Text('by ${h['by']}', style: AppText.small),
                            Text(h['time']!, style: AppText.small),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (i != history.length - 1) const Divider(height: 1, color: AppColors.border),
              ],
            );
          }),
        ),
      ),
    ];
  }

  Widget _bottomActions() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: const BoxDecoration(
        color: AppColors.cardWhite,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _showSnack('Saved as Draft'),
                icon: const Icon(Icons.save_outlined, size: 17),
                label: const Text('Save as Draft'),
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: () => _showSnack('Sent via WhatsApp / Email'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.send, size: 16),
                label: const Text('Send via WhatsApp / Email'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _amountInWords(double amount) {
    // Simplified demo conversion (Indian numbering) — good enough for UI display.
    final rounded = amount.round();
    if (rounded == 0) return 'Zero Only';
    const ones = ['', 'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine',
      'Ten', 'Eleven', 'Twelve', 'Thirteen', 'Fourteen', 'Fifteen', 'Sixteen', 'Seventeen', 'Eighteen', 'Nineteen'];
    const tens = ['', '', 'Twenty', 'Thirty', 'Forty', 'Fifty', 'Sixty', 'Seventy', 'Eighty', 'Ninety'];

    String twoDigits(int n) {
      if (n < 20) return ones[n];
      return '${tens[n ~/ 10]}${n % 10 != 0 ? ' ${ones[n % 10]}' : ''}';
    }

    String threeDigits(int n) {
      if (n >= 100) {
        return '${ones[n ~/ 100]} Hundred${n % 100 != 0 ? ' ${twoDigits(n % 100)}' : ''}';
      }
      return twoDigits(n);
    }

    int n = rounded;
    final crore = n ~/ 10000000;
    n %= 10000000;
    final lakh = n ~/ 100000;
    n %= 100000;
    final thousand = n ~/ 1000;
    n %= 1000;
    final hundred = n;

    final parts = <String>[];
    if (crore > 0) parts.add('${threeDigits(crore)} Crore');
    if (lakh > 0) parts.add('${threeDigits(lakh)} Lakh');
    if (thousand > 0) parts.add('${threeDigits(thousand)} Thousand');
    if (hundred > 0) parts.add(threeDigits(hundred));

    return '${parts.join(' ')} Only';
  }
}
