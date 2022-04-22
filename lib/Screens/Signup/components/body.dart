import 'package:chat_using_firebase/Screens/Signup/components/social_icon.dart';
import 'package:chat_using_firebase/Screens/Signup/provider/SignUpProvider.dart';
import 'package:chat_using_firebase/Screens/UserList/user_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Screens/Login/login_screen.dart';
import '../../../Screens/Signup/components/background.dart';
import '../../../Screens/Signup/components/or_divider.dart';
import '../../../Screens/Signup/components/social_icon.dart';
import 'package:flutter_svg/svg.dart';

import '../../../components/already_have_an_account_check.dart';
import '../../../components/rounded_button.dart';
import '../../../components/rounded_input_field.dart';
import '../../../components/rounded_password_field.dart';
import '../../Login/login_screen.dart';
import 'or_divider.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final TextEditingController passwordController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "SIGNUP",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/signup.svg",
              height: size.height * 0.35,
            ),
            RoundedInputField(
              controller: emailController,
              hintText: "Your Email",
              onChanged: (value) {},
            ),
            RoundedPasswordField(
              controller: passwordController,
              onChanged: (value) {},
            ),
            Consumer<SignUpProvider>(
              builder: (context, signupProvider, child) {
                return RoundedButton(
                  text: "SIGNUP",
                  press: () async {
                    await signupProvider.signUp(
                        name: "",
                        password: passwordController.text,
                        email: emailController.text);
                    if (signupProvider.user != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const UsersList(
                              searchString: "",
                            );
                          },
                        ),
                      );
                    }
                  },
                );
              },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const LoginScreen();
                    },
                  ),
                );
              },
            ),
            const OrDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SocialIcon(
                  iconSrc: "assets/icons/facebook.svg",
                  press: () {},
                ),
                SocialIcon(
                  iconSrc: "assets/icons/twitter.svg",
                  press: () {},
                ),
                SocialIcon(
                  iconSrc: "assets/icons/google-plus.svg",
                  press: () {},
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
