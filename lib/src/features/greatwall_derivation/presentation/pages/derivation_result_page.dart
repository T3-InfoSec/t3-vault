import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:t3_vault/src/features/greatwall_derivation/presentation/bloc/greatwall/greatwall_bloc.dart';
import 'package:t3_vault/src/features/greatwall_derivation/presentation/bloc/greatwall/greatwall_state.dart';

import 'package:t3_vault/src/features/greatwall_derivation/presentation/pages/tree_inputs_page.dart';
import 'package:t3_vault/src/features/landing/presentation/pages/home_page.dart';
import 'package:t3_vault/src/core/settings/presentation/pages/settings_page.dart';

class DerivationResultPage extends StatelessWidget {
  const DerivationResultPage({super.key});

  static const routeName = 'derivation_result';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GreatWall Derivation Result'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go(
                '/${TreeInputsPage.routeName}'); // TODO: re-initialize the protocol derivation process.
          },
        ),
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
            if (state is GreatWallFinished) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  const Text('KA Result:'),
                  const SizedBox(height: 10),
                  TextField(
                    controller:
                        TextEditingController(text: state.derivationHashResult),
                    readOnly: true,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // context.read<GreatWallBloc>().add(Restart()); // TODO: re-initialize the protocol derivation process.
                      context.go(HomePage.routeName);
                    },
                    child: const Text('Reset'),
                  ),
                ],
              );
            }
            return const Center(
                child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
