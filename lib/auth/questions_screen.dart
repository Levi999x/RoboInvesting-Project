import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stock_market/constants/app_colors.dart';
import 'package:stock_market/main_screen/main_screen.dart';

class QuestionsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _questionsScreen();
}

class _questionsScreen extends State<QuestionsScreen> {
  int selected = -1;
  int totalScore = 0;

  List<Map> questions = [
    {
      'question': 'What is your main investment goal?',
      'options': [
        {'text': 'Preserve my savings with minimal risk', 'score': 5},
        {'text': 'Generate stable income with low fluctuations', 'score': 10},
        {'text': 'Achieve long-term growth while managing risk', 'score': 15},
        {'text': 'Grow my wealth over time with some volatility', 'score': 20},
        {'text': 'Pursue high returns, even if it means high risk', 'score': 25}
      ]
    },
    {
      'question': 'How would you react if your portfolio dropped 15% in a short period?',
      'options': [
        {'text': 'I would sell my investments to avoid further losses', 'score': 5},
        {'text': 'I would be concerned but wait to see what happens', 'score': 10},
        {'text': 'I would remain calm and stay invested', 'score': 15},
        {'text': 'I might consider adding more funds to take advantage of prices', 'score': 20},
        {'text': 'I would see it as a buying opportunity', 'score': 25}
      ]
    },
    {
      'question': "When do you expect to need the money you're investing?",
      'options': [
        {'text': 'Less than 1 year', 'score': 5},
        {'text': '1 to 3 years', 'score': 10},
        {'text': '3 to 5 years', 'score': 15},
        {'text': '5 to 10 years', 'score': 20},
        {'text': 'More than 10 years', 'score': 25}
      ]
    },
    {
      'question': 'How do you feel about investing in cryptocurrency (like Bitcoin or Ethereum)?',
      'options': [
        {'text': 'I\'m not comfortable with it at all', 'score': 5},
        {'text': 'I\'d consider a very small amount, cautiously', 'score': 10},
        {'text': 'I believe it has potential and would include a modest portion', 'score': 15},
        {'text': 'I\'m open to significant exposure despite the risks', 'score': 20},
        {'text': 'I see it as a core opportunity for high returns', 'score': 25}
      ]
    },
    {
      'question': 'What is your view on gold as part of an investment portfolio?',
      'options': [
        {'text': 'It\'s a safe haven and should make up most of my portfolio', 'score': 5},
        {'text': 'It\'s important for stability and inflation protection', 'score': 10},
        {'text': 'It\'s useful, but should be balanced with other assets', 'score': 15},
        {'text': 'I\'ll keep a small portion for diversification', 'score': 20},
        {'text': 'It\'s not a key part of my strategy', 'score': 25}
      ]
    },
    {
      'question': 'What is your level of investment experience?',
      'options': [
        {'text': 'I\'m new to investing and still learning', 'score': 5},
        {'text': 'I\'ve done some investing but prefer guidance', 'score': 10},
        {'text': 'I\'m familiar with markets and key principles', 'score': 15},
        {'text': 'I follow financial news and manage my own plan', 'score': 20},
        {'text': 'I actively invest and understand complex assets', 'score': 25}
      ]
    },
    {
      'question': 'If your investment doubled in value, what would you likely do?',
      'options': [
        {'text': 'Sell everything to secure profits', 'score': 5},
        {'text': 'Sell part of it and keep the rest invested', 'score': 10},
        {'text': 'Rebalance my portfolio for long-term goals', 'score': 15},
        {'text': 'Hold it for continued growth', 'score': 20},
        {'text': 'Reinvest and seek additional growth opportunities', 'score': 25}
      ]
    },
    {
      'question': 'What is your current age group?',
      'options': [
        {'text': 'Over 60', 'score': 5},
        {'text': '45–60', 'score': 10},
        {'text': '35–44', 'score': 15},
        {'text': '25–34', 'score': 20},
        {'text': 'Under 25', 'score': 25}
      ]
    }
  ];

  int selectedIndex = 0;

  // Helper to get risk profile label from score
  String getRiskLabel(int score) {
    if (score <= 75) {
      return "Defensive";
    } else if (score <= 110) {
      return "Conservative";
    } else if (score <= 145) {
      return "Balanced";
    } else if (score <= 180) {
      return "Growth";
    } else {
      return "Speculative";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    SizedBox(height: 24),
                    Text(
                      "Let's analyse what you interest in",
                      style: GoogleFonts.dancingScript(
                        fontSize: 28,
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: ksecondary.withOpacity(0.2),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Text(
                        questions.elementAt(selectedIndex)["question"],
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: 34),
                    Column(
                      children: List.generate(
                        questions.elementAt(selectedIndex)["options"].length,
                            (index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                selected = index;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: selected == index
                                    ? ksecondary
                                    : Colors.black.withAlpha(10),
                              ),
                              width: double.infinity,
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(12),
                              child: Text(
                                questions
                                    .elementAt(selectedIndex)["options"]
                                    .elementAt(index)["text"],
                                style: GoogleFonts.poppins(
                                  fontSize: 19,
                                  color: selected == index
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              if (selected >= 0)
                InkWell(
                  onTap: () async {
                    List o =
                    questions.elementAt(selectedIndex)["options"];
                    int score = o.elementAt(selected)["score"];
                    if (selectedIndex == questions.length - 1) {
                      setState(() {
                        totalScore = totalScore + score;
                      });

                      // Calculate risk label for this score
                      String riskLabel = getRiskLabel(totalScore);

                      // Save both score and label to Firebase
                      await FirebaseDatabase.instance
                          .ref("users")
                          .child(FirebaseAuth
                          .instance.currentUser!.uid
                          .toString())
                          .update({
                        "score": totalScore,
                        "riskLabel": riskLabel,
                      });

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainScreen(),
                        ),
                      );
                    } else {
                      setState(() {
                        totalScore = totalScore + score;
                        selectedIndex = selectedIndex + 1;
                        selected = -1;
                      });
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: ksecondary),
                    width: double.infinity,
                    child: Text(
                      selectedIndex == questions.length - 1
                          ? "Get Started"
                          : "Next",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.dancingScript(
                        fontWeight: FontWeight.w900,
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
