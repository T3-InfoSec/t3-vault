import 'package:flutter/material.dart';
import 'package:t3_crypto_objects/crypto_objects.dart';
import 'package:t3_vault/src/common/cryptography/presentation/widgets/eka_input_promt_widget.dart';
import 'package:t3_vault/src/common/cryptography/presentation/widgets/eka_new_deriation_question_promt_widget.dart';
import 'package:t3_vault/src/common/cryptography/presentation/widgets/eka_promt_widget.dart';
import 'package:t3_vault/src/common/cryptography/presentation/widgets/input_key_error_promt_widget.dart';

class EkaFlowHandler {
  static Future<Eka?> showEkaFlow(BuildContext context) async {
    String? optionalEka;
    // Ask if it's a new derivation
    final bool? isANewDerivation = await showDialog<bool>(
      context: context,
      builder: (context) => const EkaNewDeriationQuestionPromtWidget(),
    );

    if (isANewDerivation == null || !isANewDerivation) { // Not a new derivation, prompt for existing EKA
      if (!context.mounted) return null;
      optionalEka = await showDialog<String>(
        context: context,
        builder: (context) => const EkaInputPromtWidget(),
      );
    } else { // It's a new derivation, generate and show EKA
      Eka eka = Eka();

      // Prompt for optional EKA
      if (!context.mounted) return null;
      optionalEka = await showDialog<String>(
        context: context,
        builder: (context) => EKAPromptWidget(eka: eka.key),
      );

      // Ask user to input EKA
      if (!context.mounted) return null;
      final String? enteredEka = await showDialog<String>(
        context: context,
        builder: (context) => const EkaInputPromtWidget(),
      );

      // Validate entered EKA
      if (enteredEka != eka.key) {
        optionalEka = null;
        if (!context.mounted) return null;
        await showDialog<void>(
          context: context,
          builder: (context) => const InputKeyErrorPromtWidget(),
        );
      }
    }

    return optionalEka != null ? Eka.fromKey(optionalEka) : null;
  }
}
