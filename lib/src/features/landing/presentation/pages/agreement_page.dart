import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../blocs/blocs.dart';

/// Displays a list of SampleItems.
class AgreementPage extends StatelessWidget {
  static const routeName = 'agreement';

  const AgreementPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.appWelcome,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      // color: tabColor,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(AppLocalizations.of(context)!.introducing,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 11),
                  ),
                ],
              ),
              Image.asset("assets/images/flutter_logo.png"),
              Column(
                children: [
                  Text(AppLocalizations.of(context)!.readPolicy,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    child: Text(AppLocalizations.of(context)!.learnMore),
                    onPressed: () {
                      AgreementBloc bloc =
                          BlocProvider.of<AgreementBloc>(context);
                      bloc.add(AgreementSuspended());
                    },
                    // style: ,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    child: Text(AppLocalizations.of(context)!.agreeAndContinue),
                    onPressed: () {
                      AgreementBloc bloc =
                          BlocProvider.of<AgreementBloc>(context);
                      bloc.add(AgreementAccepted());
                    },
                    // style: ,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
