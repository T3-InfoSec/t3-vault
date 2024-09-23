import 'package:flutter/material.dart';
import 'package:t3_memassist/memory_assistant.dart';

class MemoCardViewer extends StatefulWidget {
  final ThemeData themeData;
  final int levelNumber;
  final MemoCard memoCard;
  final String deckName;

  const MemoCardViewer({
    super.key,
    required this.themeData,
    required this.levelNumber,
    required this.memoCard,
    required this.deckName,
  });

  @override
  State<MemoCardViewer> createState() => _MemoCardViewerState();
}

class _MemoCardViewerState extends State<MemoCardViewer> {
  String deckName = 'Deck';
  TextEditingController deckNameController = TextEditingController();
  @override
  void initState() {
    deckName = widget.deckName;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 150,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: widget.themeData.colorScheme.primary,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: widget.themeData.textTheme.titleLarge!.fontSize,
                    fontWeight: widget.themeData.textTheme.titleLarge!.fontWeight,
                    color: widget.themeData.colorScheme.onPrimary,
                  ),
                  deckName,
                ),
              ),
              IconButton(
                style: IconButton.styleFrom(
                  foregroundColor: widget.themeData.colorScheme.onPrimary,
                  backgroundColor: widget.themeData.colorScheme.primary,
                ),
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  final newName = await showDialog<String>(
                    context: context,
                    builder: (context) {
                      // Todo add persitenace to deck name and card details
                      return AlertDialog(
                        title: const Text('Edit Deck Name'),
                        content: TextField(
                          controller: deckNameController,
                          decoration: const InputDecoration(
                            hintText: 'Enter new deck name',
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, deckNameController.text),
                            child: const Text('Save'),
                          ),
                        ],
                      );
                    },
                  );
                  if (newName != null) {
                    setState(() {
                      deckName = newName;
                      
                    });
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            style: TextStyle(
              fontSize: widget.themeData.textTheme.bodySmall!.fontSize,
              fontWeight: widget.themeData.textTheme.bodySmall!.fontWeight,
              color: widget.themeData.colorScheme.onPrimary,
            ),
            'Next review:\n${widget.memoCard.due.toLocal()}',
          ),
        ],
      ),
    );
  }
}
