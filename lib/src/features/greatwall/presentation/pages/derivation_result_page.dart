import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:t3_vault/src/common/cryptography/usecases/bip_39_generator.dart';
import '../../../../common/settings/presentation/pages/settings_page.dart';
import '../../../memorization_assistant/presentation/blocs/blocs.dart';
import '../blocs/blocs.dart';

class DerivationResultPage extends StatelessWidget {
  static const routeName = 'derivation_result';

  final bip39generator = Bip39generator();

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
                          text: bip39generator.deriveTwelveWordsSeed(state.derivationHashResult)));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(AppLocalizations.of(context)!.seedCopiedToClipboard)),
                      );

                      // Allow copying for 10 seconds, then disable
                      await Future.delayed(const Duration(seconds: 10));

                      // Clear clipboard after the time limit
                      Clipboard.setData(const ClipboardData(text: ''));
                    },
                    child: Text(AppLocalizations.of(context)!.generateAndCopySeed),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<MemoCardSetBloc>()
                          .add(MemoCardSetUnchanged());
                      context.read<GreatWallBloc>().add(GreatWallReset());
                      context.pop();
                    },
                    child: const Text('Reset'),
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
