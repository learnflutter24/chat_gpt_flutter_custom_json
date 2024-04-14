import 'package:flutter/material.dart';

const kValue = 15.0;

Padding card({
  required int index,
  required Alignment alignment,
  required bool isBot,
  required String message,
}) =>
    Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: kValue,
        vertical: kValue,
      ),
      child: Stack(
        children: [
          Align(
            alignment: alignment,
            child: isBot
                ? const CircleAvatar(
                    backgroundImage: AssetImage('assets/chatGpt.png'),
                    radius: 18,
                  )
                : const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
          ),
          Align(
            alignment: alignment,
            child: Container(
              margin: isBot
                  ? const EdgeInsets.only(
                      right: kValue / 2,
                      left: kValue * 3.6,
                    )
                  : const EdgeInsets.only(
                      left: kValue / 2,
                      right: kValue * 3.6,
                    ),
              padding: isBot
                  ? const EdgeInsets.symmetric(
                      horizontal: kValue * 1.2,
                      vertical: kValue / 1.2,
                    )
                  : const EdgeInsets.symmetric(
                      horizontal: kValue * 1.2,
                      vertical: kValue / 1.2,
                    ),
              decoration: BoxDecoration(
                color:
                    isBot ? const Color(0xffffffff) : const Color(0xff0360a6),
                borderRadius: isBot
                    ? const BorderRadius.only(
                        bottomLeft: Radius.circular(kValue * 3.33),
                        bottomRight: Radius.circular(kValue * 3.33),
                        topRight: Radius.circular(kValue * 3.33),
                      )
                    : const BorderRadius.only(
                        bottomRight: Radius.circular(kValue * 3.33),
                        bottomLeft: Radius.circular(kValue * 3.33),
                        topLeft: Radius.circular(kValue * 3.33),
                      ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: const Offset(kValue / 5, kValue / 5),
                    blurRadius: kValue * 0.5,
                  ),
                ],
              ),
              child: Text(
                message,
                style: TextStyle(
                  color:
                      isBot ? const Color(0xff0360a6) : const Color(0xffffffff),
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
