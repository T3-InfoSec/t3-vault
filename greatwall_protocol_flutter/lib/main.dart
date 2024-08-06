import 'package:flutter/material.dart';

import 'package:greatwall_protocol_flutter/knowledge_types_activity.dart';
import 'package:memorization_assistant_flutter/memorization_deck_activity.dart';

void main() {
  runApp(const MyApp());
}

/// The main application widget that initializes the Greatwall app.
///
/// The [MyApp] class is the entry point of the application. The app allows users 
/// to navigate through different flows related to the Greatwall TKBA protocol.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Greatwall',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeActivity(),
    );
  }
}

/// The home screen of the Greatwall application where users start the process.
///
/// The [HomeActivity] class is a stateless widget that serves as the main 
/// hub for users to begin their journey within the Greatwall TKBA protocol. 
/// From this screen, users can choose between starting the flow to derive a 
/// new hash or practicing on an existing derivation.
/// A welcome image is also 
/// displayed, although it is currently a placeholder to give an idea of the 
/// intended layout.
class HomeActivity extends StatelessWidget {
  const HomeActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Greatwall TKBA protocol'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 300, 
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.asset(
                  'assets/images/welcome_app_icon.jpeg',
                  fit: BoxFit.cover, 
                ),
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: 250,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF70A8FF),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const KnowledgeTypesActivity(),
                    ),
                  );
                },
                child: const Text('Deriving your hash'),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: 250,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF70A8FF),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MemorizationDeckActivity(),
                    ),
                  );
                },
                child: const Text('Practice on your derivation'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
