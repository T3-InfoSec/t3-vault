import 'package:flutter/material.dart';

class InfoButton extends StatelessWidget {
  final String tooltipText;
  final String? infoText;

  const InfoButton({super.key, required this.tooltipText, this.infoText});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.info_outline, color: Colors.grey),
      tooltip: tooltipText,
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Information'),
              content: Text(
                infoText ?? tooltipText,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('ok'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
