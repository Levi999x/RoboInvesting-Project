import 'package:flutter/material.dart';

Color ksecondary = Colors.blue.shade600;
Color kHint = Colors.black45;
Color kFieldFill = Colors.grey.withOpacity(0.2);

final Map names = {
  'AAPL': {
    "name": "APPLE",
    "image": "https://cdn.iconscout.com/icon/free/png-256/free-apple-logo-icon-download-in-svg-png-gif-file-formats--70-flat-social-icons-color-pack-logos-432495.png?f=webp&w=256"
  },
  'MSFT': {
    "name": "MICROSOFT",
    "image": "https://pngimg.com/uploads/microsoft/microsoft_PNG13.png"
  },
  'TSLA': {
    "name": "TESLA",
    "image": "https://pngimg.com/uploads/tesla_logo/tesla_logo_PNG12.png"
  },
  'GOOG': {
    "name": "GOOGLE",
    "image": "https://static.vecteezy.com/system/resources/previews/022/613/027/non_2x/google-icon-logo-symbol-free-png.png"
  },
  'BTC': {
    "name": "BITCOIN",
    "image": "https://pngimg.com/uploads/bitcoin/bitcoin_PNG48.png"
  },
  'GOLD': {
    "name": "GOLD",
    "image": "https://cdn-icons-png.flaticon.com/512/235/235251.png"
  },
  'CL': {
    "name": "CRUDE OIL WTI",
    "image": "https://cdn-icons-png.flaticon.com/512/2081/2081871.png"
  },
  'LCO': {
    "name": "BRENT OIL",
    "image": "https://cdn-icons-png.flaticon.com/512/2081/2081871.png"
  },
  'NG': {
    "name": "NATURAL GAS",
    "image": "https://cdn-icons-png.flaticon.com/512/2081/2081859.png"
  },
  'DJI': {
    "name": "DOW JONES",
    "image": "https://static.vecteezy.com/system/resources/previews/025/198/067/non_2x/dow-jones-industrial-average-djia-index-icon-vector.jpg"
  },
  'USTECH': {
    "name": "US TECH 100",
    "image": "https://seeklogo.com/images/N/nasdaq-logo-6B66A3F92A-seeklogo.com.png"
  },
  'US30': {
    "name": "US 30",
    "image": "https://upload.wikimedia.org/wikipedia/commons/0/0a/New_York_Stock_Exchange_Logo.png"
  },
  'AMZN': {
    "name": "AMAZON",
    "image": "https://pngimg.com/uploads/amazon/amazon_PNG11.png"
  },
  'META': {
    "name": "META",
    "image": "https://upload.wikimedia.org/wikipedia/commons/0/05/Meta_Platforms_Inc._logo.svg"
  },
  'JPM': {
    "name": "JPMORGAN",
    "image": "https://logo.clearbit.com/jpmorganchase.com"
  },
  'NVDA': {
    "name": "NVIDIA",
    "image": "https://cdn-icons-png.flaticon.com/64/5968/5968703.png"
  },
  'ETH': {
    "name": "ETHEREUM",
    "image": "https://cryptologos.cc/logos/ethereum-eth-logo.png"
  },
  'NFLX': {
    "name": "NETFLIX",
    "image": "https://upload.wikimedia.org/wikipedia/commons/0/08/Netflix_2015_logo.svg"
  },
  'BA': {
    "name": "BOEING",
    "image": "https://pngimg.com/uploads/boeing/boeing_PNG28.png"
  },
  'VOD': {
    "name": "VODAFONE",
    "image": "https://upload.wikimedia.org/wikipedia/commons/5/5a/Vodafone_2017_logo.svg"
  },
};

List<String> stockTypes = [
  "all",
  "stock",
  "crypto",
  "metal",
  "index",
  "commodity",
];

