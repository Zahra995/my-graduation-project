import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutorials_library/Auth/controllers/auth_controller.dart';
import 'package:tutorials_library/Auth/ui/signin.dart';
import 'package:tutorials_library/components/styles/app_colors.dart';
import 'package:tutorials_library/components/widgets/custom_button.dart';
import 'package:tutorials_library/components/widgets/custom_formfield.dart';
import 'package:tutorials_library/components/widgets/custom_header.dart';
import 'package:tutorials_library/components/widgets/custom_richtext.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _name = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  String get name => _name.text.trim();
  String get email => _phoneController.text.trim();
  String get password => _passwordController.text.trim();
  bool? isInstructor = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: AppColors.blue,
          ),
          CustomHeader(
              text: 'Sign Up to\nAOU library',
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const Signin()));
              }),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.11,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.88,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  color: AppColors.whiteshade,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width * 0.8,
                    margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.09),
                    child: Image.asset("assets/images/login.png"),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  CustomFormField(
                    headingText: "Name",
                    hintText: "Name",
                    obsecureText: false,
                    suffixIcon: const SizedBox(),
                    maxLines: 1,
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.text,
                    controller: _name,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  CustomFormField(
                    headingText: "Email",
                    hintText: "Email",
                    obsecureText: false,
                    suffixIcon: const SizedBox(),
                    maxLines: 1,
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.emailAddress,
                    controller: _phoneController,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  CustomFormField(
                    maxLines: 1,
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.text,
                    controller: _passwordController,
                    headingText: "Password",
                    hintText: "At least 8 Character",
                    obsecureText: true,
                    suffixIcon: IconButton(
                        icon: const Icon(Icons.visibility), onPressed: () {}),
                  ),
                  CheckboxListTile(
                    value: isInstructor!,
                    title: const Text('I am Instructor'),
                    onChanged: (value) => {
                      setState(() {
                        isInstructor = value;
                      }),
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  GetBuilder<AuthController>(
                    init: AuthController(),
                    builder: (controller) => AuthButton(
                      onTap: () {
                        if (!email.isEmail) {
                          Get.snackbar('Error', 'Invalid Email');
                        } else {
                          controller.register(
                              name, email, password, isInstructor!);
                        }
                      },
                      text: 'Sign up',
                    ),
                  ),
                  CustomRichText(
                    discription: 'Already Have an account? ',
                    text: 'Log In here',
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Signin()));
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
