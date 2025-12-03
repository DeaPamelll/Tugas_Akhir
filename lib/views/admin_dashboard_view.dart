import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../controllers/admin_transaksi_controller.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminDashboardView extends StatelessWidget {
  final c = Get.put(AdminTransaksiController());

  static const ivory = Color(0xFFFFF8F0);
  static const rose = Color(0xFFE8A0BF);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: ivory,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: ivory,
          centerTitle: true,

          title: Text(
            "Admin Dashboard",
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: Colors.black.withOpacity(.85),
            ),
          ),

          actions: [
            IconButton(
              icon: Icon(Icons.logout, color: rose.withOpacity(.9)),
              onPressed: () async {
                final box = await Hive.openBox('userBox');
                await box.clear();
                Get.offAllNamed('/login', predicate: (route) => false);
              },
            ),
          ],

          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: rose, width: .6),
                ),
              ),
              child: const TabBar(
                labelColor: rose,
                unselectedLabelColor: Colors.black54,
                indicatorColor: rose,
                indicatorWeight: 3,
                tabs: [
                  Tab(icon: Icon(Icons.bar_chart), text: "Finance"),
                  Tab(icon: Icon(Icons.shopping_cart), text: "Pesanan"),
                ],
              ),
            ),
          ),
        ),

        body: GetBuilder<AdminTransaksiController>(
          builder: (_) {
            return TabBarView(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _incomeCard(),

                      const SizedBox(height: 22),

                      Text(
                        "Grafik Pendapatan Per Bulan",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.black.withOpacity(.8),
                        ),
                      ),

                      const SizedBox(height: 16),

                      Container(
                        height: 280,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.03),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            )
                          ],
                          border: Border.all(
                            color: rose.withOpacity(.15),
                            width: .8,
                          ),
                        ),
                        padding:
                            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        child: BarChart(
                          BarChartData(
                            barGroups: _buildBarGroups(c),
                            borderData: FlBorderData(show: false),

                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: false,
                              getDrawingHorizontalLine: (value) => FlLine(
                                color: Colors.grey.withOpacity(.15),
                                strokeWidth: .8,
                              ),
                            ),

                            titlesData: FlTitlesData(
                              topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),

                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 28,
                                  getTitlesWidget: (val, meta) => Text(
                                    val.toInt().toString(),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.black.withOpacity(.5),
                                    ),
                                  ),
                                ),
                              ),

                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 24,
                                  getTitlesWidget: (val, meta) {
                                    if (val >= c.monthlyIncome.length) {
                                      return const SizedBox();
                                    }
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Text(
                                        c.monthlyIncome.keys
                                            .elementAt(val.toInt()),
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.black.withOpacity(.55),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        "Manajemen Pesanan",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.black.withOpacity(.85),
                        ),
                      ),

                      const SizedBox(height: 14),

                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: c.allTransactions.length,
                        itemBuilder: (context, i) {
                          final tx = c.allTransactions[i];

                          return Container(
                            margin: const EdgeInsets.only(bottom: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: rose.withOpacity(.25),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(.05),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                )
                              ],
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(14),
                              title: Text(
                                "Transaksi #${tx.id} — \$${tx.total}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 6.0),
                                child: Text(
                                  "User: ${tx.userId}\n"
                                  "Status: ${tx.status}\n"
                                  "Tanggal: ${tx.createdAt}",
                                  style: TextStyle(
                                    height: 1.35,
                                    color: Colors.black.withOpacity(.75),
                                  ),
                                ),
                              ),
                              trailing: PopupMenuButton<String>(
                                icon: Icon(Icons.more_vert, color: rose),
                                onSelected: (value) {
                                  c.updateStatus(tx.id, value);
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                      value: "paid", child: Text("Paid")),
                                  const PopupMenuItem(
                                      value: "process", child: Text("Process")),
                                  const PopupMenuItem(
                                      value: "success", child: Text("Success")),
                                  const PopupMenuItem(
                                      value: "failed", child: Text("Failed")),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _incomeCard() {
    return GetBuilder<AdminTransaksiController>(
      builder: (c) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: rose.withOpacity(.25)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.03),
                blurRadius: 8,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: Text(
            "Total Pendapatan: \$${c.totalIncome.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Colors.black.withOpacity(.8),
            ),
          ),
        );
      },
    );
  }

  List<BarChartGroupData> _buildBarGroups(AdminTransaksiController c) {
    final data = c.monthlyIncome.entries.toList();

    return List.generate(data.length, (i) {
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: data[i].value,
            width: 18,
            color: rose,
            borderRadius: BorderRadius.circular(4),
          )
        ],
      );
    });
  }
}
