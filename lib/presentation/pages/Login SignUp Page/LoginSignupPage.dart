import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flip_card/flip_card.dart';
import 'package:to_do_app/presentation/pages/Home%20Page/HomePage.dart';

import '../../../common/methods/methods.dart';
import 'login_bloc.dart';
import 'login_event.dart';
import 'login_state.dart';

class SignUpLoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FlipCardState> _flipCardKey = GlobalKey<FlipCardState>();

  SignUpLoginPage({super.key});

  // Register user
  void registerUser(BuildContext context) {
    BlocProvider.of<AuthBloc>(context).add(
      SignupEvent(
        _emailController.text,
        _passwordController.text,
      ),
    );
  }

  // Log in user
  void loginUser(BuildContext context) {
    BlocProvider.of<AuthBloc>(context).add(
      LoginEvent(
        _emailController.text,
        _passwordController.text,
      ),
    );
  }

  // Flip the card to show the login page
  void flipToLoginPage() {
    _flipCardKey.currentState?.toggleCard();
  }

  // Flip the card to show the signup page
  void flipToSignUpPage() {
    _flipCardKey.currentState?.toggleCard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            AlertDialog(
              backgroundColor: Colors.white,
              content: Center(
                child: Text("There is an error please try again"),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("close"))
              ],
            );
          } else if (state is AuthSuccess) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        },
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlipCard(
                    key: _flipCardKey,
                    direction: FlipDirection.HORIZONTAL,
                    front: Card(
                      shadowColor: Colors.grey.withOpacity(0.8),
                      elevation: 60,
                      color: Colors.black,
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.login,
                              color: Colors.white,
                              size: 70,
                            ),

                            YaziTipi("Welcome to UpTodo", 32, Colors.white),
                            const SizedBox(
                              height: 15,
                            ),
                            YaziTipi(
                                "Please login to your account or create new account to continue",
                                16,
                                Colors.white),
                            const SizedBox(height: 20),
                            // Email TextField
                            TextfildController(
                              controller: _emailController,
                              label: "Enter your email",
                              password: false,
                            ),
                            const SizedBox(height: 20),
                            // Password TextField
                            TextfildController(
                              controller: _passwordController,
                              label: "Password",
                              password: true,
                            ),
                            const SizedBox(height: 20),
                            // Submit Button
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    elevation: 20,
                                    backgroundColor: Color(0xff8687E7),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                onPressed: () => loginUser(context),
                                child: YaziTipi("Log In", 20, Colors.white),
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Flip to sign-up
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Don't have a profile?",
                                  style: TextStyle(color: Colors.white),
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: flipToSignUpPage,
                                  child: YaziTipi("Sign Up", 20, Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    back: Card(
                      shadowColor: Colors.grey.withOpacity(0.8),
                      elevation: 60,
                      color: Colors.black,
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.person_add,
                              color: Colors.white,
                              size: 70,
                            ),
                            YaziTipi("Register", 30, Colors.white),
                            const SizedBox(height: 15),

                            // Name TextField
                            TextfildController(
                              controller: _nameController,
                              label: "Enter your Name",
                              password: false,
                            ),
                            const SizedBox(height: 20),
                            // Email TextField
                            TextfildController(
                              controller: _emailController,
                              label: "Enter your email",
                              password: false,
                            ),
                            const SizedBox(height: 20),
                            // Password TextField
                            TextfildController(
                              controller: _passwordController,
                              label: "Password",
                              password: true,
                            ),
                            const SizedBox(height: 20),
                            // Submit Button
                            SizedBox(
                              height: 50,
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    elevation: 20,
                                    backgroundColor: Color(0xff8687E7),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                onPressed: () => registerUser(context),
                                child: YaziTipi("Sign Up", 20, Colors.white),
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Flip to login
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Already have a profile?",
                                  style: TextStyle(color: Colors.white),
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: flipToLoginPage,
                                  child: YaziTipi("Log In", 20, Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
