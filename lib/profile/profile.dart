import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stock_market/constants/app_colors.dart';
import '../../auth/login.dart';

class Profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
    super.initState();
  }

  Map<String, dynamic> getRiskProfile(int score) {
    if (score <= 75) {
      return {
        "label": "Defensive",
        "gold": 60.0,
        "stocks": 35.0,
        "crypto": 5.0,
      };
    } else if (score <= 110) {
      return {
        "label": "Conservative",
        "gold": 40.0,
        "stocks": 55.0,
        "crypto": 5.0,
      };
    } else if (score <= 145) {
      return {
        "label": "Balanced",
        "gold": 30.0,
        "stocks": 50.0,
        "crypto": 20.0,
      };
    } else if (score <= 180) {
      return {
        "label": "Growth",
        "gold": 15.0,
        "stocks": 55.0,
        "crypto": 30.0,
      };
    } else {
      return {
        "label": "Speculative",
        "gold": 5.0,
        "stocks": 40.0,
        "crypto": 55.0,
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    bool active = myData["active"] ?? false;
    int score = myData["score"] != null ? int.tryParse(myData["score"].toString()) ?? 0 : 0;
    String riskLabel = myData["riskLabel"]?.toString() ?? "";
    Map profile = getRiskProfile(score);

    String usedRiskLabel = riskLabel.isNotEmpty ? riskLabel : profile["label"];
    double goldPercent = profile["gold"] ?? 33;
    double stocksPercent = profile["stocks"] ?? 33;
    double cryptoPercent = profile["crypto"] ?? 33;

    List<PieChartSectionData> sections = [
      PieChartSectionData(
        value: stocksPercent,
        color: Colors.blue,
        title: 'Stocks\n${stocksPercent.toInt()}%',
        radius: 70,
        titleStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        titlePositionPercentageOffset: 0.55,
      ),
      PieChartSectionData(
        value: goldPercent,
        color: Colors.green,
        title: 'Gold\n${goldPercent.toInt()}%',
        radius: 70,
        titleStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        titlePositionPercentageOffset: 0.55,
      ),
      PieChartSectionData(
        value: cryptoPercent,
        color: Colors.orange,
        title: 'Crypto\n${cryptoPercent.toInt()}%',
        radius: 70,
        titleStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        titlePositionPercentageOffset: 0.55,
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Container(
            color: Colors.grey.withOpacity(0.2),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            child: SafeArea(
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Profile",
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 18),
                  Row(
                    children: [
                      myData["image"]?.toString().isNotEmpty == true
                          ? ClipOval(
                        child: Image.network(
                          myData["image"].toString(),
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                      )
                          : CircleAvatar(
                        radius: 34,
                        backgroundColor: Colors.grey,
                        child: Icon(
                          Icons.person,
                          size: 22,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              myData["name"] ?? "",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              myData["email"] ?? "",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            if (usedRiskLabel.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  "Risk Profile: $usedRiskLabel",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: ksecondary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          await FirebaseAuth.instance.signOut();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => Login()),
                                (route) => false,
                          );
                        },
                        child: Icon(Icons.logout, size: 24, color: Colors.red),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // PieChart with risk label in the center
                  SizedBox(
                    height: 350,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        PieChart(
                          PieChartData(
                            centerSpaceRadius: 60,
                            sections: sections,
                            startDegreeOffset: 0,
                          ),
                          duration: Duration(milliseconds: 200),
                          curve: Curves.linear,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              usedRiskLabel,
                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Profile',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  // Legend
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _legendDot(Colors.blue, 'Stocks'),
                      SizedBox(width: 10),
                      _legendDot(Colors.green, 'Gold'),
                      SizedBox(width: 10),
                      _legendDot(Colors.orange, 'Crypto'),
                    ],
                  ),
                  // Highlight card
                  if (usedRiskLabel.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: ksecondary.withAlpha(35),
                          border: Border.all(color: ksecondary, width: 1.2),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 18),
                        child: Column(
                          children: [
                            Text(
                              "Your Risk Profile:",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17,
                                  color: Colors.black54),
                            ),
                            Text(
                              usedRiskLabel,
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 25,
                                  color: ksecondary),
                            ),
                          ],
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      "AI-Picked Stocks: Beyond Human Potential",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.aBeeZee(
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: GoogleFonts.aBeeZee(
                          fontSize: 18,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                        children: [
                          TextSpan(
                            text: "Turn overwhelming market complexity into crystal clear choices in seconds with ",
                          ),
                          TextSpan(
                            text: "RoboInvesting",
                            style: GoogleFonts.aBeeZee(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                            text: ".PRO",
                            style: GoogleFonts.aBeeZee(
                              color: Colors.orange,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 18),
                  if (active)
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: ksecondary.withAlpha(40),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "You are now experiencing a fully AI Powered Stock Analysis to get you the best plan only for you",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.aBeeZee(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: ksecondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // --- PREDICTION SUMMARY START ---
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.orange.withOpacity(0.3)),
                            ),
                            padding: EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("🔮 All predictions made successfully.", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.orange[900], fontSize: 16)),
                                SizedBox(height: 6),
                                Text("📅 Last Day (2025-06-21)", style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600)),
                                Text("🔚 Predicted Close (scaled): 1.061224"),
                                Text("💰 Predicted Close (real value): 5174.21 currency units"),
                                SizedBox(height: 10),
                                Text("📈 Last 7-Day Summary with \$1000 Investment:", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15)),
                                Divider(),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                      headingRowColor: MaterialStateProperty.all(Colors.orange.withOpacity(0.13)),
                                      columns: [
                                        DataColumn(label: Text("Date", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold))),
                                        DataColumn(label: Text("Predicted", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold))),
                                        DataColumn(label: Text("Actual", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold))),
                                        DataColumn(label: Text("Profit", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold))),
                                        DataColumn(label: Text("Action", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold))),
                                      ],
                                      rows: [
                                        _predictionRow("2025-06-15", "5153.28", "6049.38", "173.89", "Buy"),
                                        _predictionRow("2025-06-16", "5156.56", "6009.90", "165.59", "Buy"),
                                        _predictionRow("2025-06-17", "5161.11", "6000.56", "162.90", "Buy"),
                                        _predictionRow("2025-06-18", "5167.11", "6004.00", "162.40", "Buy"),
                                        _predictionRow("2025-06-19", "5170.90", "6012.15", "163.25", "Buy"),
                                        _predictionRow("2025-06-20", "5172.62", "5987.93", "158.21", "Buy"),
                                        _predictionRow("2025-06-21", "5174.21", "5999.67", "160.18", "Buy"),
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(),
                                Text("💸 Total Simulated Profit in last 7 days: 1146.42 currency units", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.green[700])),
                                Text("💸 Total Final Simulated Capital Profit (on \$1000): \$1146.42", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.green[700])),
                                SizedBox(height: 4),
                                Text("📉 Mean Absolute Error (MAE): 843.97", style: GoogleFonts.poppins(fontSize: 13)),
                                Text("📊 Mean Absolute Percentage Error (MAPE): 14.04%", style: GoogleFonts.poppins(fontSize: 13)),
                              ],
                            ),
                          ),
                        ),
                        // --- PREDICTION SUMMARY END ---
                      ],
                    ),
                  if (!active)
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Container(
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(45),
                                            color: Colors.grey.withAlpha(60),
                                          ),
                                          width: 50,
                                          height: 8,
                                        ),
                                        SizedBox(height: 18),
                                        // Promo text
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 12.0),
                                          child: Column(
                                            children: [
                                              Text(
                                                "You are one step away from a winning portfolio.",
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                "Get up to",
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.orange,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                "40% OFF",
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.w900,
                                                  color: Colors.orange,
                                                  letterSpacing: 1,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        _planTile(
                                          label: "1 Year",
                                          price: "2555 EGP",
                                          discount: "You are saving 300 EGP",
                                          onTap: () {
                                            Navigator.pop(context);
                                            showPaymentMethod("activate", context);
                                          },
                                          isRecommended: true,
                                        ),
                                        SizedBox(height: 12),
                                        _planTile(
                                          label: "6 Months",
                                          price: "1499 EGP",
                                          discount: "You are saving 100 EGP",
                                          onTap: () {
                                            Navigator.pop(context);
                                            showPaymentMethod("6month", context);
                                          },
                                        ),
                                        SizedBox(height: 12),
                                        _planTile(
                                          label: "1 Month",
                                          price: "299 EGP",
                                          discount: "No discount",
                                          onTap: () {
                                            Navigator.pop(context);
                                            showPaymentMethod("1month", context);
                                          },
                                        ),
                                        SizedBox(height: 24),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.orange,
                            ),
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.symmetric(horizontal: 18),
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Get AI Stock Picks Now",
                                style: GoogleFonts.aBeeZee(
                                  fontSize: 23,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // --- REVIEWS SECTION START ---
                        SizedBox(height: 26),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: _reviewsSection(context),
                        ),
                        // --- REVIEWS SECTION END ---
                      ],
                    ),
                  SizedBox(height: 18),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  DataRow _predictionRow(String date, String pred, String actual, String profit, String action) {
    return DataRow(cells: [
      DataCell(Text(date, style: GoogleFonts.poppins(fontSize: 12))),
      DataCell(Text(pred, style: GoogleFonts.poppins(fontSize: 12))),
      DataCell(Text(actual, style: GoogleFonts.poppins(fontSize: 12))),
      DataCell(Text(profit, style: GoogleFonts.poppins(fontSize: 12))),
      DataCell(Text(action, style: GoogleFonts.poppins(fontSize: 12, color: Colors.green[900], fontWeight: FontWeight.bold))),
    ]);
  }

  Widget _legendDot(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 4),
        Text(text, style: GoogleFonts.poppins(fontSize: 15))
      ],
    );
  }

  Widget _planTile({
    required String label,
    required String price,
    required String discount,
    required VoidCallback onTap,
    bool isRecommended = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isRecommended ? Colors.orange.withOpacity(0.13) : Colors.grey.withOpacity(0.10),
          border: isRecommended ? Border.all(color: Colors.orange, width: 1.5) : null,
        ),
        width: double.infinity,
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  price,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                SizedBox(width: 6),
                Text(
                  "/$label",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                ),
                if (isRecommended)
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    padding: EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "Best Value",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  )
              ],
            ),
            SizedBox(height: 3),
            Text(
              discount,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.green[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _reviewsSection(BuildContext context) {
    // Responsive, no overflow
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.emoji_events, color: Colors.orange, size: 32),
            SizedBox(width: 7),
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: "What members say about ",
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 19,
                        )),
                    TextSpan(
                        text: "RoboInvesting",
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 19,
                        )),
                    TextSpan(
                        text: ".Pro",
                        style: GoogleFonts.poppins(
                          color: Colors.orange,
                          fontWeight: FontWeight.w700,
                          fontSize: 19,
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 18),
        _reviewCard(
          avatar: "https://randomuser.me/api/portraits/men/1.jpg",
          name: "Marco Bellante ⭐⭐⭐⭐⭐",
          country: "ITALY",
          title: "Video Game Developer",
          review:
          "I love how it matched my risk level without overwhelming me!",
        ),
        SizedBox(height: 14),
        _reviewCard(
          avatar: "https://randomuser.me/api/portraits/women/44.jpg",
          name: "Julia Smith ⭐⭐⭐⭐⭐",
          country: "USA",
          title: "Finance Student",
          review:
          "Clear advice, accurate predictions — I feel confident investing now.",
        ),
        SizedBox(height: 14),
        _reviewCard(
          avatar: "https://randomuser.me/api/portraits/women/45.jpg",
          name: "Andrew Holland ⭐⭐⭐⭐⭐",
          country: "GERMANY",
          title: "Computer Engineer",
          review:
          "It kept me safe but still gave me growth options. Perfect balance.",
        ),
      ],
    );
  }

  Widget _reviewCard({
    required String avatar,
    required String name,
    required String country,
    required String title,
    required String review,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.orange.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.07),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "\"$review\"",
            style: GoogleFonts.poppins(
                fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black87),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(avatar),
                radius: 18,
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  Text(
                    "$title | $country",
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  showPaymentMethod(String act, BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
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
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(45),
                        color: Colors.grey.withAlpha(60),
                      ),
                      width: 50,
                      height: 8,
                    ),
                    SizedBox(height: 18),
                    Text(
                      "Need to Pay",
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      act == "activate"
                          ? "2555 \$"
                          : act == "6month"
                          ? "1499 \$"
                          : "299 \$",
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Colors.orange,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Your Wallet",
                        style: GoogleFonts.aBeeZee(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: ksecondary.withAlpha(30),
                      ),
                      width: double.infinity,
                      padding: EdgeInsets.all(12),
                      child: Text(
                        double.parse(myData["balance"].toString())
                            .toStringAsFixed(2)
                            .toString() +
                            " \$",
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: ksecondary,
                        ),
                      ),
                    ),
                    if (myData["balance"] <
                        (act == "activate"
                            ? 2555
                            : act == "6month"
                            ? 1499
                            : 299))
                      Text(
                        "You do not have enough balance",
                        style: GoogleFonts.aBeeZee(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    SizedBox(height: 24),
                    InkWell(
                      onTap: () async {
                        double price = act == "activate"
                            ? 2555
                            : act == "6month"
                            ? 1499
                            : 299;
                        if (myData["balance"] >= price) {
                          await FirebaseDatabase.instance
                              .ref("users")
                              .child(FirebaseAuth.instance.currentUser!.uid.toString())
                              .child("active")
                              .set(true);
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
                        child: Text(
                          "Confirm",
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
