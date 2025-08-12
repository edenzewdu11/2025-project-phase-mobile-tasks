import 'package:flutter/material.dart';

class UserIntro extends StatelessWidget {
  final String userName;
  final String dateText;

  const UserIntro({super.key, required this.userName, required this.dateText});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFFCCCCCC),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              dateText,
              style: const TextStyle(
                fontFamily: 'Syne',
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: Color(0xFFAAAAAA),
              ),
            ),
            const SizedBox(height: 4),
            Text.rich(
              TextSpan(
                text: 'Hello, ',
                style: const TextStyle(
                  fontFamily: 'Sora',
                  fontWeight: FontWeight.w400,
                  fontSize: 10,
                  color: Color(0xFFAAAAAA),
                ),
                children: [
                  TextSpan(
                    text: userName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Sora',
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
