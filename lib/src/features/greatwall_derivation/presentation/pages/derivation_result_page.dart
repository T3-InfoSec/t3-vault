import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/settings/presentation/pages/settings_page.dart';
import '../../../landing/presentation/pages/home_page.dart';
import '../blocs/greatwall/greatwall_bloc.dart';
import '../blocs/greatwall/greatwall_state.dart';
import 'tree_inputs_page.dart';

class DerivationResultPage extends StatelessWidget {
  static const routeName = 'derivation_result';

  const DerivationResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GreatWall Derivation Result'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // TODO: re-initialize the protocol derivation process.
            context.go('/${TreeInputsPage.routeName}');
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
                      // TODO: re-initialize the protocol derivation process.
                      // context.read<GreatWallBloc>().add(Restart()); 
                      context.go(HomePage.routeName);
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
