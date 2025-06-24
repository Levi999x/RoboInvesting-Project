import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:stock_market/main_screen/news/widgets/news_widget.dart';
import 'package:xml/xml.dart';

import '../../constants/app_colors.dart';
import 'news_webview.dart';

class NewsScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=>_newsScreen();

}
class _newsScreen extends State<NewsScreen>{

  @override
  void initState() {
    getNews();
    super.initState();
  }

  List news = [];
  List filtered = [];
  String selected = "all";
  List ii = ["all","latest News"];
  @override
  Widget build(BuildContext context) {
    Map item = news.isNotEmpty?news.first:{};
     return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24,vertical: 18),
              child: Row(
                children: [
                  Text("News"
                    ,style: GoogleFonts.poppins(fontSize: 26,
                        color: Colors.black,fontWeight: FontWeight.w900),),
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
                    children: List.generate(ii.length, (index) {
                      return InkWell(
                        onTap: () {
                          selected = ii.elementAt(index);
                          setState(() {});
                          if(ii.elementAt(index)=="all"){
                            filtered = List.of(news);
                          }else{
                            setState(() {
                              filtered = news.sublist(news.length-4,news.length-1);
                            });
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(45),
                            color: selected == ii.elementAt(index)?ksecondary:Colors.transparent,
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 12,vertical: 6),
                          child: Text(ii.elementAt(index),style: GoogleFonts.poppins(
                              fontSize: 16,fontWeight: FontWeight.w500,color: selected == ii.elementAt(index)?Colors.white:Colors.black
                          ),),
                        ),
                      );
                    },),
                  ),
                ),
              ),
            ),
            if(item.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    final url = item['link'];
                    Navigator.push(context, MaterialPageRoute(builder: (context) => NewsWebview(url: url,),));
                  },
                  child: Card(
                    margin: EdgeInsets.all(8),
                    child: ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (item['imageUrl']!.isNotEmpty)
                            Image.network(item['imageUrl']!,height: 200,width: double.infinity, fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 200,
                                  color: Colors.grey.withAlpha(50),
                                );
                              },),
                          SizedBox(width: 12,),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
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
                ),
              ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children:List.generate(filtered.length, (index) {
                        return NewsWidget(item: filtered.elementAt(index));
                      },)
                    ),
                  ),
                ),

          ],
        ),
      ),
    );
  }

  void getNews()async {
    final dio = Dio();
    final response = await dio.get('https://www.investing.com/rss/news_25.rss');

    final document = XmlDocument.parse(response.data);

    final items = document.findAllElements('item');
    final newsList = items.map((item) {
      print("EEEEEEEEEEEEEEEEEEE $item");
      final description = item.getElement('description')?.text ?? '';

      final imageRegex = RegExp(r'<enclosure url="(.*?)"', caseSensitive: false);
      final imageMatch = imageRegex.firstMatch(item.toString());
      final imageUrl = imageMatch != null ? imageMatch.group(1) : null;

      return {
        'title': item.getElement('title')?.text ?? '',
        'link': item.getElement('link')?.text ?? '',
        'description': description,
        'pubDate': item.getElement('pubDate')?.text ?? '',
        'imageUrl': imageUrl ?? '',
      };
    }).toList();

    if(mounted){
      setState(() {
        news = newsList;
        filtered = List.of(newsList);
      });
    }
    // return ;
  }

}