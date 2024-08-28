import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:t3_vault/src/features/greatwall_derivation/presentation/bloc/bloc.dart';
import 'package:t3_vault/src/features/greatwall_derivation/presentation/pages/tree_inputs_page.dart';
import 'package:t3_vault/src/features/greatwall_derivation/presentation/pages/derivation_level_page.dart';

class ConfirmationPage extends StatelessWidget {
  const ConfirmationPage({super.key});

  static const routeName = 'confirmation';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmation'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/${TreeInputsPage.routeName}');
          },
        ),
      ),
      body: BlocConsumer<GreatWallBloc, GreatWallState>(
        listener: (context, state) {
          if (state is GreatWallDeriving) {
            context.read<GreatWallBloc>().add(LoadArityIndexes());
            context.go('/${DerivationLevelPage.routeName}');
          }
        },
        builder: (context, state) {
          if (state is GreatWallLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is GreatWallInitialized) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Tacit Knowledge',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(state.tacitKnowledge),
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
                  const Text(
                    'Password',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Text('****'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Future.delayed(const Duration(seconds: 1), () {
                        if (!context.mounted) return;
                        context.read<GreatWallBloc>().add(StartDerivation());
                      });
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
