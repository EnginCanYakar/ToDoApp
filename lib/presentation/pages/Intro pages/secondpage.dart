import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do_app/presentation/pages/Intro%20pages/firstpage.dart';
import 'package:to_do_app/presentation/pages/Intro%20pages/thirdpage.dart';
import 'package:to_do_app/presentation/pages/Login%20SignUp%20Page/LoginSignupPage.dart';

class SecondIntro extends StatelessWidget {
  const SecondIntro({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignUpLoginPage(),
                  ));
            },
            child: Text(
              "Skip",
              style: GoogleFonts.lato(fontSize: 16, color: Colors.grey),
            )),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
            ),
            Image.asset("assets/images/intro2.png"),
            SizedBox(
              height: 50,
            ),
            Image.asset("assets/images/intro2 dot.png"),
            SizedBox(
              height: 46,
            ),
            Text(
              "Create daily routine",
              style: GoogleFonts.lato(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 46,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 70, left: 70),
              child: Text(
                "In Uptodo  you can create your personalized routine to stay productive",
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 15),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FirstIntro(),
                            ));
                      },
                      child: Text(
                        "BACK",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                          disabledBackgroundColor: Colors.transparent,
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
                    ),
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ThirdIntro(),
                          ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 15),
                      child: Text(
                        "NEXT",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff8875FF),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
