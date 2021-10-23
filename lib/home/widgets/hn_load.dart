// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';

class HNLoad extends StatelessWidget {
  const HNLoad({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 80,
          horizontal: 20,
        ),
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset('assets/metal.png'),
                Image.asset(
                  'assets/logo.png',
                  fit: BoxFit.fill,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.height * 0.15,
                  child: const CircularProgressIndicator(
                    color: Colors.grey,
                    strokeWidth: 20,
                  ),
                )
              ]),
        ),
      ),
    );
  }
}
