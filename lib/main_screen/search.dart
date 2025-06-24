import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:stock_market/constants/app_colors.dart';

import '../../models/stock_data_model.dart';

class Search extends StatefulWidget {
  List myList;
  Search({required this.myList});
  @override
  State<StatefulWidget> createState() => _search();
}

class _search extends State<Search> {


  List searchList = [];

  @override
  void initState() {
    if(mounted){
      setState(() {
        searchList = componies;
      });
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              child: Row(
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.arrow_back,size: 29,),
                      )),
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        search(value);
                      },
                      decoration: InputDecoration(
                        fillColor: Colors.grey.withAlpha(40),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none
                        ),
                        filled: true,
                        hint: Text("Search"),
                        prefixIcon: Icon(Icons.search)
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("All Investments", style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                    ),),
                    Column(
                      children: List.generate(searchList.length, (index) {
                        Map e = searchList.elementAt(index);
                        print("TTTTTTTTTTTTYYYYYYYY ${widget.myList} pppp $e");
                       List t = widget.myList.where((element) => element["title"]==e["title"],).toList();
                        return t.isNotEmpty?SizedBox():InkWell(
                          onTap: () async {
                           await FirebaseDatabase.instance.ref("favourites")
                                .child(FirebaseAuth.instance.currentUser!.uid.toString())
                                .child(e["title"]).set(e);
                           Navigator.pop(context);
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
                                  child: Text(e["title"],style: GoogleFonts.poppins(
                                      fontSize: 15,color: Colors.black,fontWeight: FontWeight.bold
                                  ),),
                                ),
                                Column(
                                  children: [
                                    Text(e["price"].toString()+"\$",style: GoogleFonts.poppins(
                                        fontSize: 15,color: Colors.black,fontWeight: FontWeight.bold
                                    ),),
                                    Text(e["effect"].toString()+"%",style: GoogleFonts.poppins(
                                        fontSize: 15,color: e["effect"]>0?Colors.green:Colors.red,fontWeight: FontWeight.bold
                                    ),),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },),
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

  search(String value){
    searchList = [];
    setState(() {
    });
    for(Map c in componies){
      if(c["title"].toString().toLowerCase().contains(value.toLowerCase())){
        setState(() {
          searchList.add(c);
        });
      }
    }
  }

}


