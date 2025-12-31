import 'package:flutter/material.dart';

class CarbonScoreDisplay extends StatelessWidget {
  const CarbonScoreDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carbon Score'),
      ),
      body: const Center(
        child: Text('Carbon Score Display'),
      ),
    );
  }
}