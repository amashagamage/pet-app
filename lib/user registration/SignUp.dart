import 'package:flutter/material.dart';
import 'package:petpal/user%20registration/homeScreen.dart';
import 'package:petpal/user%20registration/login.dart';
import 'package:petpal/user%20registration/services/authentication.dart';
import 'package:petpal/user%20registration/widget/showSnackbar.dart';
import 'package:petpal/user%20registration/widget/text_field.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
  }

  void signUpUser() async {
    // Show loading indicator
    setState(() {
      isLoading = true;
    });

    try {
      String res = await AuthServices().signUpUser(
        email: emailController.text.trim(),
        password: passwordController.text,
        name: nameController.text.trim(),
      );

      if (res == "Success") {
        // Clear form fields
        emailController.clear();
        passwordController.clear();
        nameController.clear();

        // Navigate to home screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        // Show error message
        showSnackBar(context, res);
      }
    } catch (e) {
      showSnackBar(context, "An unexpected error occurred. Please try again.");
    } finally {
      // Hide loading indicator
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: height / 20),
                    SizedBox(
                      width: double.infinity,
                      height: height / 4,
                      child: Image.asset("images/login.png"),
                    ),
                    SizedBox(height: height / 25),
                    TextFieldInput(
                      hintText: "name",
                      icon: Icons.person,
                      textEditingController: nameController,
                    ),
                    TextFieldInput(
                      hintText: "email",
                      icon: Icons.email,
                      textEditingController: emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    TextFieldInput(
                      hintText: "password",
                      icon: Icons.lock,
                      textEditingController: passwordController,
                      isPass: true,
                    ),
                    SizedBox(height: height / 25),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        minimumSize: Size(230.51, 68.1),
                      ),
                      onPressed: isLoading ? null : signUpUser,
                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              "Sign Up",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                    SizedBox(height: height / 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account?",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Login()),
                            );
                          },
                          child: const Text(
                            " Login",
                            style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: height / 25),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              color: Colors.orange,
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    "All rights reserved",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