List<Map<String, dynamic>> componies = [
  {
    "title": "Crude Oil WTI",
    "symbol": "CL",
    "type": "commodity",
    "price": 66.79,
    "effect": -1.72,
    "changePercent": -2.51,
    "time": "13:35:38",
    "info": "The primary oil benchmark for North America, WTI sets the standard for crude oil prices traded in US markets."
  },
  {
    "title": "Brent Oil",
    "symbol": "LCO",
    "type": "commodity",
    "price": 68.69,
    "effect": -1.83,
    "changePercent": -2.60,
    "time": "13:35:31",
    "info": "The world's leading global oil benchmark, Brent sets the price for most of the oil traded internationally, especially in Europe and Africa."
  },
  {
    "title": "Gold",
    "symbol": "GOLD",
    "type": "metal",
    "price": 3340.31,
    "effect": -54.69,
    "changePercent": -1.61,
    "time": "13:35:38",
    "info": "A timeless store of value, gold is considered a safe haven asset in times of economic uncertainty or inflation."
  },
  {
    "title": "Tesla",
    "symbol": "TSLA",
    "type": "stock",
    "price": 348.68,
    "effect": 26.52,
    "changePercent": 8.23,
    "time": "23/06",
    "info": "Tesla leads the global electric vehicle revolution, renowned for its innovation in EVs, solar, and battery technology. Headquartered in the USA."
  },
  {
    "title": "Apple",
    "symbol": "AAPL",
    "type": "stock",
    "price": 120.223,
    "effect": -22.55,
    "changePercent": -1.52,
    "time": "13:35:30",
    "info": "The world’s largest technology company, Apple designs iPhones, Macs, and digital services that shape modern life. Based in Cupertino, California."
  },
  {
    "title": "Google",
    "symbol": "GOOG",
    "type": "stock",
    "price": 333.223,
    "effect": -12.55,
    "changePercent": -3.62,
    "time": "13:35:30",
    "info": "The global leader in online search, advertising, and AI, Google (Alphabet) powers much of the internet’s infrastructure."
  },
  {
    "title": "Microsoft",
    "symbol": "MSFT",
    "type": "stock",
    "price": 20.223,
    "effect": -10.55,
    "changePercent": -0.33,
    "time": "13:35:30",
    "info": "A tech giant known for Windows, Office, and Azure cloud services, Microsoft drives enterprise software and global computing solutions."
  },
  {
    "title": "Amazon",
    "symbol": "AMZN",
    "type": "stock",
    "price": 188.66,
    "effect": 3.45,
    "changePercent": 1.87,
    "time": "13:35:20",
    "info": "The world’s largest online retailer and cloud computing provider, Amazon transformed global commerce and logistics."
  },
  {
    "title": "Meta Platforms",
    "symbol": "META",
    "type": "stock",
    "price": 273.42,
    "effect": 2.13,
    "changePercent": 0.78,
    "time": "13:35:19",
    "info": "Meta, formerly Facebook, is the leading force in social networking and virtual reality platforms, connecting billions of people worldwide."
  },
  {
    "title": "NVIDIA",
    "symbol": "NVDA",
    "type": "stock",
    "price": 422.22,
    "effect": 8.02,
    "changePercent": 1.93,
    "time": "13:35:33",
    "info": "NVIDIA dominates the GPU market, powering breakthroughs in AI, gaming, and data centers around the world."
  },
  {
    "title": "JPMorgan Chase",
    "symbol": "JPM",
    "type": "stock",
    "price": 143.20,
    "effect": 0.92,
    "changePercent": 0.65,
    "time": "13:35:29",
    "info": "America’s largest bank, JPMorgan Chase, plays a central role in global finance, investment, and banking services."
  },
  {
    "title": "Netflix",
    "symbol": "NFLX",
    "type": "stock",
    "price": 436.12,
    "effect": 6.24,
    "changePercent": 1.45,
    "time": "13:35:32",
    "info": "Netflix is the global pioneer of streaming entertainment, producing acclaimed original content for audiences worldwide."
  },
  {
    "title": "Boeing",
    "symbol": "BA",
    "type": "stock",
    "price": 203.46,
    "effect": -2.32,
    "changePercent": -1.13,
    "time": "13:35:34",
    "info": "Boeing is a top aerospace and defense company, manufacturing commercial jets, satellites, and military aircraft."
  },
  {
    "title": "Vodafone",
    "symbol": "VOD",
    "type": "stock",
    "price": 9.18,
    "effect": -0.13,
    "changePercent": -1.40,
    "time": "13:35:35",
    "info": "Vodafone Group is one of the world’s largest telecommunications providers, operating across Europe, Africa, and Asia."
  },
  {
    "title": "US 30",
    "symbol": "US30",
    "type": "index",
    "price": 42863.0,
    "effect": 281.2,
    "changePercent": 0.66,
    "time": "13:35:37",
    "info": "The Dow Jones Industrial Average tracks 30 leading US companies, reflecting the overall health of American industry."
  },
  {
    "title": "US Tech 100",
    "symbol": "USTECH",
    "type": "index",
    "price": 22067.0,
    "effect": 210.7,
    "changePercent": 0.96,
    "time": "13:35:39",
    "info": "The NASDAQ 100 index tracks the 100 largest US non-financial companies, with a focus on technology innovators."
  },
  {
    "title": "Dow Jones",
    "symbol": "DJI",
    "type": "index",
    "price": 42581.78,
    "effect": 374.96,
    "changePercent": 0.89,
    "time": "23/06",
    "info": "The Dow Jones is one of the oldest and most-watched stock indexes, representing the US blue-chip stock market."
  },
  {
    "title": "Bitcoin",
    "symbol": "BTC",
    "type": "crypto",
    "price": 105207.3,
    "effect": 3732.2,
    "changePercent": 3.68,
    "time": "13:35:36",
    "info": "Bitcoin is the original and most valuable cryptocurrency, known for its decentralized, borderless transactions."
  },
  {
    "title": "Ethereum",
    "symbol": "ETH",
    "type": "crypto",
    "price": 5918.34,
    "effect": 112.17,
    "changePercent": 1.93,
    "time": "13:35:37",
    "info": "Ethereum is a blockchain platform enabling smart contracts and decentralized apps, powering much of the DeFi ecosystem."
  },
  {
    "title": "Natural Gas",
    "symbol": "NG",
    "type": "commodity",
    "price": 3.754,
    "effect": -0.056,
    "changePercent": -1.47,
    "time": "13:35:22",
    "info": "Natural gas is a major energy source for electricity, heating, and industry, with prices influenced by global supply and demand."
  },
];

