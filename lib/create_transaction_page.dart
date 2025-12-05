import 'package:flutter/material.dart';

class CreateTransactionPage extends StatefulWidget {
  const CreateTransactionPage({super.key});

  @override
  State<CreateTransactionPage> createState() => _CreateTransactionPageState();
}

class _CreateTransactionPageState extends State<CreateTransactionPage>
    with SingleTickerProviderStateMixin {

  late TabController _tabController;

  String? _selectedCategory;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final List<String> expenseCategories = ['Makanan', 'Transportasi', 'Tagihan', 'Lain-lain', 'Belanja', 'Sewa', 'Cemilan', 'Sepeda Motor'];
  final List<String> incomeCategories = ['Gaji', 'Bonus', 'Investasi', 'Lain-lain'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _dateController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Buat Transaksi Baru"),
        backgroundColor: const Color(0xFF005BAC),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: "Pengeluaran"),
            Tab(text: "Pemasukan"),
          ],
        ),
      ),

      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTransactionForm(isExpense: true),
          _buildTransactionForm(isExpense: false),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final type = _tabController.index == 0 ? "Pengeluaran" : "Pemasukan";
          print('Simpan $type: Tanggal: ${_dateController.text}, Kategori: $_selectedCategory, Jumlah: ${_amountController.text}');
          Navigator.pop(context);
        },
        label: const Text("SIMPAN", style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.save, color: Colors.white),
        backgroundColor: const Color(0xFF005BAC),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildTransactionForm({required bool isExpense}) {
    final List<String> categories = isExpense ? expenseCategories : incomeCategories;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _dateController,
            decoration: const InputDecoration(
              labelText: 'Tanggal',
              prefixIcon: Icon(Icons.calendar_today),
              border: OutlineInputBorder(),
            ),
            readOnly: true,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (pickedDate != null) {
                _dateController.text = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
              }
            },
          ),
          const SizedBox(height: 16),

          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Kategori',
              prefixIcon: Icon(Icons.category),
              border: OutlineInputBorder(),
            ),
            value: _selectedCategory,
            items: categories.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedCategory = newValue;
              });
            },
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Jumlah',
              prefixText: 'Rp ',
              prefixIcon: Icon(Icons.attach_money, color: isExpense ? Colors.red : Colors.green),
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _descriptionController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Keterangan (Opsional)',
              prefixIcon: Icon(Icons.description),
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}