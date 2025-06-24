import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:stock_market/constants/app_colors.dart';
import 'package:stock_market/main_screen/home/stock_details.dart';

import '../../models/stock_data_model.dart';
import '../watchlist.dart';
import 'investment_details_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _homeScreen();
}

class _homeScreen extends State<HomeScreen> {
  final Dio dio = Dio()..interceptors.add(LogInterceptor(responseBody: true));

  final List<String> symbols = ['AAPL', 'MSFT', 'TSLA', 'GOOG', 'AMZN', 'NVDA', 'BTC', 'ETH'];

  List investments = [];

  Map myData = {};

  @override
  void initState() {
    FirebaseDatabase.instance
        .ref("users")
        .child(FirebaseAuth.instance.currentUser!.uid.toString())
        .onValue
        .listen((event) {
          if (event.snapshot.exists) {
            if (mounted)
              setState(() {
                myData = event.snapshot.value as Map;
              });
          }
        });
    loadInvestments();
    super.initState();
  }

  Future<void> loadInvestments() async {
    for (String symbol in symbols) {
      final investment = await fetchChartData(symbol);
      if (investment != null) {
        setState(() => investments.add(investment));
      }
    }
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  List<FlSpot> getChartSpots(Investment investment) {
    try {
      return investment.historicalPrices
          .asMap()
          .entries
          .map((e) => FlSpot(e.key.toDouble(), (e.value as num).toDouble()))
          .toList();
    } catch (e) {
      print('Conversion error: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              child: Row(
                children: [
                  Text(
                    "Stock Market",
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
            Expanded(
              child: loading
                  ? Center(
                      child: SizedBox(
                        height: 32,
                        width: 32,
                        child: CircularProgressIndicator(color: ksecondary),
                      ),
                    )
                  : SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(investments.length, (
                                index,
                              ) {
                                final investment = investments[index];
                                print(
                                  "RRRRRRRRRRR ${investment.historicalPrices}",
                                );
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => StockDetails(investment: investment, nameData: names["${investment.name}"]),));
                                  },
                                  child: SizedBox(
                                    width: 260,
                                    child: Card(
                                      margin: const EdgeInsets.all(8),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                if(names["${investment.name}"]["image"].toString().isNotEmpty)
                                                Image.network(names["${investment.name}"]["image"],width: 28,height: 28,),
                                                SizedBox(width: 8,),
                                                Text(
                                                  names["${investment.name}"]["name"],
                                                  style: Theme.of(
                                                    context,
                                                  ).textTheme.titleLarge,
                                                ),
                                              ],
                                            ),
                                            Text(
                                              '${investment.type} - \$${investment.latestPrice.toStringAsFixed(2)}',
                                              style: Theme.of(
                                                context,
                                              ).textTheme.bodyMedium,
                                            ),
                                            Text(
                                              'Last Updated: ${investment.lastUpdated.day}/${investment.lastUpdated.month}/${investment.lastUpdated.year}',
                                              style: Theme.of(
                                                context,
                                              ).textTheme.bodySmall,
                                            ),
                                            const SizedBox(height: 16),
                                            // Placeholder for chart (see Chart.js config below)
                                            SizedBox(
                                              height: 100,
                                              child: LineChart(
                                                LineChartData(
                                                  lineBarsData: [
                                                    LineChartBarData(
                                                      spots: getChartSpots(
                                                        investment,
                                                      ),

                                                      isCurved: true,
                                                      color:
                                                          investment.type ==
                                                              'Stock'
                                                          ? Colors.blue
                                                          : Colors.orange,
                                                      barWidth: 2,
                                                      belowBarData: BarAreaData(
                                                        show: true,
                                                        color:
                                                            investment.type ==
                                                                'Stock'
                                                            ? Colors.blue
                                                                  .withOpacity(
                                                                    0.2,
                                                                  )
                                                            : Colors.orange
                                                                  .withOpacity(
                                                                    0.2,
                                                                  ),
                                                      ),
                                                    ),
                                                  ],
                                                  titlesData: FlTitlesData(
                                                    bottomTitles: AxisTitles(
                                                      sideTitles: SideTitles(
                                                        showTitles: false,
                                                        interval: 2,
                                                        getTitlesWidget: (value, meta) {
                                                          final index = value
                                                              .toInt();
                                                          if (index < 0 ||
                                                              index >=
                                                                  investment
                                                                      .historicalDates
                                                                      .length) {
                                                            return const Text('');
                                                          }
                                                          // Show only day of month for brevity
                                                          final date = investment
                                                              .historicalDates[index]
                                                              .split('-')
                                                              .last;
                                                          return SideTitleWidget(
                                                            // axisSide: meta.axisSide,
                                                            meta: meta,
                                                            child: Text(
                                                              date,
                                                              style:
                                                                  const TextStyle(
                                                                    fontSize: 10,
                                                                  ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    leftTitles: AxisTitles(
                                                      sideTitles: SideTitles(
                                                        showTitles: false,
                                                        reservedSize: 40,
                                                        getTitlesWidget: (value, meta) {
                                                          return Text(
                                                            '\$${value.toStringAsFixed(0)}',
                                                            style:
                                                                const TextStyle(
                                                                  fontSize: 10,
                                                                ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    topTitles: const AxisTitles(
                                                      sideTitles: SideTitles(
                                                        showTitles: false,
                                                      ),
                                                    ),
                                                    rightTitles: const AxisTitles(
                                                      sideTitles: SideTitles(
                                                        showTitles: false,
                                                      ),
                                                    ),
                                                  ),
                                                  borderData: FlBorderData(
                                                    show: false,
                                                  ),
                                                  gridData: FlGridData(
                                                    show: false,
                                                  ),
                                                  minY:
                                                      investment.historicalPrices
                                                          .map((e) => e as double)
                                                          .reduce(
                                                            (a, b) =>
                                                                a < b ? a : b,
                                                          ) *
                                                      0.95,

                                                  maxY:
                                                      investment.historicalPrices
                                                          .map((e) => e as double)
                                                          .reduce(
                                                            (a, b) =>
                                                                a > b ? a : b,
                                                          ) *
                                                      1.05,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );

                                // return Container();
                              }),
                            ),
                          ),
                          SizedBox(height: 22),
                          Column(
                            children: List.generate(componies.length, (index) {
                              Map e = componies.elementAt(index);
                              return InkWell(
                                onTap: () {
                                  showPaymentWidget(
                                    e["price"],
                                    context,
                                    e,
                                    myData["balance"],
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.grey.withAlpha(40),
                                  ),
                                  padding: EdgeInsets.all(8),
                                  margin: EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          e["title"],
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            e["price"].toString() + "\$",
                                            style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            e["effect"].toString() + "%",
                                            style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              color: e["effect"] > 0
                                                  ? Colors.green
                                                  : Colors.red,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
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

  List<Investment> list = [];
  final String apiKey = ' 66bee9dfe33f480ea5ed5247703432d5';
  bool loading = true;

  Future<Investment?> fetchChartData(String symbol) async {
    final dio = Dio();
    final url =
        'https://api.twelvedata.com/time_series?symbol=${symbol}&interval=1min&apikey=f4eade5c8a8549e3ac8d7812f2ae002f';

    try {
      final response = await dio.get(url);
      List values = response.data['values'] as List;
      values = values.sublist(0, 10);
      print("GGGGGGGGGGGGGGGGG ${response.data}");

      if (values.isEmpty) return null;

      List<double> prices = [];
      List<String> dates = [];

      for (var v in values) {
        prices.add(double.tryParse(v['close']) ?? 0);
        dates.add(v['datetime']);
      }
      final latest = values.first;

      return Investment(
        id: symbol,
        name: symbol,
        latestPrice: double.tryParse(latest['close']) ?? 0,
        type: 'Stock',
        lastUpdated: DateTime.parse(latest['datetime']),
        historicalPrices: prices.reversed.toList(),
        historicalDates: dates.reversed.toList(),
      );
    } catch (e) {
      print('Error fetching chart data: $e');
    }
  }

  Future<void> fetchInvestments() async {
    final List<Map<String, String>> assets = [
      {'symbol': 'AAPL', 'type': 'Stock', 'endpoint': 'TIME_SERIES_DAILY'},
      {'symbol': 'TSLA', 'type': 'Stock', 'endpoint': 'TIME_SERIES_DAILY'},
      {'symbol': 'GOOGL', 'type': 'Stock', 'endpoint': 'TIME_SERIES_DAILY'},
      {'symbol': 'MSFT', 'type': 'Stock', 'endpoint': 'TIME_SERIES_DAILY'},
    ];

    List<Investment> investments = [];

    for (var asset in assets) {
      final String url =
          // asset['type'] == 'Stock'
          //     ?
          'https://twelvedata.com/time_series?symbol=${asset['symbol']}&apikey=$apiKey';
      // : 'https://www.alphavantage.co/query?function=${asset['endpoint']}&symbol=${asset['symbol']}&market=USD&apikey=$apiKey';

      try {
        final response = await dio.get(url);
        if (response.statusCode == 200) {
          final data = response.data;

          // Check for API errors
          if (data.containsKey('Error Message')) {
            throw Exception(
              'API Error for ${asset['symbol']}: ${data['Error Message']}',
            );
          }
          if (data.containsKey('Information')) {
            throw Exception(
              'API Info for ${asset['symbol']}: ${data['Information']}',
            );
          }
          if (data.containsKey('Note')) {
            throw Exception('API Note for ${asset['symbol']}: ${data['Note']}');
          }

          // Extract time series data
          final timeSeriesKey = asset['type'] == 'Stock'
              ? 'Time Series (Daily)'
              : 'Time Series (Digital Currency Daily)';
          final timeSeries = data[timeSeriesKey];

          if (timeSeries == null || timeSeries is! Map) {
            throw Exception('No valid time series data for ${asset['symbol']}');
          }

          // Collect last 10 days of data
          final dates = timeSeries.keys.take(7).toList();
          if (dates.isEmpty) {
            throw Exception('No date data available for ${asset['symbol']}');
          }

          List<double> historicalPrices = [];
          List<String> historicalDates = [];
          for (var date in dates) {
            final priceKey = asset['type'] == 'Stock'
                ? '4. close'
                : '4b. close (USD)';
            final priceStr = timeSeries[date][priceKey];
            if (priceStr == null) {
              throw Exception('No price data for ${asset['symbol']} on $date');
            }
            try {
              historicalPrices.add(double.parse(priceStr));
              historicalDates.add(date);
            } catch (e) {
              throw Exception(
                'Invalid price format for ${asset['symbol']}: $priceStr',
              );
            }
          }

          // Latest price and date
          final latestDate = dates.firstOrNull;
          final priceKey = asset['type'] == 'Stock'
              ? '4. close'
              : '4b. close (USD)';
          final latestPrice = double.parse(timeSeries[latestDate][priceKey]);
          final lastUpdated = DateTime.parse(latestDate);

          investments.add(
            Investment(
              id: asset['symbol']!,
              name: asset['symbol']!,
              latestPrice: latestPrice,
              type: asset['type']!,
              lastUpdated: lastUpdated,
              historicalPrices: historicalPrices.reversed.toList(),
              // Reverse for chronological order
              historicalDates: historicalDates.reversed.toList(),
            ),
          );
        } else {
          throw Exception('HTTP ${response.statusCode} for ${asset['symbol']}');
        }
      } catch (e) {
        print('Error fetching ${asset['symbol']}: $e');
        continue; // Skip failed asset
      }
      // Avoid rate limit (5 calls/min)
      await Future.delayed(Duration(seconds: 12));
    }

    if (investments.isEmpty) {
      throw Exception('No investments could be fetched');
    }
    print("GGGGGGGGGGGGGGGg $investments");

    list = investments;
    loading = false;
    if (mounted) setState(() {});
    // return investments;
  }
}

class Investment {
  final String id;
  final String name;
  final double latestPrice;
  final String type;
  final DateTime lastUpdated;
  final List<double> historicalPrices;
  final List<String> historicalDates;

  Investment({
    required this.id,
    required this.name,
    required this.latestPrice,
    required this.type,
    required this.lastUpdated,
    required this.historicalPrices,
    required this.historicalDates,
  });
}
