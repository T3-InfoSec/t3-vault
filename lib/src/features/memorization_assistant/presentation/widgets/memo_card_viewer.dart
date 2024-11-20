import 'package:flutter/material.dart';
import 'package:t3_memassist/memory_assistant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3_vault/src/common/notifications/state/notifications_state.dart';

class MemoCardViewer extends StatelessWidget {
  final ThemeData themeData;
  final MemoCard memoCard;

  const MemoCardViewer({
    super.key,
    required this.themeData,
    required this.memoCard,
  });

  @override
  Widget build(BuildContext context) {
    final String? pendingPayload = context.watch<NotificationsState>().pendingPayload;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 200,
          height: 150,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: themeData.colorScheme.primary,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                memoCard.title,
                style: TextStyle(
                  fontSize: themeData.textTheme.titleLarge!.fontSize,
                  fontWeight: themeData.textTheme.titleLarge!.fontWeight,
                  color: themeData.colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Next review:\n${memoCard.due.toLocal()}',
                style: TextStyle(
                  fontSize: themeData.textTheme.bodySmall!.fontSize,
                  fontWeight: themeData.textTheme.bodySmall!.fontWeight,
                  color: themeData.colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
        if (_isToBeReviewed(memoCard, pendingPayload))
          Positioned(
            top: -5,
            right: -5,
            child: Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }

  bool _isToBeReviewed(MemoCard memoCard, String? pendingPayload) {
    return pendingPayload != null &&
        memoCard.id ==
            NotificationsState.extractMemoCardIdFromPayload(pendingPayload);
  }
}
