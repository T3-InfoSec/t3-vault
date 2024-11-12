import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:great_wall/great_wall.dart';
import 'package:provider/provider.dart';
import 'package:t3_memassist/memory_assistant.dart';

import 'package:t3_vault/src/common/cryptography/usecases/bip_39_generator.dart';
import 'package:t3_vault/src/common/cryptography/usecases/encryption_service.dart';
import 'package:t3_vault/src/common/cryptography/usecases/key_generator.dart';
import 'package:t3_vault/src/features/greatwall/presentation/widgets/deckname_promt_widget.dart';
import 'package:t3_vault/src/features/greatwall/presentation/widgets/eka_promt_widget.dart';
import 'package:t3_vault/src/features/greatwall/states/derivation_state.dart';
import 'package:uuid/uuid.dart';
import '../../../../common/settings/presentation/pages/settings_page.dart';
import '../../../memorization_assistant/presentation/blocs/blocs.dart';
import '../blocs/blocs.dart';

class DerivationResultPage extends StatelessWidget {
  static const routeName = 'derivation_result';

  final encryptionService = EncryptionService();
  final bip39generator = Bip39generator();
  final keyGenerator = KeyGenerator();

  DerivationResultPage({super.key});

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
                              text: state.derivationHashResult),
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
                              ClipboardData(text: state.derivationHashResult));
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      // Copy the seed to the clipboard for a limited time
                      Clipboard.setData(ClipboardData(
                          text: bip39generator.deriveTwelveWordsSeed(
                              state.derivationHashResult)));
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
                                final generatedKey =
                                    keyGenerator.generateHexadecimalKey();
                                final eka = await showDialog<String>(
                                  context: context,
                                  builder: (context) =>
                                      EKAPromptWidget(eka: generatedKey),
                                );
                                if (!context.mounted) return;
                                if (eka != null) {
                                  final deckName = await showDialog<String>(
                                    context: context,
                                    builder: (context) =>
                                        const DecknamePromtWidget(),
                                  );
                                  if (!context.mounted) return;
                                  if (deckName != null) {
                                    context.read<MemoCardSetBloc>().add(MemoCardSetCardsAdding());
                                    final deckId = const Uuid().v4();
                                    final deck = Deck(deckId, deckName);

                                    final pa0 = Provider.of<DerivationState>(
                                        context,
                                        listen: false)
                                    .password;
                                    final encryptedPA0 = await encryptionService
                                        .encrypt(pa0, eka);

                                    List<MemoCard> memoCards = [];

                                    memoCards.addAll([
                                      EkaMemoCard(eka: 'question', deck: deck),
                                      Pa0MemoCard(
                                          pa0: base64Encode(encryptedPA0),
                                          deck: deck)
                                    ]);
                                    if (!context.mounted) return;
                                    final tacitKnowledge = Provider.of<DerivationState>(
                                        context,
                                        listen: false)
                                    .tacitKnowledge;
                                    
                                    for (int i = 1; i <= state.treeDepth; i++) {
                                      var encryptedNode =
                                          await encryptionService.encrypt(
                                              base64Encode(
                                                  state.savedNodes[i - 1]),
                                              eka);
                                      var encryptedSelectedNode =
                                          await encryptionService.encrypt(
                                              base64Encode(state.savedNodes[i]),
                                              eka);
                                      memoCards.add(TacitKnowledgeMemoCard(
                                          knowledge: {
                                            'level': i,
                                            'node': base64Encode(encryptedNode),
                                            'selectedNode': base64Encode(
                                                encryptedSelectedNode),
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
                              duration: const Duration(seconds: 2),
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
