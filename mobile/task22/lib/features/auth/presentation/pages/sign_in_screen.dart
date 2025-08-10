import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // For testing purposes
    final TextEditingController emailController = TextEditingController(text: 'eden@email.com');
    final TextEditingController passwordController = TextEditingController(text: 'eden1234');

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.pushReplacementNamed(
            context,
            '/home',
            arguments: {'name': state.user.name, 'email': state.user.email},
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                      maxWidth: constraints.maxWidth,
                    ),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 80),

                      // The Card with "ecom"
                      Container(
                        width: 144,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x66000000),
                              blurRadius: 4,
                              offset: Offset(0, 4),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'ECOM',
                          style: TextStyle(
                            fontFamily: 'CaveatBrush',
                            fontWeight: FontWeight.w400,
                            fontSize: 48,
                            height: 24.26 / 48,
                            letterSpacing: 0.02,
                            textBaseline: TextBaseline.alphabetic,
                            color: Color(0xFF3F51F3),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      const Text(
                        'Sign into your account',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 26.72,
                          height: 111.58 / 26.72,
                          letterSpacing: 0.02,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 40),

                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Email',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            height: 49.85 / 16,
                            letterSpacing: 0.02,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      Container(
                        width: 288,
                        height: 42,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAFAFA),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            hintText: 'ex: jon.smith@email.com',
                            hintStyle: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              height: 49.85 / 15,
                              letterSpacing: 0.02,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Password',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            height: 49.85 / 16,
                            letterSpacing: 0.02,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      Container(
                        width: 288,
                        height: 42,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAFAFA),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: '********',
                            hintStyle: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              height: 49.85 / 15,
                              letterSpacing: 0.02,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Sign In Button or Loading Indicator
                      if (state is AuthLoading)
                        const CircularProgressIndicator()
                      else
                        SizedBox(
                          width: 288,
                          height: 42,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3F51F3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              final email = emailController.text.trim();
                              final password = passwordController.text.trim();

                              if (email.isNotEmpty && password.isNotEmpty) {
                                context.read<AuthBloc>().add(
                                  LoginEvent(email: email, password: password),
                                );
                              }
                            },
                            child: const Text(
                              'SIGN IN',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                height: 49.85 / 15,
                                letterSpacing: 0.02,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                      const Spacer(),

                      // More visible Sign Up button
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30, top: 20),
                        child: Column(
                          children: [
                            const Text(
                              'New to our app?',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Color(0xFF3F51F3), width: 1.5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/signup');
                                },
                                child: const Text(
                                  'CREATE NEW ACCOUNT',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    letterSpacing: 0.5,
                                    color: Color(0xFF3F51F3),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
