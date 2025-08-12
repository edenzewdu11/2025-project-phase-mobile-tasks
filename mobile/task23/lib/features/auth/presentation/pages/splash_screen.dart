import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';

class EcomScreen extends StatefulWidget {
  const EcomScreen({super.key});

  @override
  State<EcomScreen> createState() => _EcomScreenState();
}

class _EcomScreenState extends State<EcomScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(GetUserEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.pushReplacementNamed(
            context,
            '/home',
          ); // ✅ Update route name if needed
        } else if (state is AuthUnauthenticated || state is AuthError) {
          Navigator.pushReplacementNamed(
            context,
            '/login',
          );
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Background image with gradient
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/SplashBG.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Color(0xFF3F51F3), Color(0x903F51F3)],
                    stops: [0.0, 1.0],
                  ),
                ),
              ),
            ),

            // Foreground content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // White Card with ECOM text
                  Container(
                    width: 264,
                    height: 121,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 4,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(31),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'ECOM',
                      style: TextStyle(
                        fontFamily: 'CaveatBrush',
                        fontSize: 112.89,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.02 * 112.89,
                        height: 117.41 / 112.89,
                        textBaseline: TextBaseline.alphabetic,
                        color: Color(0xFF3F51F3),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Ecommerce APP',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 35.98,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.02 * 35.98,
                      height: 37.42 / 35.98,
                      color: Colors.white,
                      textBaseline: TextBaseline.alphabetic,
                    ),
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
