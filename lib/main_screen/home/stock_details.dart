import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

class StockDetails extends StatelessWidget {
  final dynamic investment;
  final Map<String, dynamic> nameData;

  const StockDetails({
    super.key,
    required this.investment,
    required this.nameData,
  });

  List<FlSpot> getChartSpots() {
    final prices = investment.historicalPrices.cast<double>();
    return List<FlSpot>.generate(
      prices.length,
          (index) => FlSpot(index.toDouble(), prices[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prices = investment.historicalPrices.cast<double>();
    final minY =   investment.historicalPrices
        .map((e) => e as double)
        .reduce(
          (a, b) =>
      a < b ? a : b,
    ) *
        0.95;
    final maxY =  investment.historicalPrices
        .map((e) => e as double)
        .reduce(
          (a, b) =>
      a > b ? a : b,
    ) *
        1.05;
    return Scaffold(
      appBar: AppBar(
        title: Text(nameData["name"]),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            if (nameData["image"] != null && nameData["image"].toString().isNotEmpty)
              Image.network(nameData["image"], width: 80, height: 80),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.center,
              child: Text(
                nameData["name"],
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Type: ${investment.type}",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              "Latest Price: \$${investment.latestPrice.toStringAsFixed(2)}",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              "Last Updated: ${investment.lastUpdated.day}/${investment.lastUpdated.month}/${investment.lastUpdated.year}",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: getChartSpots(),
                      isCurved: true,
                      color: investment.type == 'Stock' ? Colors.blue : Colors.orange,
                      barWidth: 2,
                      belowBarData: BarAreaData(
                        show: true,
                        color: (investment.type == 'Stock' ? Colors.blue : Colors.orange)
                            .withOpacity(0.2),
                      ),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 2,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 || index >= investment.historicalDates.length) {
                            return const Text('');
                          }
                          final date = investment.historicalDates[index].split('-').last;
                          return SideTitleWidget(
                            meta: meta,
                            child: Text(date, style: const TextStyle(fontSize: 10)),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '\$${value.toStringAsFixed(0)}',
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                  minY: minY,
                  maxY: maxY,
                ),
              ),
            ),
            SizedBox(height: 24,),
            Card(
              margin: EdgeInsets.all(8),
              child: ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network("https://i-invdn-com.investing.com/news/LYNXNPEC330YS_M.jpg",height: 200,width: double.infinity, fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200,
                          color: Colors.grey.withAlpha(50),
                        );
                      },),
                    SizedBox(width: 12,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("BlackRock's Fink supports GOP's MAGA accounts for newborns - Semafor"
                            ,style: GoogleFonts.alata(
                                fontWeight: FontWeight.w600,fontSize: 16
                            ),),
                          Text('2025-06-23 16:45:13')
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
