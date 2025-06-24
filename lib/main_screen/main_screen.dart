import 'package:flutter/material.dart';
import 'package:stock_market/constants/app_colors.dart';
import 'package:stock_market/main_screen/news/news_screen.dart';
import 'package:stock_market/main_screen/watchlist.dart';
import 'package:stock_market/profile/profile.dart';
import 'package:stock_market/wallet/wallet_screen.dart';

import 'home/home_screen.dart';

class MainScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() =>_mainScreen();

}
class _mainScreen extends State<MainScreen>{

  List items = [
    {"image":Icons.home,"title":"Home"},
    {"image":Icons.newspaper,"title":"News"},
    {"image":Icons.star,"title":"watchlist"},
    {"image":Icons.person,"title":"Profile"},
    {"image":Icons.wallet,"title":"Wallet"},
  ];
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomeScreen(),
          NewsScreen(),
          Watchlist(),
          Profile(),
          WalletScreen()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: ksecondary.withOpacity(0.4),
          selectedItemColor: ksecondary,
          onTap: (value) {
            setState(() {
              _selectedIndex = value;
            });
          },
          elevation: 4,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          currentIndex: _selectedIndex,
          items: List.generate(items.length, (index) {
        return BottomNavigationBarItem(icon: Icon(items.elementAt(index)["image"],
          size: 26,),
            label:
        items.elementAt(index)["title"]
        );
      },)),
    );
  }

}