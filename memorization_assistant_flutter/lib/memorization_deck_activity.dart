import 'package:flutter/material.dart';

class MemorizationDeckActivity extends StatelessWidget {
  const MemorizationDeckActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Greatwall TKBA Protocol'),
        backgroundColor: const Color(0xFF70A8FF),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                //width: 400,
                width: MediaQuery.of(context).size.width * 0.9,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'My Cards',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: <Widget>[
                          _buildCard('L0', 'Next review:\nyyyy-mm-dd'),
                          const SizedBox(width: 10),
                          _buildCard('L1', 'Next review:\nyyyy-mm-dd'),
                          const SizedBox(width: 10),
                          _buildCard('L2', 'Next review:\nyyyy-mm-dd'),
                          const SizedBox(width: 10),
                          _buildCard('L3', 'Next review:\nyyyy-mm-dd'),
                          const SizedBox(width: 10),
                          _buildCard('L4', 'Next review:\nyyyy-mm-dd'),
                          const SizedBox(width: 10),
                          _buildCard('L5', 'Next review:\nyyyy-mm-dd'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),
              SizedBox(
                width: 250,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF70A8FF),
                  ),
                  onPressed: () {},
                  child: const Text('Try protocol'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(String title, String content) {
    return Container(
      width: 200,
      height: 150,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: const Color(0xFF4A6FA5),
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 5),
          Text(
            content,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
