import 'dart:convert';
import 'dart:io';
import 'package:blocstatemanagement/apis/login_api.dart';
import 'package:blocstatemanagement/bloc/actions.dart';
import 'package:blocstatemanagement/bloc/app_bloc.dart';
import 'package:blocstatemanagement/bloc/app_state.dart';
import 'package:blocstatemanagement/dialogs/generic_dialog.dart';
import 'package:blocstatemanagement/dialogs/loading_screen.dart';
import 'package:blocstatemanagement/models.dart';
import 'package:blocstatemanagement/views/iterable_list_view.dart';
import 'package:blocstatemanagement/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as devtools show log;

import 'apis/notes_api.dart';

extension Log on Object {
  void log() => devtools.log(toString());
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc(loginApi: LoginApi(), notesApi: NotesApi()),
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Home Page'),
            centerTitle: true,
          ),
          body: BlocConsumer<AppBloc, AppState>(
            listener: (context, appState) {
              if (appState.isLoading) {
                LoadingScreen.instance()
                    .show(context: context, text: 'Please wait ....');
              } else {
                LoadingScreen.instance().hide();
              }

              final loginError = appState.loginErrors;
              if (loginError != null) {
                showGenericDialog(
                    context: context,
                    title: 'Login Error',
                    content:
                        'Invalid email/password combination.Please try again with valid login credentials!',
                    optionBuilder: () => {'OK': true});
              }

              if (appState.isLoading == false &&
                  appState.loginErrors == null &&
                  appState.loginHandle == const LoginHandle.fooBar() &&
                  appState.fetchedNotes == null) {
                context.read<AppBloc>().add(const LoadNotesAction());
              }
            },
            builder: (context, appState) {
              final notes = appState.fetchedNotes;
              if (notes == null) {
                return LoginView(onLoginTapped: (email, password) {
                  context.read<AppBloc>().add(
                    LoginAction(email: email, password: password)
                  );
                });
              } else {
                return notes.toListView();
              }
            },
          )),
    );
  }
}
