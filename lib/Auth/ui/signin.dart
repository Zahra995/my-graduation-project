import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutorials_library/Auth/controllers/auth_controller.dart';
import 'package:tutorials_library/Auth/ui/signup.dart';
import 'package:tutorials_library/components/styles/app_colors.dart';
import 'package:tutorials_library/components/widgets/custom_button.dart';
import 'package:tutorials_library/components/widgets/custom_formfield.dart';
import 'package:tutorials_library/components/widgets/custom_header.dart';
import 'package:tutorials_library/components/widgets/custom_richtext.dart';

class Signin extends StatefulWidget {
  const Signin({Key? key}) : super(key: key);

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  String get phone => _phoneController.text.trim();
  String get password => _passwordController.text.trim();
  bool isOld = false;
  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          Container(
            height: _size.height,
            width: _size.width,
            color: AppColors.blue,
          ),
          CustomHeader(
            text: 'Log In to\nAOU library',
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const SignUp()));
            },
          ),
          Positioned(
            top: _size.height * 0.11,
            child: Container(
              height: _size.height * 0.85,
              width: _size.width,
              decoration: const BoxDecoration(
                  color: AppColors.whiteshade,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 200,
                    width: _size.width * 0.8,
                    margin: EdgeInsets.only(left: _size.width * 0.09),
                    child: Image.asset("assets/images/login.png"),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  CustomFormField(
                    headingText: "Email",
                    hintText: "Email",
                    obsecureText: false,
                    suffixIcon: const SizedBox(),
                    controller: _phoneController,
                    maxLines: 1,
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.emailAddress,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  GetBuilder<AuthController>(
                    init: AuthController.instance,
                    builder: (controller) => CustomFormField(
                      headingText: "Password",
                      maxLines: 1,
                      textInputAction: TextInputAction.done,
                      textInputType: TextInputType.visiblePassword,
                      hintText: "At least 8 Character",
                      obsecureText: true,
                      suffixIcon: IconButton(
                          icon: const Icon(Icons.visibility), onPressed: () {}),
                      controller: _passwordController,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 24),
                        child: InkWell(
                          onTap: () {},
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                                color: AppColors.blue.withOpacity(0.7),
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  ),
                  GetBuilder<AuthController>(
                    init: AuthController(),
                    builder: (controller) => AuthButton(
                      onTap: () {
                        controller.login(phone, password);
                      },
                      text: 'Sign In',
                    ),
                  ),
                  /*Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 24),
                        child: InkWell(
                          onTap: () {},
                          child: Switch(
                              value: true,
                              onChanged: (value) {
                                isOld = value;
                              }),
                        ),
                      ),
                    ],
                  ),*/
                  CustomRichText(
                    discription: "Don't already Have an account? ",
                    text: "Sign Up",
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUp()));
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
