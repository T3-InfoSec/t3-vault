import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bloc.dart';

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
              const Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Welcome to T3-Vault",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      // color: tabColor,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Your Key, Your Vault! T3-Vault is powered by an '
                    'innovative protocol for providing Kerckhoffian, 0-trust '
                    ' and deviceless coercion-resistance in self-custody.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11),
                  ),
                ],
              ),
              Image.asset("assets/images/flutter_logo.png"),
              Column(
                children: [
                  const Text(
                    "Read our Privacy Policy, 'AGREE AND CONTINUE'"
                    " to accept the Terms of Service.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    child: const Text('Learn More...'),
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
                    child: const Text('AGREE AND CONTINUE'),
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
