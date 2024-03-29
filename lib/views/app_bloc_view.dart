import 'package:blocstatemanagement/bloc/app_bloc.dart';
import 'package:blocstatemanagement/bloc/app_state.dart';
import 'package:blocstatemanagement/bloc/bloc_events.dart';
import 'package:blocstatemanagement/extension/start_with.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocView<T extends AppBloc> extends StatelessWidget {
  const AppBlocView({super.key});

  void startUpdatingBloc(BuildContext context) {
    Stream.periodic(const Duration(seconds: 10),
            (_) => const LoadNextUrlEvent()
    ).startWith(const LoadNextUrlEvent()).forEach((event) {
      context.read<T>().add(
          event
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    startUpdatingBloc(context);
    return Expanded(
      child: BlocBuilder<T, AppState>(builder: (context, appState) {
        if (appState.error != null) {
          return const Text('An error occured. Try Again in a moment!');
        } else if (appState.data != null) {
          return Image.memory(appState.data!, fit: BoxFit.fitHeight,);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      }),
    );
  }
}
