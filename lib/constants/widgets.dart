

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stock_market/constants/app_colors.dart';

showProgressIndicator(BuildContext context){
  showGeneralDialog(
    context: context, pageBuilder: (context, animation, secondaryAnimation) {
    return Center(
      child: SizedBox(
        height: 80,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white
              ),
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Row(
                  children: [

                    SizedBox(
                      height: 32,
                      width: 32,
                      child: CircularProgressIndicator(
                        color: ksecondary,

                      ),
                    ),
                    SizedBox(width: 12,),
                    Text("Loading...",style: GoogleFonts.rubik(
                        color: Colors.black54,fontSize: 16
                    ),),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  },);
}

