import 'package:flutter/material.dart';
import 'create_transaction_page.dart';

// ====================================================
// MODEL DATA TRANSAKSI
// ====================================================
enum TransactionType { expense, income }

class Transaction {
  final String id;
  final DateTime date;
  final String category;
  final double amount;
  final String description;
  final TransactionType type;

  Transaction({
    required this.id,
    required this.date,
    required this.category,
    required this.amount,
    required this.description,
    required this.type,
  });
}

enum TransactionFilter { daily, weekly, monthly, yearly }
// ====================================================

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  // --- DATA DUMMY TRANSAKSI ---
  final List<Transaction> _allTransactions = [
    Transaction(id: '1', date: DateTime(2025, 3, 4), category: 'Lain-Lain', amount: 700000, description: 'Service Mobil', type: TransactionType.expense),
    Transaction(id: '2', date: DateTime(2025, 3, 4), category: 'Makanan', amount: 20000, description: 'Makan bakso', type: TransactionType.expense),
    Transaction(id: '3', date: DateTime(2025, 3, 4), category: 'Belanja', amount: 5500, description: 'Shampo 2 sachet', type: TransactionType.expense),
    Transaction(id: '4', date: DateTime(2025, 3, 3), category: 'Makanan', amount: 25000, description: 'Nasi goreng + es teh', type: TransactionType.expense),
    Transaction(id: '5', date: DateTime(2025, 3, 3), category: 'Makanan', amount: 5000, description: 'Biaya parkir mall', type: TransactionType.expense),
    Transaction(id: '6', date: DateTime(2025, 3, 3), category: 'Sepeda Motor', amount: 25000, description: 'Bensin', type: TransactionType.expense),
    Transaction(id: '7', date: DateTime(2025, 3, 2), category: 'Cemilan', amount: 2000, description: 'Kopi sachet', type: TransactionType.expense),
    Transaction(id: '8', date: DateTime(2025, 3, 2), category: 'Cemilan', amount: 10000, description: 'Beli keripik pisang', type: TransactionType.expense),
    Transaction(id: '9', date: DateTime(2025, 3, 2), category: 'Makanan', amount: 95000, description: 'Jajan JCO', type: TransactionType.expense),
    Transaction(id: '10', date: DateTime(2025, 3, 1), category: 'Gaji', amount: 5800000, description: 'Gaji Bulanan', type: TransactionType.income),
  ];
  // -----------------------------

  double get pemasukan => _allTransactions.where((t) => t.type == TransactionType.income).fold(0.0, (sum, item) => sum + item.amount);
  double get pengeluaran => _allTransactions.where((t) => t.type == TransactionType.expense).fold(0.0, (sum, item) => sum + item.amount);
  double get saldoAkhir => pemasukan - pengeluaran;

  String _formatCurrency(double amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
  }

  void _navigateToCreateTransaction() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CreateTransactionPage(),
      ),
    );
  }

  Map<String, List<Transaction>> _groupTransactionsByDate(List<Transaction> transactions) {
    final Map<String, List<Transaction>> groupedMap = {};
    transactions.sort((a, b) => b.date.compareTo(a.date));

    for (var t in transactions) {
      final key = "${t.date.year}-${t.date.month.toString().padLeft(2, '0')}-${t.date.day.toString().padLeft(2, '0')}";
      if (!groupedMap.containsKey(key)) {
        groupedMap[key] = [];
      }
      groupedMap[key]!.add(t);
    }
    return groupedMap;
  }

  String _formatDateHeader(String dateKey, bool showDayName) {
    try {
      final date = DateTime.parse(dateKey);
      final dayNames = ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'];

      final datePart = date.day.toString().padLeft(2, '0') + '.' + date.month.toString().padLeft(2, '0') + '.2025';

      if (showDayName) {
        final dayIndex = date.weekday % 7;
        final dayName = dayNames[dayIndex == 0 ? 6 : dayIndex - 1];
        return '$datePart  $dayName';
      }
      return datePart;
    } catch (e) {
      return dateKey;
    }
  }

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 4,
      child: Scaffold(

        // ====================================================
        // DRAWER (SIDEBAR TERSEMBUNYI)
        // ====================================================
        endDrawer: Drawer(
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(
                  height: 16,
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Pengaturan'),
                  onTap: () { Navigator.pop(context); /* TODO: Navigasi Pengaturan */ },
                ),
                ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: const Text('Bantuan & Dukungan'),
                  onTap: () { Navigator.pop(context); /* TODO: Navigasi Bantuan */ },
                ),
                ListTile(
                  leading: const Icon(Icons.pie_chart),
                  title: const Text('Laporan Detail'),
                  onTap: () { Navigator.pop(context); /* TODO: Navigasi Laporan */ },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text('Keluar', style: TextStyle(color: Colors.red)),
                  onTap: () { Navigator.pop(context); /* TODO: Logika Logout */ },
                ),
              ],
            ),
          ),
        ),
        // ====================================================

        appBar: AppBar(
          backgroundColor: const Color(0xFF005BAC),
          elevation: 0,
          titleSpacing: 0,
          automaticallyImplyLeading: false,

          title: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: [
                // Bagian Tanggal
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    children: const [
                      Icon(Icons.calendar_today, color: Colors.white, size: 20),
                      SizedBox(width: 6),
                      Text(
                        "Mar 2025",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Icon(Icons.keyboard_arrow_down, color: Colors.white),
                    ],
                  ),
                ),
                const Spacer(),
                // Ikon Aksi (Download, Sort, Filter)
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.download, color: Colors.white),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.swap_vert, color: Colors.white),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.filter_list, color: Colors.white),
                ),

                // Tombol TITIK TIGA (More Vert) - Pemicu Drawer.
                // Hanya satu ini yang diperlukan.
                Builder(
                    builder: (context) {
                      return IconButton(
                        onPressed: () {
                          Scaffold.of(context).openEndDrawer();
                        },
                        icon: const Icon(Icons.more_vert, color: Colors.white),
                      );
                    }
                ),
              ],
            ),
          ),

          bottom: const TabBar(
            isScrollable: false,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: "Harian"),
              Tab(text: "Mingguan"),
              Tab(text: "Bulanan"),
              Tab(text: "Tahunan"),
            ],
          ),
        ),

        body: Column(
          children: [
            _buildSummaryRow(context),

            Expanded(
              child: TabBarView(
                children: [
                  _buildTransactionList(TransactionFilter.daily),
                  _buildTransactionList(TransactionFilter.weekly),
                  _buildTransactionList(TransactionFilter.monthly),
                  _buildTransactionList(TransactionFilter.yearly),
                ],
              ),
            ),
          ],
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: _navigateToCreateTransaction,
          backgroundColor: const Color(0xFF005BAC),
          tooltip: 'Buat Transaksi',
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  // --- WIDGET DAFTAR TRANSAKSI YANG DIKELOMPOKKAN PER TANGGAL ---
  Widget _buildTransactionList(TransactionFilter filter) {
    final List<Transaction> transactions = _allTransactions;
    final groupedTransactions = _groupTransactionsByDate(transactions);

    if (groupedTransactions.isEmpty) {
      return const Center(child: Text("Tidak ada transaksi untuk periode ini."));
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: groupedTransactions.length,
      itemBuilder: (context, index) {
        final dateKey = groupedTransactions.keys.elementAt(index);
        final transactionsOnDate = groupedTransactions[dateKey]!;

        final dailyIncome = transactionsOnDate.where((t) => t.type == TransactionType.income).fold(0.0, (sum, item) => sum + item.amount);
        final dailyExpense = transactionsOnDate.where((t) => t.type == TransactionType.expense).fold(0.0, (sum, item) => sum + item.amount);
        final dailySaldo = dailyIncome - dailyExpense;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateHeader(dateKey),
            ...transactionsOnDate.map((transaction) => _buildTransactionListItem(transaction)).toList(),
            _buildDailyFooter(dailyIncome, dailySaldo),
          ],
        );
      },
    );
  }

  Widget _buildDateHeader(String dateKey) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 4),
      color: Colors.white,
      child: Row(
        children: [
          Text(
            _formatDateHeader(dateKey, false),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(width: 8),
          Text(
            _formatDateHeader(dateKey, true).split(' ').last,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionListItem(Transaction transaction) {
    final isExpense = transaction.type == TransactionType.expense;
    final amountColor = isExpense ? Colors.red.shade700 : Colors.black;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      color: Colors.white,
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              transaction.category,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Text(
              transaction.description,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            width: 90,
            child: Text(
              _formatCurrency(transaction.amount),
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: amountColor,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyFooter(double dailyIncome, double dailySaldo) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              'Rp${_formatCurrency(dailyIncome)}',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 90,
            child: Text(
              'Rp${_formatCurrency(dailySaldo)}',
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(color: Colors.grey.shade300, width: 1.0)
          )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildSummaryItem(
            title: "Pemasukan",
            amount: _formatCurrency(pemasukan),
            color: Colors.green,
          ),
          _buildSummaryItem(
            title: "Pengeluaran",
            amount: _formatCurrency(pengeluaran),
            color: Colors.red,
          ),
          _buildSummaryItem(
            title: "Saldo",
            amount: _formatCurrency(saldoAkhir),
            color: const Color(0xFF005BAC),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({
    required String title,
    required String amount,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Rp$amount',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}