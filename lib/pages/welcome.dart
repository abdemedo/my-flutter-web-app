// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/login.dart';
import 'package:flutter_application_2/pages/signup.dart';
import 'package:flutter_svg/flutter_svg.dart';


class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 35,
                    ),
                
                    Text("Welcome",style: TextStyle(fontSize: 33, fontFamily: "myfont"), ),
                    SizedBox(
                      height: 35,
                    ),
          
                    SvgPicture.asset("icons/chat.svg",width: 288,),        
                      SizedBox(
                      height: 35,
                    ),
          
                    ElevatedButton(
                      onPressed: () {
                      Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Login()),
            );
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                            const Color.fromARGB(255, 107, 56, 148)),
                        padding: WidgetStateProperty.all(
                            EdgeInsets.symmetric(horizontal: 79, vertical: 10)),
                        shape: WidgetStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(27))),
                      ),
                      child: Text(
                        "login",
                        style: TextStyle(fontSize: 23, color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 22,
                    ),
            
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUp()),
            );
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(const Color.fromRGBO(225, 190, 231, 1)),
                        padding: WidgetStateProperty.all(
                            EdgeInsets.symmetric(horizontal: 77, vertical: 13)),
                        shape: WidgetStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(27))),
                      ),
                      child: Text(
                        "SIGNUP",
                        style: TextStyle(
                            fontSize: 17,
                            color: const Color.fromARGB(255, 0, 0, 0)),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                child: Image.asset(
                  'images/maintop.png',
                  width: 112,
                ),
              ),
              Positioned(
                bottom: 0,
                child: Image.asset(
                  'images/mainbottom.png',
                  width: 65,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
