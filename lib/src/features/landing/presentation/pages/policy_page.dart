import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/settings/presentation/pages/settings_page.dart';
import '../bloc/bloc.dart';

/// Displays a list of SampleItems.
class PolicyPage extends StatelessWidget {
  static const routeName = 'policy';

  const PolicyPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Policies'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate to the settings page.
            AgreementBloc bloc = BlocProvider.of<AgreementBloc>(context);
            bloc.add(AgreementRejected());
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            // iconSize: 300,
            onPressed: () {
              // Navigate to the settings page.
              context.go('/${SettingsPage.routeName}');
            },
          ),
        ],
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            // TODO: Add policy and terms agreement
            'dsfdsjfdsljfldsjflkds dsjfldskjflds fdskjflds fdsjfl dsfsdfsdfsf'
            ' dslfalfjdskljflds lfdsljfldsfsd fsdjfl sdfjasl dfjlsf sdfsdfdsd'
            ' sdfdsfdsfds dskjfldsjf sdlfjdsljfl sdslkjfsdl dslfjsdl dsfsddf.',
          ),
        ),
      ),
    );
  }
}
