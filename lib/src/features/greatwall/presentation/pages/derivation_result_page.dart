import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/settings/presentation/pages/settings_page.dart';
import '../../../landing/presentation/pages/home_page.dart';
import '../../../memorization_assistant/presentation/blocs/blocs.dart';
import '../blocs/blocs.dart';

class DerivationResultPage extends StatelessWidget {
  static const routeName = 'derivation_result';

  const DerivationResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final previousRoute = (GoRouterState.of(context).extra
        as Map<String, String>)['previousRoute'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('GreatWall Derivation Result'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.read<GreatWallBloc>().add(GreatWallReset());
            if (previousRoute != null) {
              context.go('/$previousRoute');
            } else {
              Navigator.of(context).pop();
            }
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
                    onPressed: () {
                      context
                          .read<MemoCardSetBloc>()
                          .add(MemoCardSetUnchanged());
                      context.read<GreatWallBloc>().add(GreatWallReset());
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
