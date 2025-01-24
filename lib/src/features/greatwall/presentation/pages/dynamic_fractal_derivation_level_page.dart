import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:great_wall/great_wall.dart';

import '../../../../common/settings/presentation/pages/settings_page.dart';
import '../blocs/blocs.dart';
import 'dynamic_fractal_renderer_page.dart';

class DynamicFractalDerivationLevelPage extends StatefulWidget {
  static const routeName = 'dynamic_fractal_derivation_level';

  const DynamicFractalDerivationLevelPage({super.key});

  @override
  State<DynamicFractalDerivationLevelPage> createState() {
    return _DynamicFractalDerivationLevelPageState();
  }
}

class _DynamicFractalDerivationLevelPageState
    extends State<DynamicFractalDerivationLevelPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.derivationLevelPageTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.read<GreatWallBloc>().add(GreatWallReset());
            Navigator.of(context).pop();
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
          if (state is GreatWallDeriveInProgress) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is GreatWallDeriveStepSuccess) {
            final hash = Choice(context.read<GreatWallBloc>().hashes[0]);
            final tacitKnowledge = state.knowledgePalettes[hash]!.knowledge! as Point<double>;
            Offset exponent = Offset(
                tacitKnowledge.x,
                tacitKnowledge.y);
            return DynamicFractalRenderer(
              exponent
            );
          } else {
            return Center(
              child: Text(AppLocalizations.of(context)!.noLevel),
            );
          }
        }),
      ),
    );
  }
}
