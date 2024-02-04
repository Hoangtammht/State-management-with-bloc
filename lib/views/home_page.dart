import 'package:blocstatemanagement/bloc/bottom_bloc.dart';
import 'package:blocstatemanagement/bloc/top_bloc.dart';
import 'package:blocstatemanagement/models/constants.dart';
import 'package:blocstatemanagement/views/app_bloc_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: MultiBlocProvider(
          providers: [
            BlocProvider<TopBloc>(
                create: (_) =>
                    TopBloc(
                        waitBeforeLoading: const Duration(seconds: 3),
                        urls: images)),
            BlocProvider<BottomBloc>(create: (_) =>
                BottomBloc(waitBeforeLoading: const Duration(seconds: 3),
                    urls: images))
          ],
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: const [
              AppBlocView<TopBloc>(),
              AppBlocView<BottomBloc>()
            ],
          ),
        ),
      ),
    );
  }
}
