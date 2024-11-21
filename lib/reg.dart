import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:niramaya/login.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with TickerProviderStateMixin {
  bool _obscureText = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  String? _passwordErrorText;

  Future<void> registerUser({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    if (password.length < 8) {
      setState(() {
        _passwordErrorText = "Password must be at least 8 characters long";
      });
      return;
    }

    if (password != confirmPasswordController.text) {
      setState(() {
        _passwordErrorText = "Passwords do not match";
      });
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Save user details to Firestore
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userCredential.user!.uid)
          .set({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
            const LoginScreen()), // Remove the 'title' parameter
      );
    } on FirebaseAuthException catch (ex) {

    }
  }

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_fadeController);

    _fadeController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F4F3), // Set background color here
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Image.asset(
                        'assets/register.png',
                        height: 400, // Adjust size as needed
                        width: 400,
                      ),
                    ),
                    ScaleTransition(
                      scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                          parent: _fadeController,
                          curve: Curves.easeInOut,
                        ),
                      ),
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'poppins',
                          color: Color(0xff4b3426),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: firstNameController,
                              decoration: InputDecoration(
                                hintStyle: const TextStyle(color: Colors.black),
                                labelText: "First Name",
                                labelStyle: const TextStyle(
                                    color: Colors.black, fontSize: 10,fontFamily: 'poppins'),
                                hintText: "Enter first name",
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                          const SizedBox(
                              width: 10), // Add some spacing between fields
                          Expanded(
                            child: TextField(
                              controller: lastNameController,
                              decoration: InputDecoration(
                                hintStyle: const TextStyle(color: Colors.black,fontFamily: 'poppins'),
                                labelText: "Last Name",
                                labelStyle: const TextStyle(
                                    color: Colors.black, fontSize: 10),
                                hintText: "Enter last name",
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              style: const TextStyle(color: Colors.black,fontFamily: 'poppins'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintStyle: const TextStyle(color: Colors.black,fontFamily: 'poppins'),
                          labelText: "Email",
                          labelStyle: const TextStyle(
                              color: Colors.black, fontSize: 10,fontFamily: 'poppins'),
                          hintText: "Enter email",
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        style: const TextStyle(color: Colors.black,fontFamily: 'poppins'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          hintStyle: const TextStyle(color: Colors.black,fontFamily: 'poppins'),
                          labelText: "Password",
                          labelStyle: const TextStyle(
                              color: Colors.black, fontSize: 10,fontFamily: 'poppins'),
                          hintText: "Enter password",
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          errorText: _passwordErrorText,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                        style: const TextStyle(color: Colors.black,fontFamily: 'poppins'),
                        obscureText: _obscureText,
                      ),
                    ),
                    const SizedBox(height: 20),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: TextField(
                        controller: confirmPasswordController,
                        decoration: InputDecoration(
                          labelText: "Confirm Password",
                          labelStyle: const TextStyle(
                              color: Colors.black, fontSize: 10,fontFamily: 'poppins'),
                          hintText: "Re-enter password",
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          errorText: _passwordErrorText,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                        style: const TextStyle(color: Colors.black,fontFamily: 'poppins'),
                        obscureText: _obscureText,
                      ),
                    ),
                    const SizedBox(height: 20),
                    AnimatedBuilder(
                      animation: _fadeController,
                      builder: (context, child) {
                        return Transform.translate(
                          offset:
                          Offset(0.0, 10.0 * (1 - _fadeController.value)),
                          child: ElevatedButton(
                            onPressed: () {
                              registerUser(
                                firstName: firstNameController.text,
                                lastName: lastNameController.text,
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            },
                            child: const Text("Register",style: TextStyle(fontFamily: 'poppins',color: Colors.white,fontSize: 20),),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: const Text(
                      "Have an account?",
                      style: TextStyle(color: Colors.black,fontFamily: 'poppins'),
                    ),
                  ),
                  const SizedBox(width: 5),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                          // ignore: avoid_types_as_parameter_names
                              (Route) => false,
                        );
                      },
                      child: const MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Text(
                          "Login",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.black,
                            fontSize: 18, // Increased font size
                            fontFamily: 'poppins'
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }
}
