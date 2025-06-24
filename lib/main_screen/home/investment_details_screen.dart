import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';

class InvestmentDetailsScreen extends StatefulWidget {
  final String symbol;

  const InvestmentDetailsScreen({super.key, required this.symbol});

  @override
  State<InvestmentDetailsScreen> createState() => _InvestmentDetailsScreenState();
}

class _InvestmentDetailsScreenState extends State<InvestmentDetailsScreen> {
  final Dio _dio = Dio();

  String companyName = '';
  double? currentPrice;
  double? previousClose;
  List<FlSpot> chartPoints = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final symbol = widget.symbol;

      // 1. Get Price + Company Info
      final infoRes = await _dio.get(
        'https://query1.finance.yahoo.com/v10/finance/quoteSummary/$symbol?modules=price',
      );

      final priceInfo = infoRes.data['quoteSummary']['result'][0]['price'];

      companyName = priceInfo['longName'] ?? symbol;
      currentPrice = double.tryParse(priceInfo['regularMarketPrice'].toString());
      previousClose = double.tryParse(priceInfo['regularMarketPreviousClose'].toString());

      // 2. Get Chart Data (1 month, daily interval)
      final chartRes = await _dio.get(
        'https://query1.finance.yahoo.com/v8/finance/chart/$symbol?range=1mo&interval=1d',
      );

      final timestamps = chartRes.data['chart']['result'][0]['timestamp'];
      final closes = chartRes.data['chart']['result'][0]['indicators']['quote'][0]['close'];

      chartPoints = List<FlSpot>.generate(
        closes.length,
            (i) => FlSpot(i.toDouble(), closes[i] ?? 0),
      );

      setState(() => isLoading = false);
    } catch (e) {
      print("Error: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.symbol)),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(companyName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text("Price: \$${currentPrice?.toStringAsFixed(2)}"),
            if (previousClose != null && currentPrice != null)
              Text(
                "Change: ${(currentPrice! - previousClose!).toStringAsFixed(2)}"
                    " (${(((currentPrice! - previousClose!) / previousClose!) * 100).toStringAsFixed(2)}%)",
                style: TextStyle(
                  color: currentPrice! >= previousClose! ? Colors.green : Colors.red,
                ),
              ),
            SizedBox(height: 20),
            Expanded(
              child: LineChart(
                LineChartData(
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      color: Colors.blue,
                      spots: chartPoints,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    )
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
