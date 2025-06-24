import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stock_market/main_screen/watchlist.dart';

import '../constants/app_colors.dart';

class WalletScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() =>_walletScreen();
}

class _walletScreen extends State<WalletScreen>{

  Map myData = {};
  Map history = {};
  @override
  void initState() {
    FirebaseDatabase.instance.ref("history")
        .child(FirebaseAuth.instance.currentUser!.uid.toString())
        .onValue.listen((event) {
      if(event.snapshot.exists){
        if(mounted)
          setState(() {
            history = event.snapshot.value as Map;
          });
      }else{
        if(mounted){
          setState(() {
            history = {};
          });
        }
      }
    },);
    FirebaseDatabase.instance.ref("users").child(FirebaseAuth.instance.currentUser!.uid.toString())
        .onValue.listen((event) {
      if(event.snapshot.exists){
        if(mounted)
          setState(() {
            myData = event.snapshot.value as Map;
          });
      }
    },);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double myBalance = myData["balance"]??0.00;
    return Scaffold(
      body: SafeArea(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text("Wallet",style: GoogleFonts.dancingScript(
              fontSize: 28,color: Colors.black,fontWeight: FontWeight.w900
            ),),
          ),
          SizedBox(height: 8,),
          Expanded(child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Your Total Value",style: GoogleFonts.aBeeZee(
                  fontSize: 18,color: Colors.black54,fontWeight: FontWeight.w800
                ),),
                SizedBox(height: 8,),
                Text(myBalance.toStringAsFixed(4).toString()+"\$",style: GoogleFonts.dancingScript(
                  fontSize: 30,color: Colors.black,fontWeight: FontWeight.w900
                ),),
                SizedBox(height: 12,),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        showTopUpWidget();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 24),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: ksecondary),
                        child: Text(
                          "Deposit",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.dancingScript(
                              fontWeight: FontWeight.w900,
                              fontSize: 24,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(width: 12,),
                    InkWell(
                      onTap: () {
                        showWithdrawWidget();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 24),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: ksecondary),
                        child: Text(
                          "Withdraw",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.dancingScript(
                              fontWeight: FontWeight.w900,
                              fontSize: 24,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24,),
                Text(
                  "Transactions",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.dancingScript(
                      fontWeight: FontWeight.w900,
                      fontSize: 24,
                      color: Colors.black),
                ),
                Column(
                  children: List.generate(history.length, (index) {
                    Map e = history.values.elementAt(index);
                    return InkWell(
                      onTap: () {
                        print("DDDDDDDDDDDDDDDDddd");
                        showSellingWidget(e["price"], context, e, myBalance, history.keys.elementAt(index));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey.withAlpha(40),
                        ),
                        padding: EdgeInsets.all(12),
                        margin: EdgeInsets.symmetric(vertical: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(e["title"],style: GoogleFonts.poppins(
                                      fontSize: 17,color: Colors.black,fontWeight: FontWeight.bold
                                  ),),
                                ),
                                Column(
                                  children: [
                                    Text(e["price"].toString()+"\$",style: GoogleFonts.poppins(
                                        fontSize: 15,color: Colors.black54,fontWeight: FontWeight.bold
                                    ),),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 6,),
                            Row(
                              children: [
                                Expanded(
                                  child: Text("amount: ${e["amount"]} ",style: GoogleFonts.poppins(
                                      fontSize: 16,color: Colors.black,fontWeight: FontWeight.w500
                                  ),),
                                ),
                                Text("total: "+e["total"].toString()+" \$",style: GoogleFonts.poppins(
                                    fontSize: 16,color: Colors.red,fontWeight: FontWeight.bold
                                ),),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },),
                )
              ],
            ),
          )),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: InkWell(
                onTap: () {
                  showTransferWidget();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 24),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: ksecondary),
                  child: Text(
                    "Transfer",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.dancingScript(
                        fontWeight: FontWeight.w900,
                        fontSize: 24,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }

  showTopUpWidget(){
    showBottomSheet(context: context, builder:
        (context) {
      List options = ["Paypal","Credit/Debit cards","Mobile Wallet"];
      TextEditingController amountCon = TextEditingController();
      int selected = 0;
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
                    Text("Enter amount",style: GoogleFonts.dancingScript(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,color: Colors.black
                    ),),
                    SizedBox(height: 2,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        style: const TextStyle(fontSize: 18),
                        controller: amountCon,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            hintText: "5000 EGP ",
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
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text("Payment options",style: GoogleFonts.poppins(
                          fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black54
                      ),),
                    ),
                    SizedBox(height: 8,),
                    Column(
                      children: List.generate(options.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState((){
                                    selected = index;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: selected != index?
                                    Colors.grey.withAlpha(30):ksecondary.withAlpha(30),
                                  ),
                                  width: double.infinity,
                                  padding: EdgeInsets.all(12),
                                  child: options.elementAt(index)=="Paypal"?
                                      Image.asset("assets/images/paypal.png",height: 54,)
                                      :Text(options.elementAt(index),style: GoogleFonts.dancingScript(
                                      fontSize: 24,fontWeight: FontWeight.w900,color:selected == index?
                                  ksecondary:Colors.black
                                  ),),
                                ),
                              ),
                              if(selected==1&&index==1)
                              cardWidget(),

                              if(selected==2&&index==2)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 12,),

                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: TextField(
                                      style: const TextStyle(fontSize: 18),
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                          hintText: "Phone number ",
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
                                ],
                              ),
                            ],
                          ),
                        );
                      },),
                    ),
                    SizedBox(height: 24,),
                    InkWell(
                      onTap: () async {
                        String v = amountCon.text.trim().toString();
                        double b = double.parse(v);
                        double myBalance = myData["balance"]??0.01;
                        if(v.isNotEmpty){
                          await FirebaseDatabase.instance.ref("users")
                              .child(FirebaseAuth.instance.currentUser
                          !.uid.toString()).child("balance")
                              .set(double.parse(myBalance.toStringAsFixed(2))+b);
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
                        child: Text("Confirm",style: GoogleFonts.dancingScript(
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
  showWithdrawWidget(){
    showBottomSheet(context: context, builder:
        (context) {
      List options = ["Paypal","Bank Account","Mobile Wallet"];
      TextEditingController amountCon = TextEditingController();
      int selected = 0;
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
                    Text("Enter amount",style: GoogleFonts.dancingScript(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,color: Colors.black
                    ),),
                    SizedBox(height: 2,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        style: const TextStyle(fontSize: 18),
                        controller: amountCon,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            hintText: "5000 EGP ",
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
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text("Payment options",style: GoogleFonts.poppins(
                          fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black54
                      ),),
                    ),
                    SizedBox(height: 8,),
                    Column(
                      children: List.generate(options.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState((){
                                    selected = index;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: selected != index?
                                    Colors.grey.withAlpha(30):ksecondary.withAlpha(30),
                                  ),
                                  width: double.infinity,
                                  padding: EdgeInsets.all(12),
                                  child: options.elementAt(index)=="Paypal"?
                                      Image.asset("assets/images/paypal.png",height: 54,)
                                      :Text(options.elementAt(index),style: GoogleFonts.dancingScript(
                                      fontSize: 24,fontWeight: FontWeight.w900,color:selected == index?
                                  ksecondary:Colors.black
                                  ),),
                                ),
                              ),
                              if(selected==1&&index==1)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 12,),

                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: TextField(
                                        style: const TextStyle(fontSize: 18),
                                        keyboardType: TextInputType.phone,
                                        decoration: InputDecoration(
                                            hintText: "IBAN ",
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
                                  ],
                                ),

                              if(selected==2&&index==2)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 12,),

                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: TextField(
                                      style: const TextStyle(fontSize: 18),
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                          hintText: "Phone number ",
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
                                ],
                              ),
                            ],
                          ),
                        );
                      },),
                    ),
                    SizedBox(height: 24,),
                    InkWell(
                      onTap: () async {
                        String v = amountCon.text.trim().toString();
                        double b = double.parse(v);
                        double myBalance = myData["balance"]??0.01;
                        if(b<=myBalance){
                          await FirebaseDatabase.instance.ref("users")
                              .child(FirebaseAuth.instance.currentUser
                          !.uid.toString()).child("balance")
                              .set(double.parse(myBalance.toStringAsFixed(2))-b);
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
                        child: Text("Confirm",style: GoogleFonts.dancingScript(
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
  showTransferWidget(){
    showBottomSheet(context: context, builder:
        (context) {
      TextEditingController amountCon = TextEditingController();
      TextEditingController userId = TextEditingController();
      int selected = 0;
      return StatefulBuilder(
        builder: (BuildContext context, void Function(void Function()) setState) {
          return Container(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
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
                  SizedBox(height: 2,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextField(
                      style: const TextStyle(fontSize: 18),
                      controller: userId,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          hintText: "User id ",
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
                  Text("Enter amount",style: GoogleFonts.dancingScript(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,color: Colors.black
                  ),),
                  SizedBox(height: 2,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextField(
                      style: const TextStyle(fontSize: 18),
                      controller: amountCon,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          hintText: "5000 EGP ",
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
                  InkWell(
                    onTap: () async {
                      String v = amountCon.text.trim().toString();
                      double b = double.parse(v);
                      double myBalance = myData["balance"]??0.01;
                      if(b<=myBalance&&b>=1&&userId.text.trim().toString().isNotEmpty){
                        await FirebaseDatabase.instance.ref("users")
                            .child(FirebaseAuth.instance.currentUser
                        !.uid.toString()).child("balance").set(myBalance-b);
                        Navigator.pop(context);
                      }else{
                        if(b>myBalance){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("You do not have enough money")));
                        }
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
                      child: Text("Confirm",style: GoogleFonts.aboreto(
                          fontSize: 24,fontWeight: FontWeight.w900,color:Colors.white
                      ),),
                    ),
                  ),
                  SizedBox(height: 24,),

                ],
              ),
            ),
          );
        },
      );
    },);
  }

  Widget cardWidget(){
    return Column(
      children: [
        SizedBox(height: 12,),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TextField(
            style: const TextStyle(fontSize: 18),
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
                hintText: "Card number ",
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
        SizedBox(height: 12,),
        Row(
          children: [
            Expanded(child:  Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                style: const TextStyle(fontSize: 18),
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    hintText: "MM/YY ",
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
            ),),
            SizedBox(width: 12,),
            Expanded(child:  Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                style: const TextStyle(fontSize: 18),
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    hintText: "CVV ",
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
            ),),

          ],
        ),
        SizedBox(height: 12,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TextField(
            style: const TextStyle(fontSize: 18),
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
                hintText: "Your Name ",
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
        SizedBox(height: 12,),
      ],
    );
  }

}