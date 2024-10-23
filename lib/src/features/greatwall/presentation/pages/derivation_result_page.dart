import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:t3_formosa/formosa.dart';

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
        title: const Text('GreatWall Derivation Result'),
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
                  const Text('KA Result:'),
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
                      Clipboard.setData(ClipboardData(text: bip39Derivation(state.derivationHashResult)));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Seed copied to clipboard')),
                      );

                      // Allow copying for 10 seconds, then disable
                      await Future.delayed(const Duration(seconds: 10));

                      // Clear clipboard after the time limit
                      Clipboard.setData(const ClipboardData(text: ''));
                    },
                    child: const Text('Generate and copy seed'),
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
  
  String bip39Derivation(String key) {
    // Convert the derivation hash result to a Uint8List
    Uint8List derivationHashResultBytes = Uint8List.fromList(
      key
      .codeUnits
      .take(16)
      .toList(), // Take the first 16 bytes
    );

    Formosa formosa = Formosa(formosaTheme: FormosaTheme.bip39);
    return formosa.toFormosa(derivationHashResultBytes);
  }
}
