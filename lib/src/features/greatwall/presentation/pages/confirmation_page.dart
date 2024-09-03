import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/settings/presentation/pages/settings_page.dart';
import '../blocs/blocs.dart';
import 'derivation_level_page.dart';

class ConfirmationPage extends StatelessWidget {
  static const routeName = 'confirmation';

  const ConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final previousRoute = (GoRouterState.of(context).extra
        as Map<String, String>)['previousRoute'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmation'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
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
      body: BlocBuilder<GreatWallBloc, GreatWallState>(
        builder: (context, state) {
          if (state is GreatWallDeriveInProgress) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is GreatWallInitialSuccess) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Tacit Knowledge',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(state.tacitKnowledgeType.value),
                  const SizedBox(height: 20),
                  const Text(
                    'Tree Arity',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('${state.treeArity}'),
                  const SizedBox(height: 20),
                  const Text(
                    'Tree Depth',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('${state.treeDepth}'),
                  const SizedBox(height: 20),
                  ...state.tacitKnowledgeConfigs.entries.map((entry) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          entry.key,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('${entry.value}'),
                        const SizedBox(height: 20),
                      ],
                    );
                  }),
                  const Text(
                    'Password',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Text('****'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Future.delayed(
                        const Duration(seconds: 1),
                        () {
                          if (!context.mounted) return;
                          context
                              .read<GreatWallBloc>()
                              .add(GreatWallDerivationStarted());
                          context.go('/${DerivationLevelPage.routeName}');
                        },
                      );
                    },
                    child: const Text('Confirm'),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No parameters available.'));
          }
        },
      ),
    );
  }
}
