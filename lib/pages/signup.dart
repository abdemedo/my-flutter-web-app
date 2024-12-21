import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/login.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';



class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isVisible = true;

  // دالة التحقق من الشروط الخاصة بكلمة المرور
  bool isValidPasswordStructure(String password) {
    final RegExp passwordStructureRegExp = RegExp(
      r'^(?=.*[a-zA-Z])(?=.*\d.*\d).{6,}$',
    );
    return passwordStructureRegExp.hasMatch(password);
  }

  // دالة تسجيل المستخدم
  Future<void> signUp() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // تحقق من وجود كلمة السر وكلمة المرور
    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'يجب عليك إدخال كلمة المرور وكلمة السر.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // تحقق من كلمة المرور
    if (!isValidPasswordStructure(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'كلمة السر يجب أن تحتوي على: 6 أحرف على الأقل، و2 أرقام على الأقل.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // تحقق من أن كلمة المرور وكلمة السر متطابقتين
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'تم قبولك! التسجيل ناجح.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  // دالة فتح الروابط
  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: Image.asset(
                  'images/maintop.png',
                  width: 100,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Image.asset(
                  'images/loginbottom.png',
                  width: 100,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset('icons/signup.svg'),
                  const SizedBox(height: 20),
                  const Text(
                    "Sign up",
                    style: TextStyle(fontSize: 35, fontFamily: "myfont"),
                  ),
                  const SizedBox(height: 21),
                  // Email input field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.purple[100],
                      borderRadius: BorderRadius.circular(66),
                    ),
                    width: 266,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.person,
                            color: Colors.purple[800],
                          ),
                          hintText: "Your Email :",
                          border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(height: 23),
                  // Password input field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.purple[100],
                      borderRadius: BorderRadius.circular(66),
                    ),
                    width: 266,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: isVisible,
                      decoration: InputDecoration(
                          suffix: IconButton(
                            onPressed: () {
                              setState(() {
                                isVisible = !isVisible;
                              });
                            },
                            icon: Icon(isVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            color: Colors.purple[900],
                          ),
                          icon: Icon(
                            Icons.lock,
                            color: Colors.purple[800],
                            size: 19,
                          ),
                          hintText: "Password :",
                          border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(height: 17),
                  // Sign up button
                  ElevatedButton(
                    onPressed: signUp,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 107, 56, 148)),
                      padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(horizontal: 93, vertical: 10)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(27))),
                    ),
                    child: Text(
                      "Sign up",
                      style: TextStyle(fontSize: 23, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 17),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Login()),
                          );
                        },
                        child: Text(
                          " Log in",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 17),
                  SizedBox(
                    width: 277,
                    child: Row(
                      children: [
                        Expanded(
                            child: Divider(
                          thickness: 0.5,
                          color: Colors.purple[900],
                        )),
                        Text(
                          "OR",
                          style: TextStyle(
                            color: Colors.purple[900],
                          ),
                        ),
                        Expanded(
                            child: Divider(
                          thickness: 0.5,
                          color: Colors.purple[900],
                        )),
                      ],
                    ),
                  ),
                  // Social login buttons (Facebook, Google, Twitter)
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 22),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _launchURL('https://www.facebook.com/r.php?locale=en_GB&display=page');
                          },
                          child: Container(
                            padding: EdgeInsets.all(13),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: const Color.fromRGBO(225, 190, 231, 1),
                                    width: 1)),
                            child: SvgPicture.asset(
                              "icons/facebook.svg",
                              color: Colors.purple[700],
                              height: 18,
                            ),
                          ),
                        ),
                        SizedBox(width: 35),
                        GestureDetector(
                          onTap: () {
                            _launchURL('https://accounts.google.com/signup');
                          },
                          child: Container(
                            padding: EdgeInsets.all(13),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: const Color.fromRGBO(225, 190, 231, 1),
                                    width: 1)),
                            child: SvgPicture.asset(
                              "icons/google-plus.svg",
                              color: Colors.purple[700],
                              height: 18,
                            ),
                          ),
                        ),
                        SizedBox(width: 35),
                        GestureDetector(
                          onTap: () {
                            _launchURL('https://twitter.com/i/flow/signup');
                          },
                          child: Container(
                            padding: EdgeInsets.all(13),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: const Color.fromRGBO(225, 190, 231, 1),
                                    width: 1)),
                            child: SvgPicture.asset(
                              "icons/twitter.svg",
                              color: Colors.purple[700],
                              height: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
