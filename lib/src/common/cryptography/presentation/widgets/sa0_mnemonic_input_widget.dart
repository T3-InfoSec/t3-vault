import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mooncake/mooncake.dart';
import 'package:t3_crypto_objects/crypto_objects.dart';
import 'package:t3_vault/src/features/greatwall/presentation/blocs/blocs.dart';

import 'sa0_mnemonic_promt_widget.dart';

class Sa0MnemonicInputWidget extends StatelessWidget {
  final TextEditingController passwordController;

  const Sa0MnemonicInputWidget({
    super.key,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> isVisible = ValueNotifier<bool>(false);

    return BlocBuilder<FormosaBloc, FormosaState>(
      builder: (context, state) {
        bool isValid = false;
        if (state is FormosaMnemonicValidation) {
          isValid = state.isValid;
        }

        return Row(
          children: [
            Expanded(
              child: ValueListenableBuilder<bool>(
                valueListenable: isVisible,
                builder: (context, isVisibleValue, _) {
                  return TextField(
                    controller: passwordController,
                    obscureText: !isVisibleValue,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.password,
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              isVisibleValue
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              isVisible.value = !isVisible.value;
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.sync),
                            onPressed: () async {
                              String mnemonic = Formosa.fromRandomWords(
                                      wordCount: 6,
                                      formosaTheme: FormosaTheme.bip39)
                                  .mnemonic;
                              await showDialog<String>(
                                context: context,
                                builder: (context) => Sa0MnemonicPromtWidget(
                                  sa0Mnemonic: mnemonic,
                                ),
                              );
                              if (mnemonic.isNotEmpty) {
                                passwordController.text = mnemonic;
                                if (!context.mounted) return;
                                context.read<FormosaBloc>().add(
                                      FormosaMnemonicChanged(
                                          mnemonic: mnemonic),
                                    );
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.circle),
                            onPressed: () async {
                              String? mnemonic = await showDialog<String?>(
                                context: context,
                                builder: (context) => const MooncakeView(),
                              );
                              if (mnemonic != null) {
                                passwordController.text = mnemonic;
                                if (!context.mounted) return;
                                context.read<FormosaBloc>().add(
                                      FormosaMnemonicChanged(
                                          mnemonic: mnemonic),
                                    );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    onChanged: (value) {
                      context
                          .read<FormosaBloc>()
                          .add(FormosaMnemonicChanged(mnemonic: value));
                    },
                  );
                },
              ),
            ),
            if (!isValid) const Icon(Icons.warning, color: Colors.orange),
          ],
        );
      },
    );
  }
}
