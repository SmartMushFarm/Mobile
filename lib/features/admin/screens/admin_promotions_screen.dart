import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
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
        _error = 'Không thể tải danh sách khuyến mãi';
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
          title: Text(isEditing ? 'Sửa khuyến mãi' : 'Tạo khuyến mãi'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: codeController,
                  decoration: const InputDecoration(labelText: 'Mã khuyến mãi'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: discountController,
                  decoration: const InputDecoration(labelText: 'Phần trăm giảm giá'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                ListTile(
                  title: const Text('Có hiệu lực từ'),
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
                  title: const Text('Có hiệu lực đến'),
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
                      .map((s) => DropdownMenuItem(value: s, child: Text(s == 'Active' ? 'Đang hoạt động' : 'Ngưng hoạt động')))
                      .toList(),
                  onChanged: (v) => setDialogState(() => status = v!),
                  decoration: const InputDecoration(labelText: 'Trạng thái'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
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
              child: Text(isEditing ? 'Lưu' : 'Tạo'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Quản lý khuyến mãi', 
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/admin');
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.primary),
            onPressed: () => _showPromotionDialog(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadPromotions,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
                            const SizedBox(height: 16),
                            Text(_error!, style: const TextStyle(color: Colors.redAccent)),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadPromotions,
                              child: const Text('Thử lại'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : _promotions.isEmpty
                    ? const Center(child: Text('Không tìm thấy khuyến mãi nào.'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _promotions.length,
                        itemBuilder: (context, index) {
                          final p = _promotions[index];
                          final isActive = p.status == 'Active';
                          
                          return Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              leading: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: (isActive ? AppColors.primary : Colors.grey).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.discount_outlined,
                                  color: isActive ? AppColors.primary : Colors.grey,
                                ),
                              ),
                              title: Text(p.code, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text('Giảm giá ${p.discountPercent}%', 
                                    style: const TextStyle(color: AppColors.shopPrice, fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 2),
                                  Text('Hết hạn: ${DateFormat('yyyy-MM-dd').format(p.validTo)}', 
                                    style: const TextStyle(fontSize: 12)),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit_outlined, color: Colors.blueAccent),
                                    onPressed: () => _showPromotionDialog(p),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                    onPressed: () async {
                                      final confirm = await showDialog<bool>(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Xóa khuyến mãi'),
                                          content: const Text('Bạn có chắc chắn muốn xóa khuyến mãi này không?'),
                                          actions: [
                                            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Hủy')),
                                            TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Xóa', style: TextStyle(color: Colors.red))),
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
              ),
    );
  }
}
