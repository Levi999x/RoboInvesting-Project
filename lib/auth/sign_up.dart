import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:stock_market/auth/questions_screen.dart';
import 'package:stock_market/constants/app_colors.dart';

import '../constants/widgets.dart';
import '../main_screen/main_screen.dart';
import '../models/uploadUser.dart';
import 'login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  _signUp createState() => _signUp();
}

class _signUp extends State<SignUp> {
  TextEditingController emailCon = TextEditingController();
  TextEditingController passwordCon = TextEditingController();
  TextEditingController phoneCon = TextEditingController();
  TextEditingController addressCon = TextEditingController();
  TextEditingController nameCon = TextEditingController();
  bool passwordError = false;
  bool showPassword = false;
  bool emailError = false;
  bool nameError = false;
  bool phoneError = false;
  bool addressError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: ListView(
          children: [
            const SizedBox(
              height: 80,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text("Hello!",
                  textAlign: TextAlign.start,
                  style: GoogleFonts.dancingScript(
                      color: Colors.black,
                      fontSize: 48, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text("Sign up",
                  textAlign: TextAlign.start,
                  style: GoogleFonts.dancingScript(
                      color: Colors.black,

                      fontSize: 40, fontWeight: FontWeight.bold)),
            ),

            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                style: const TextStyle(fontSize: 18),
                onChanged: (value) {
                  if (value.isNotEmpty&&emailError) {
                    setState(() {
                      nameError = false;
                    });
                  }
                },
                controller: nameCon,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    hintText: "Your name ",
                    hintStyle: GoogleFonts.rubik(
                        color: kHint,
                        fontWeight: FontWeight.w300,
                        fontSize: 16),
                    errorText: nameError ? "this field is required" : null,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 12),
                    // suffixIcon: Icon(Icons.check,color: AppColors.purple,size: 22,),
                    prefixIcon: Icon(
                      Icons.person,
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
              height: 18,
            ),

               Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                style: const TextStyle(fontSize: 18),
                onChanged: (value) {
                  if (value.isNotEmpty&&emailError) {
                    setState(() {
                      phoneError = false;
                    });
                  }
                },
                controller: phoneCon,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    hintText: "Your Phone Number ",
                    hintStyle: GoogleFonts.rubik(
                        color: kHint,
                        fontWeight: FontWeight.w300,
                        fontSize: 16),
                    errorText: phoneError ? "this field is required" : null,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 12),
                    // suffixIcon: Icon(Icons.check,color: AppColors.purple,size: 22,),
                    prefixIcon: Icon(
                      Icons.call,
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
              height: 18,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                style: const TextStyle(fontSize: 18),
                onChanged: (value) {
                  if (value.isNotEmpty&&emailError) {
                    setState(() {
                      addressError = false;
                    });
                  }
                },
                controller: addressCon,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    hintText: "address ",
                    hintStyle: GoogleFonts.rubik(
                        color: kHint,
                        fontWeight: FontWeight.w300,
                        fontSize: 16),
                    errorText: addressError ? "this field is required" : null,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 12),
                    // suffixIcon: Icon(Icons.check,color: AppColors.purple,size: 22,),
                    prefixIcon: Icon(
                      Icons.home,
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
              height: 18,
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
                    // suffixIcon: Icon(Icons.check,color: AppColors.purple,size: 22,),
                    prefixIcon: Icon(
                      Icons.person,
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
                String address = addressCon.text.trim().toString();
                String phone = phoneCon.text.trim().toString();
                String name = nameCon.text.trim().toString();
                if(email.isNotEmpty&&password.isNotEmpty&&name.isNotEmpty&&
                    phone.isNotEmpty&&address.isNotEmpty){
                  showProgressIndicator(context);
                  try{
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: email,
                        password: password).then((user) {
                          if(user.user!=null){
                           var ref = FirebaseDatabase.instance.ref("users")
                               .child(user.user!.uid.toString());
                           String id = user.user!.uid.toString();
                           UploadUser upload = UploadUser(id, "", phone,
                               name, email,""
                               ,DateTime.now().microsecondsSinceEpoch,0
                               ,0.01, address);
                           ref.set(upload.toJson()).then((value) {
                             Navigator.pushAndRemoveUntil(context,
                               MaterialPageRoute(builder: (context) => QuestionsScreen(),)
                                 , (route) => false,);
                           },);
                          }
                    },);

                  }on FirebaseAuthException catch (e) {
                    Navigator.pop(context);
                    if (e.code == 'weak-password') {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("The password provided is too weak.")));
                    print('The password provided is too weak.');
                    } else if (e.code == 'email-already-in-use') {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:
                    Text("The account already exists for that email.")));

                    print('The account already exists for that email.');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                          Text("ERROR ${e.code}")));
                    }
                    } catch( e){
                    Navigator.pop(context);
                    throw("Error ${e}");
                  }
                }else{
                  print("SOMETHING EMPTY");
                  if(email.isEmpty){
                    emailError = true;
                  }
                  if(password.isEmpty){
                    passwordError = true;
                  }

                  if(phone.length!=11){
                    phoneError = true;
                  }

                  if(name.isEmpty){
                    nameError = true;
                  }

                  if(address.isEmpty){
                    addressError = true;
                  }
                  setState(() {});
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
                  "Sign up",
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
                    "already have an account?",
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
                            builder: (context) => Login(),
                          ));
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 6),
                      child: Text(
                        "Sign in",
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
