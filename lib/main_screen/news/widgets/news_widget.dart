import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../news_webview.dart';

class NewsWidget extends StatelessWidget {
  Map item;

  NewsWidget({required this.item});

  @override
  Widget build(BuildContext context) {
    print("FFFFFFFFFFFFFFFf $item");
    return InkWell(
      onTap: () {
        final url = item['link'];
        Navigator.push(context, MaterialPageRoute(builder: (context) => NewsWebview(url: url,),));
      },
      child: Card(
        margin: EdgeInsets.all(8),
        child: ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (item['imageUrl']!.isNotEmpty)
                Image.network(item['imageUrl']!,height: 120,width: 120, fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 120,
                    color: Colors.grey.withAlpha(50),
                  );
                },),
              SizedBox(width: 12,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['title'] ?? '',style: GoogleFonts.alata(
                        fontWeight: FontWeight.w600,fontSize: 16
                    ),),
                    Text(item['pubDate'] ?? '')
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
