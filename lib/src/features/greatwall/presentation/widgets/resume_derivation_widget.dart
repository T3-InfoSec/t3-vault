import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:t3_crypto_objects/crypto_objects.dart';
import 'package:t3_vault/src/common/cryptography/presentation/widgets/input_key_error_promt_widget.dart';
import 'package:t3_vault/src/common/cryptography/presentation/widgets/eka_input_promt_widget.dart';
import 'package:t3_vault/src/features/greatwall/presentation/blocs/blocs.dart';
import 'package:t3_vault/src/features/greatwall/presentation/pages/confirmation_page.dart';
import 'package:t3_vault/src/features/greatwall/presentation/pages/knowledge_types_page.dart';
import 'package:t3_vault/src/features/landing/presentation/pages/home_page.dart';
import 'package:t3_vault/src/features/memorization_assistant/domain/entities/intermediate_derivation_state_entity.dart';
import 'package:t3_vault/src/features/memorization_assistant/domain/entities/ongoing_derivation_entity.dart';

class ResumeDerivationWidget extends StatelessWidget {
  final OngoingDerivationEntity ongoingDerivationEntity;

  const ResumeDerivationWidget(
      {super.key, required this.ongoingDerivationEntity});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Resume ongoing derivation"),
      content: const Text(
          "There is an ongoing derivation. Would you like to resume it?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("No"),
        ),
        TextButton(
          onPressed: () async {
            String? key = await showDialog<String>(
              context: context,
              builder: (context) => const EkaInputPromtWidget(),
            );
            if (key != null &&
                key.isNotEmpty &&
                await isValid(key, ongoingDerivationEntity)) {
              List<Sa1i> intermediateDerivationStates = [];
              for (IntermediateDerivationStateEntity intermediateDerivationStateEntity
                  in ongoingDerivationEntity.intermediateDerivationStates) {
                intermediateDerivationStates.add(Sa1i(
                    await getIntermediateSateValue(
                        intermediateDerivationStateEntity.encryptedValue, key),
                    intermediateDerivationStateEntity.currentIteration,
                    intermediateDerivationStateEntity.totalIterations));
              }
              if (!context.mounted) return;
              context.read<GreatWallBloc>().add(
                    GreatWallInitialized(
                      treeArity: ongoingDerivationEntity.treeArity,
                      treeDepth: ongoingDerivationEntity.treeDepth,
                      timeLockPuzzleParam:
                          ongoingDerivationEntity.timeLockPuzzleParam,
                      tacitKnowledge: ongoingDerivationEntity.tacitKnowledge,
                      sa0Mnemonic: ongoingDerivationEntity.encryptedSa0,
                      intermediateDerivationStates:
                          intermediateDerivationStates,
                    ),
                  );

              Navigator.of(context).pop();
              context.go(
                '/${KnowledgeTypesPage.routeName}/${HomePage.routeName}/'
                '${ConfirmationPage.routeName}',
              );
            } else {
              if (!context.mounted) return;
              await showDialog<String>(
                context: context,
                builder: (context) => const InputKeyErrorPromtWidget(),
              );
            }
          },
          child: const Text("Yes"),
        ),
      ],
    );
  }

  Future<bool> isValid(
      String key, OngoingDerivationEntity ongoingDerivationEntity) async {
    Eka eka = Eka.fromKey(key);
    String ciphertext =
        ongoingDerivationEntity.intermediateDerivationStates[0].encryptedValue;
    try {
      await eka.decrypt(base64Decode(ciphertext));
      return true;
    } catch (e) {
      debugPrint('Error decryting intermediate state value: $e');
      return false;
    }
  }

  Future<Uint8List> getIntermediateSateValue(
      String cipherText, String key) async {
    final ephemeralKA = Eka.fromKey(key);

    var critical = await ephemeralKA.decrypt(base64Decode(cipherText));
    return critical.value;
  }
}
