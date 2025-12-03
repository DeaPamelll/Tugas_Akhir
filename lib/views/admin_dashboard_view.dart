import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_transaksi_controller.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminDashboardView extends StatelessWidget {
  final c = Get.put(AdminTransaksiController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        centerTitle: true,
      ),
      body: GetBuilder<AdminTransaksiController>(
        builder: (_) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                /// -------------------------------------
                /// TOTAL INCOME CARD
                /// -------------------------------------
                Card(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      "Total Pendapatan: \$${c.totalIncome.toStringAsFixed(2)}",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// -------------------------------------
                /// GRAFIK PENDAPATAN
                /// -------------------------------------
                Text("Grafik Pendapatan Per Bulan", 
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),

                SizedBox(
                  height: 250,
                  child: BarChart(
                    BarChartData(
                      barGroups: _buildBarGroups(c),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                /// -------------------------------------
                /// LIST TRANSAKSI
                /// -------------------------------------
                Text("Daftar Transaksi", 
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),

                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: c.allTransactions.length,
                  itemBuilder: (context, i) {
                    final tx = c.allTransactions[i];

                    return Card(
                      child: ListTile(
                        title: Text("Transaksi #${tx.id} — \$${tx.total}"),
                        subtitle: Text(
                          "User: ${tx.userId} • ${tx.createdAt} \nStatus: ${tx.status}",
                        ),
                        trailing: PopupMenuButton<String>(
                          icon: Icon(Icons.more_vert),
                          onSelected: (value) {
                            c.updateStatus(tx.id, value);
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(value: "paid", child: Text("Paid")),
                            PopupMenuItem(value: "proses", child: Text("Proses")),
                            PopupMenuItem(value: "dikirim", child: Text("Dikirim")),
                            PopupMenuItem(value: "selesai", child: Text("Selesai")),
                          ],
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }

  /// Build grafik
  List<BarChartGroupData> _buildBarGroups(AdminTransaksiController c) {
    final data = c.monthlyIncome.entries.toList();

    return List.generate(data.length, (i) {
      final monthIncome = data[i].value;

      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: monthIncome,
            width: 20,
            color: Colors.blue,
          )
        ],
      );
    });
  }
}
