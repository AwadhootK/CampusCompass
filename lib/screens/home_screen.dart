import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('WELCOME TO THE APP'),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () =>
                  Provider.of<Auth>(context, listen: false).logout(),
              child: const Text('Log Out'),
            )
          ],
        ),
      ),
    );
  }
}
