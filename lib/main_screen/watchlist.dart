import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:stock_market/constants/app_colors.dart';
import 'package:stock_market/main_screen/search.dart';

import '../../models/stock_data_model.dart';

class Watchlist extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _watchlist();
}

class _watchlist extends State<Watchlist> {
  final Dio dio = Dio()..interceptors.add(LogInterceptor(responseBody: true));

  Map myList = {};
  List filteredList = [];
  String selected = "all";
  Map myData = {};
  @override
  void initState() {
    FirebaseDatabase.instance.ref("users").child(FirebaseAuth.instance.currentUser!.uid.toString())
        .onValue.listen((event) {
      if(event.snapshot.exists){
        if(mounted)
          setState(() {
            myData = event.snapshot.value as Map;
          });
      }
    },);
    FirebaseDatabase.instance.ref("favourites")
        .child(FirebaseAuth.instance.currentUser!.uid.toString()).onValue.listen((event) {
      if(event.snapshot.exists){
        myList = event.snapshot.value as Map;
        if(mounted){
          setState(() {});
        }
      }else{
        myList = {};
        if(mounted){
          setState(() {});
        }
      }
    },);
    super.initState();
    setState(() {
      filteredList = List.of(componies);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => Search(myList: myList.values.toList(),),));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: ksecondary
          ),
          padding: EdgeInsets.all(12),
          child: Text("Add",style: GoogleFonts.poppins(
            fontSize: 16,color: Colors.white,fontWeight: FontWeight.w500
          ),),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              child: Row(
                children: [
                  Text(
                    "Watchlist",
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
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0,vertical: 8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(stockTypes.length, (index) {
                      return InkWell(
                        onTap: () {
                          selected = stockTypes.elementAt(index);
                          setState(() {});
                          if(stockTypes.elementAt(index)=="all"){
                            filteredList = List.of(componies);
                          }else{
                            setState(() {
                              filteredList = [];
                            });
                            for(Map i in componies){
                              if(i["type"]==selected){
                                setState(() {
                                  filteredList.add(i);
                                });
                              }
                            }
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(45),
                            color: selected == stockTypes.elementAt(index)?ksecondary:Colors.transparent,
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 12,vertical: 6),
                          child: Text(stockTypes.elementAt(index),style: GoogleFonts.poppins(
                            fontSize: 16,fontWeight: FontWeight.w500,color: selected == stockTypes.elementAt(index)?Colors.white:Colors.black
                          ),),
                        ),
                      );
                    },),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if(myList.isNotEmpty)
                    Text("My Watchlist", style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                    ),),
                    Column(
                      children: List.generate(myList.length, (index) {
                        Map e = myList.values.elementAt(index);
                        return InkWell(
                          onLongPress: () {
                            FirebaseDatabase.instance.ref("favourites")
                                .child(FirebaseAuth.instance.currentUser!.uid.toString()).child(e["title"]).remove();
                          },
                          onTap: () {
                            showPaymentWidget(e["price"], context, e, myData["balance"]);
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
                    SizedBox(height: 22,),
                    Text("All Investments", style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                    ),),
                    Column(
                      children: List.generate(filteredList.length, (index) {
                        Map e = filteredList.elementAt(index);
                        return InkWell(
                          onTap: () {
                            showPaymentWidget(e["price"], context, e, myData["balance"]);
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
}
showPaymentWidget(double price,BuildContext context,Map item,double myBalance){
  showBottomSheet(context: context, builder:
      (context) {
    int selected = 0;
    TextEditingController amountCon = TextEditingController(text: "1");
    int count = 1;
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(45),
                      color: Colors.grey.withAlpha(60),),
                    width: 50,
                    height: 8,
                  ),
                  SizedBox(height: 18,),
                  Row(
                    children: [
                      Expanded(
                        child: Text(item["title"],style: GoogleFonts.poppins(
                            fontSize: 15,color: Colors.black,fontWeight: FontWeight.bold
                        ),),
                      ),
                      Column(
                        children: [
                          Text(item["price"].toString()+"\$",style: GoogleFonts.poppins(
                              fontSize: 15,color: Colors.black,fontWeight: FontWeight.bold
                          ),),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 18,),
                  Text("Enter Share amount",style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,color: Colors.black
                  ),),
                  SizedBox(height: 2,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextField(
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 24,fontWeight: FontWeight.bold,),
                      controller: amountCon,
                      keyboardType: TextInputType.numberWithOptions(),
                      onChanged: (value) {

                        setState((){
                          count = value.isEmpty?0: int.parse(value);
                        });
                      },

                      decoration: InputDecoration(
                          hintText: "Share amount ",
                          hintStyle: GoogleFonts.rubik(
                              color: kHint,
                              fontWeight: FontWeight.w300,
                              fontSize: 16),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 12),
                          // suffixIcon: Icon(Icons.check,color: AppColors.purple,size: 22,),
                          fillColor: kFieldFill,
                          filled: true,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none)
                      ),
                    ),
                  ),
                  SizedBox(height: 24,),
                  SizedBox(height: 2,),
                  Text("${(count*price).toStringAsFixed(3)} \$",style: GoogleFonts.poppins(
                      fontSize: 28,fontWeight: FontWeight.w900,color: ksecondary
                  ),),
                  SizedBox(height: 24,),
                  InkWell(
                    onTap: () async {
                      if(myBalance>=(count*price)){
                        await FirebaseDatabase.instance.ref("history")
                            .child(FirebaseAuth.instance.currentUser
                        !.uid.toString()).push()
                            .set({
                          "title":item["title"],
                          "price":item["price"],
                          "amount":count,
                          "total":(count*price).toStringAsFixed(3),
                          "time":DateTime.now().microsecondsSinceEpoch
                        });
                        await FirebaseDatabase.instance.ref("users")
                            .child(FirebaseAuth.instance.currentUser
                        !.uid.toString()).child("balance").set(myBalance-
                        double.parse((count*price).toStringAsFixed(3)));
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: ksecondary,
                      ),
                      width: double.infinity,
                      padding: EdgeInsets.all(12),
                      alignment: Alignment.center,
                      child: Text("Confirm",style: GoogleFonts.poppins(
                          fontSize: 24,fontWeight: FontWeight.w900,color:Colors.white
                      ),),
                    ),
                  ),
                  SizedBox(height: 24,),

                ],
              ),
            ),
          ),
        );
      },
    );
  },);
}
showSellingWidget(double price,BuildContext context,Map item,double myBalance, String id){
  showBottomSheet(context: context, builder:
      (context) {
    int selected = 0;
    TextEditingController amountCon = TextEditingController(text: "1");
    int count = 1;
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(45),
                      color: Colors.grey.withAlpha(60),),
                    width: 50,
                    height: 8,
                  ),
                  SizedBox(height: 18,),
                  Row(
                    children: [
                      Expanded(
                        child: Text(item["title"],style: GoogleFonts.poppins(
                            fontSize: 15,color: Colors.black,fontWeight: FontWeight.bold
                        ),),
                      ),
                      Column(
                        children: [
                          Text(item["price"].toString()+"\$",style: GoogleFonts.poppins(
                              fontSize: 15,color: Colors.black,fontWeight: FontWeight.bold
                          ),),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 18,),
                  Text("Enter Share amount",style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,color: Colors.black
                  ),),
                  SizedBox(height: 2,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextField(
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 24,fontWeight: FontWeight.bold,),
                      controller: amountCon,
                      keyboardType: TextInputType.numberWithOptions(),
                      onChanged: (value) {

                        int t = value.isEmpty?0:int.parse(value);
                        if(t<=item["amount"]){
                          setState((){
                            count =t ;
                          });
                        }else{
                          amountCon.text = item["amount"].toString();
                          setState((){
                            count =item["amount"] ;
                          });
                        }
                      },

                      decoration: InputDecoration(
                          hintText: "Share amount ",
                          hintStyle: GoogleFonts.rubik(
                              color: kHint,
                              fontWeight: FontWeight.w300,
                              fontSize: 16),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 12),
                          // suffixIcon: Icon(Icons.check,color: AppColors.purple,size: 22,),
                          fillColor: kFieldFill,
                          filled: true,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none)
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("You have ${item["amount"]}",style: GoogleFonts.aBeeZee(
                        fontSize: 20,fontWeight: FontWeight.w900,color: Colors.black54
                    ),),
                  ),
                  SizedBox(height: 24,),
                  SizedBox(height: 2,),
                  Text("${(count*price).toStringAsFixed(3)} \$",style: GoogleFonts.poppins(
                      fontSize: 28,fontWeight: FontWeight.w900,color: ksecondary
                  ),),
                  SizedBox(height: 24,),
                  InkWell(
                    onTap: () async {
                      // if(myBalance>=(count*price)){
                        if(item["amount"]==count){
                          await FirebaseDatabase.instance.ref("history")
                              .child(FirebaseAuth.instance.currentUser
                          !.uid.toString()).child(id).remove();
                        }else{
                          await FirebaseDatabase.instance.ref("history")
                              .child(FirebaseAuth.instance.currentUser
                          !.uid.toString()).child(id).child("amount").set(item["amount"]-count);
                        }
                        await FirebaseDatabase.instance.ref("users")
                            .child(FirebaseAuth.instance.currentUser
                        !.uid.toString()).child("balance").set(myBalance+
                        double.parse((count*price).toStringAsFixed(3)));
                        Navigator.pop(context);
                      // }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: ksecondary,
                      ),
                      width: double.infinity,
                      padding: EdgeInsets.all(12),
                      alignment: Alignment.center,
                      child: Text("Confirm",style: GoogleFonts.poppins(
                          fontSize: 24,fontWeight: FontWeight.w900,color:Colors.white
                      ),),
                    ),
                  ),
                  SizedBox(height: 24,),

                ],
              ),
            ),
          ),
        );
      },
    );
  },);
}



