class StockDataModel {
  final String symbol;
  final String name;
  final double price;
  final double change;
  final double changePercent;
  final String marketState;

  StockDataModel({
    required this.symbol,
    required this.name,
    required this.price,
    required this.change,
    required this.changePercent,
    required this.marketState,
  });

  factory StockDataModel.fromJson(Map<String, dynamic> json) {
    return StockDataModel(
      symbol: json['symbol'] ?? '',
      name: json['shortName'] ?? json['longName'] ?? '',
      price: (json['regularMarketPrice'] ?? 0).toDouble(),
      change: (json['regularMarketChange'] ?? 0).toDouble(),
      changePercent: (json['regularMarketChangePercent'] ?? 0).toDouble(),
      marketState: json['marketState'] ?? '',
    );
  }
}
