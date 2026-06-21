import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import '../data/admin_promotion_service.dart';
import '../models/promotion_model.dart';

class AdminPromotionsScreen extends StatefulWidget {
  const AdminPromotionsScreen({super.key});

  @override
  State<AdminPromotionsScreen> createState() => _AdminPromotionsScreenState();
}

class _AdminPromotionsScreenState extends State<AdminPromotionsScreen> {
  final AdminPromotionService _promotionService = AdminPromotionService();
  List<PromotionModel> _promotions = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPromotions();
  }

  Future<void> _loadPromotions() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final promotions = await _promotionService.getAllPromotions();
      setState(() {
        _promotions = promotions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Failed to load promotions';
      });
    }
  }

  void _showPromotionDialog([PromotionModel? promotion]) {
    final bool isEditing = promotion != null;
    final codeController = TextEditingController(text: promotion?.code);
    final discountController = TextEditingController(text: promotion?.discountPercent.toString());
    DateTime validFrom = promotion?.validFrom ?? DateTime.now();
    DateTime validTo = promotion?.validTo ?? DateTime.now().add(const Duration(days: 30));
    String status = promotion?.status ?? 'Active';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEditing ? 'Edit Promotion' : 'Create Promotion'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: codeController,
                  decoration: const InputDecoration(labelText: 'Promotion Code'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: discountController,
                  decoration: const InputDecoration(labelText: 'Discount Percent'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                ListTile(
                  title: const Text('Valid From'),
                  subtitle: Text(DateFormat('yyyy-MM-dd').format(validFrom)),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: validFrom,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setDialogState(() => validFrom = picked);
                    }
                  },
                ),
                ListTile(
                  title: const Text('Valid To'),
                  subtitle: Text(DateFormat('yyyy-MM-dd').format(validTo)),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: validTo,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setDialogState(() => validTo = picked);
                    }
                  },
                ),
                DropdownButtonFormField<String>(
                  value: status,
                  items: ['Active', 'Inactive']
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (v) => setDialogState(() => status = v!),
                  decoration: const InputDecoration(labelText: 'Status'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                final newPromotion = PromotionModel(
                  id: promotion?.id,
                  code: codeController.text,
                  discountPercent: int.tryParse(discountController.text) ?? 0,
                  validFrom: validFrom,
                  validTo: validTo,
                  status: status,
                );

                try {
                  if (isEditing) {
                    await _promotionService.updatePromotion(promotion.id!, newPromotion);
                  } else {
                    await _promotionService.createPromotion(newPromotion);
                  }
                  if (mounted) {
                    Navigator.pop(context);
                    _loadPromotions();
                  }
                } catch (e) {
                  // Show error
                }
              },
              child: Text(isEditing ? 'Save' : 'Create'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Promotions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showPromotionDialog(),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : ListView.builder(
                  itemCount: _promotions.length,
                  itemBuilder: (context, index) {
                    final p = _promotions[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text(p.code, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${p.discountPercent}% Discount'),
                            Text('Valid: ${DateFormat('yyyy-MM-dd').format(p.validFrom)} to ${DateFormat('yyyy-MM-dd').format(p.validTo)}'),
                            Text('Status: ${p.status}', style: TextStyle(color: p.status == 'Active' ? Colors.green : Colors.red)),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _showPromotionDialog(p),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Delete Promotion'),
                                    content: const Text('Are you sure you want to delete this promotion?'),
                                    actions: [
                                      TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                                      TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
                                    ],
                                  ),
                                );
                                if (confirm == true) {
                                  await _promotionService.deletePromotion(p.id!);
                                  _loadPromotions();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
