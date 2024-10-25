import 'package:flutter/material.dart';

class CopyEkaCodeWidget extends StatelessWidget {
  const CopyEkaCodeWidget({super.key, required this.ekaUxChunks});
  final List<String> ekaUxChunks;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Backup Your EKA Code',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: ekaUxChunks.map((chunk) {
                return Chip(
                  label: Text(
                    chunk,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  backgroundColor: Colors.blue.shade50.withOpacity(0.4),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text(
              'Write this code down physically and store it in a safe place.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => ConfirmEkaCode(ekaUxChunks: ekaUxChunks),
                );
              },
              child: const Text('Confirm Code'),
            ),
          ],
        ),
      ),
    );
  }
}

//
class ConfirmEkaCode extends StatefulWidget {
  const ConfirmEkaCode({super.key, required this.ekaUxChunks});
  final List<String> ekaUxChunks;

  @override
  State<ConfirmEkaCode> createState() => _ConfirmEkaCodeState();
}

class _ConfirmEkaCodeState extends State<ConfirmEkaCode> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.ekaUxChunks.length, (index) => TextEditingController());
    _focusNodes = List.generate(widget.ekaUxChunks.length, (index) => FocusNode());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onDone() {
    final enteredChunks = _controllers.map((controller) => controller.text.trim()).toList();

    final isValid = enteredChunks.asMap().entries.every((entry) {
      final index = entry.key;
      final enteredChunk = entry.value;
      final originalChunk = widget.ekaUxChunks[index];
      return enteredChunk == originalChunk;
    });

    if (isValid) {
      Navigator.of(context).pop(true);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('The entered code does not match the original. Please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  // Move to the next text field when current one is filled
  void _onTextChanged(String value, int index) {
    if (value.length == 4 && index < widget.ekaUxChunks.length - 1) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.2),
      child: Container(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Confirm Your EKA Code',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.ekaUxChunks.length, (i) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SizedBox(
                    width: 80,
                    child: TextField(
                      controller: _controllers[i],
                      focusNode: _focusNodes[i],
                      textAlign: TextAlign.center,
                      maxLength: 4,
                      keyboardType: TextInputType.number,
                      onChanged: (value) => _onTextChanged(value, i),
                      decoration: InputDecoration(
                        counterText: '',
                        hintText: '${i + 1}',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: _onDone,
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
