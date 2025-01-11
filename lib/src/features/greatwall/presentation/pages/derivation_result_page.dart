import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:t3_crypto_objects/crypto_objects.dart';
import 'package:t3_memassist/memory_assistant.dart';
import 'package:t3_vault/src/common/cryptography/presentation/widgets/input_key_error_promt_widget.dart';
import 'package:t3_vault/src/common/cryptography/presentation/widgets/password_promt_widget.dart';

import 'package:t3_vault/src/features/greatwall/presentation/widgets/deckname_promt_widget.dart';
import 'package:t3_vault/src/common/cryptography/presentation/widgets/eka_promt_widget.dart';
import 'package:t3_vault/src/features/greatwall/states/derivation_state.dart';
import 'package:uuid/uuid.dart';
import '../../../../common/settings/presentation/pages/settings_page.dart';
import '../../../memorization_assistant/presentation/blocs/blocs.dart';
import '../blocs/blocs.dart';

class DerivationResultPage extends StatelessWidget {
  static const routeName = 'derivation_result';

  const DerivationResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.derivationResultPageTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.go('/${SettingsPage.routeName}');
            },
          ),
        ],
      ),
      body: Center(
        child: BlocBuilder<GreatWallBloc, GreatWallState>(
          builder: (context, state) {
            if (state is GreatWallFinishSuccess) {
              var derivedEntropy = Argon2DerivationService()
                  .deriveWithLowMemory(
                      EntropyBytes(state.derivationHashResult));
              var formosa = Formosa(derivedEntropy.value, FormosaTheme.bip39);
              final ka = KA(formosa);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Text(AppLocalizations.of(context)!.kaResult),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: TextEditingController(
                              text: ka.hexadecimalValue),
                          readOnly: true,
                          obscureText: !state.isKAVisible,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(
                                state.isKAVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                context
                                    .read<GreatWallBloc>()
                                    .add(GreatWallKAVisibilityToggled());
                              },
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () {
                          Clipboard.setData(
                              ClipboardData(text: ka.hexadecimalValue));
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      // Copy the seed to the clipboard for a limited time
                      Clipboard.setData(ClipboardData(
                          text: ka.formosa.mnemonic));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(AppLocalizations.of(context)!
                                .seedCopiedToClipboard)),
                      );

                      // Allow copying for 10 seconds, then disable
                      await Future.delayed(const Duration(seconds: 10));

                      // Clear clipboard after the time limit
                      Clipboard.setData(const ClipboardData(text: ''));
                    },
                    child:
                        Text(AppLocalizations.of(context)!.generateAndCopySeed),
                  ),
                  const SizedBox(height: 10),
                  BlocBuilder<MemoCardSetBloc, MemoCardSetState>(
                    builder: (context, memoCardSetState) {
                      return ElevatedButton(
                        onPressed: (memoCardSetState is MemoCardSetAddSuccess)
                            ? null
                            : () async {
                                Eka eka = Eka();
                                final String? optionalEka = await showDialog<String>(
                                  context: context,
                                  builder: (context) =>
                                      EKAPromptWidget(eka: eka.key),
                                );
                                if (!context.mounted) return;
                                if (optionalEka != null) {
                                  final deckName = await showDialog<String>(
                                    context: context,
                                    builder: (context) =>
                                        const DecknamePromtWidget(),
                                  );
                                  if (!context.mounted) return;
                                  if (deckName != null) {
                                    String? enteredEKA = await showDialog<String>(
                                      context: context,
                                      builder: (context) => const PasswordPrompt(),
                                    );
                                    if (!context.mounted) return;
                                    if (enteredEKA != eka.key){
                                      await showDialog<String>(
                                        context: context,
                                        builder: (context) => const InputKeyErrorPromtWidget(),
                                      );
                                    } else {
                                      context.read<MemoCardSetBloc>().add(MemoCardSetCardsAdding());
                                      final deckId = const Uuid().v4();
                                      final deck = Deck(deckId, deckName);

                                      final sa0Mnemonic = Provider.of<DerivationState>(
                                          context,
                                          listen: false).sa0Mnemonic;
                                      final sa0 = Sa0(Formosa.fromMnemonic(sa0Mnemonic));
                                      final ciphertext = await eka.encrypt(sa0);

                                      List<MemoCard> memoCards = [];

                                      memoCards.addAll([
                                        EkaMemoCard(eka: 'Can you remember where you saved eka\'s backup?', deck: deck),
                                        Sa0MemoCard(
                                            encryptedSa0: base64Encode(ciphertext.concatenation()),
                                            deck: deck)
                                      ]);

                                      if (!context.mounted) return;
                                      final tacitKnowledge = Provider.of<DerivationState>(
                                          context,
                                          listen: false).tacitKnowledge;
                                      
                                      for (int i = 1; i <= state.treeDepth; i++) {
                                        final node = Node(state.savedNodes[i - 1]);
                                        final ciphertextNode = await eka.encrypt(node);   
                                        final selectedNode = Node(state.savedNodes[i]);
                                        final ciphertextSelectedNode = await eka.encrypt(selectedNode);
                                        memoCards.add(TacitKnowledgeMemoCard(
                                            knowledge: {
                                              'level': i,
                                              'node': base64Encode(ciphertextNode.concatenation()),
                                              'selectedNode': base64Encode(ciphertextSelectedNode.concatenation()),
                                              'treeArity': state.treeArity,
                                              'treeDepth': state.treeDepth,
                                              'tacitKnowledge': tacitKnowledge,
                                            },
                                            deck: deck,
                                            title: 'Derivation Level $i Card'));
                                      }
                                      if (!context.mounted) return;
                                      context.read<MemoCardSetBloc>().add(
                                          MemoCardSetCardsAdded(
                                              memoCards: memoCards));
                                    }
                                  }
                                }
                              },
                        child: Text(
                            AppLocalizations.of(context)!.saveDerivationCards),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  BlocBuilder<MemoCardSetBloc, MemoCardSetState>(
                    builder: (context, memoCardSetState) {
                      return ElevatedButton(
                        onPressed: (memoCardSetState is MemoCardSetAdding) 
                        ? () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(AppLocalizations.of(context)!.savingInProgress),
                              duration: const Duration(seconds: 10),
                            ),
                          );
                        }
                        : () {
                          context.read<MemoCardSetBloc>().add(MemoCardSetUnchanged());
                          context.read<GreatWallBloc>().add(GreatWallReset());
                          context.pop();
                        },
                        child: (memoCardSetState is MemoCardSetAdding)
                          ? const CircularProgressIndicator()
                          : Text(AppLocalizations.of(context)!.reset),
                      );
                    },
                  ),
                ],
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
