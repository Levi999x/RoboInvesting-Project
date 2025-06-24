import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:stock_market/auth/questions_screen.dart';
import 'package:stock_market/auth/sign_up.dart';

import '../constants/app_colors.dart';
import '../constants/widgets.dart';
import '../main_screen/main_screen.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _login createState() => _login();
}

class _login extends State<Login> {
  TextEditingController emailCon = TextEditingController();
  TextEditingController passwordCon = TextEditingController();
  bool passwordError = false;
  bool showPassword = false;
  bool emailError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: ListView(
          children: [
            const SizedBox(
              height: 80,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text("Hello There!",
                  textAlign: TextAlign.start,
                  style: GoogleFonts.dancingScript(
                      color: Colors.black,
                      fontSize: 48, fontWeight: FontWeight.bold)),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text("We missed you!",
                  textAlign: TextAlign.start,
                  style: GoogleFonts.dancingScript(
                      color: Colors.black,
                      fontSize: 34, fontWeight: FontWeight.normal)),
            ),

            const SizedBox(
              height: 64,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                style: const TextStyle(fontSize: 18),
                onChanged: (value) {
                  if (value.isNotEmpty&&emailError) {
                    setState(() {
                      emailError = false;
                    });
                  }
                },
                controller: emailCon,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    hintText: "Enter Your email ",
                    hintStyle: GoogleFonts.rubik(
                        color: kHint,
                        fontWeight: FontWeight.w300,
                        fontSize: 16),
                    errorText: emailError ? "this field is required" : null,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 12),
                    prefixIcon: Icon(
                      Icons.person,
                      color: ksecondary,
                      size: 22,
                    ),
                    fillColor: kFieldFill,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none)
                ),
                ),
            ),
            const SizedBox(
              height: 18,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                obscureText: !showPassword,
                onChanged: (value) {
                  if (value.isNotEmpty&&passwordError) {
                    setState(() {
                      passwordError = false;
                    });
                  }
                },
                obscuringCharacter: "•",
                style: const TextStyle(fontSize: 18, letterSpacing: 2),
                controller: passwordCon,
                decoration: InputDecoration(
                    hintText: "Password",
                    hintStyle: GoogleFonts.rubik(
                        color: kHint,
                        fontWeight: FontWeight.w300,
                        fontSize: 16),
                    errorText: passwordError ? "this field is required" : null,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 12),
                    suffixIcon: InkWell(
                        onTap: () {
                          if (showPassword) {
                            setState(() {
                              showPassword = false;
                            });
                          } else {
                            setState(() {
                              showPassword = true;
                            });
                          }
                        },
                        borderRadius: BorderRadius.circular(45),
                        child: Icon(
                          !showPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: ksecondary,
                          size: 22,
                        )),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: ksecondary,
                      size: 22,
                    ),
                    fillColor: kFieldFill,
                    filled: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none)
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            InkWell(
              onTap: () async {
                String email = emailCon.text.trim().toString();
                String password = passwordCon.text.trim().toString();
                if(email.isNotEmpty&&password.isNotEmpty){
                 showProgressIndicator(context);
                  try{
                    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email,
                        password: password).then((user) {
                          if(user.user!=null){
                           var ref = FirebaseDatabase.instance.ref("users")
                               .child(user.user!.uid.toString());
                           ref.get().then((value) {
                             if(value.exists){
                               Map user = value.value as Map;
                               int score = user["score"];                                // Provider.of<MyDataProvider>(context,listen: false).initializeData();
                               if(score>0){
                                 if(mounted)
                                   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)
                                   => MainScreen(),)
                                     , (route) => false,);
                               }else{
                                 if(mounted)
                                   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)
                                   => QuestionsScreen(),)
                                     , (route) => false,);
                               }
                             }
                           },);
                      }
                    },);

                  }on FirebaseAuthException catch (e) {
                    Navigator.pop(context);
                    if (e.code == 'user-not-found') {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:
                      Text("there is no account found for that email.")));
                    } else if (e.code == 'wrong-password') {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:
                      Text("Wrong password"),));

                    } else if (e.code == 'invalid-credential') {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:
                      Text("invalid email or password"),));

                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:
                      Text("Error ${e.code}"),));
                      print("CCCCCCCCCC ${e.code}");

                    }
                  } catch( e){
                    Navigator.pop(context);
                    throw("Error ${e}");
                  }
                }else{
                  if(email.isEmpty){
                    emailError = true;
                  }

                  if(password.isEmpty){
                    passwordError = true;
                  }

                  setState(() {});
                  print("SOMETHING EMPTY");
                }
              },
              borderRadius: BorderRadius.circular(10),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: ksecondary),
                width: double.infinity,
                child: Text(
                  "Sign in",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.dancingScript(
                      fontWeight: FontWeight.w900,
                      fontSize: 24,
                      color: Colors.white),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Do not have an account?",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.black54
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUp(),
                          ));
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 6),
                      child: Text(
                        "Sign up",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.dancingScript(
                            fontWeight: FontWeight.w900,
                            fontSize: 24,
                            color: ksecondary
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),

            const SizedBox(
              height: 6,
            ),
          ],
        ),
      ),
    );
  }
}
