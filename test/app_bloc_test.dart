import 'package:blocstatemanagement/apis/login_api.dart';
import 'package:blocstatemanagement/apis/notes_api.dart';
import 'package:blocstatemanagement/bloc/actions.dart';
import 'package:blocstatemanagement/bloc/app_bloc.dart';
import 'package:blocstatemanagement/bloc/app_state.dart';
import 'package:blocstatemanagement/models.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:bloc_test/bloc_test.dart';

const Iterable<Note> mockNotes = [
  Note(title: 'Note 1'),
  Note(title: 'Note 2'),
  Note(title: 'Note 3'),
];

@immutable
class DummpNotesApi implements NotesApiProtocol {
  final LoginHandle acceptedLoginHandle;
  final Iterable<Note>? notesToReturnForAcceptedLoginHandle;

  const DummpNotesApi(
      {required this.acceptedLoginHandle,
      required this.notesToReturnForAcceptedLoginHandle});

  const DummpNotesApi.empty()
      : acceptedLoginHandle = const LoginHandle.fooBar(),
        notesToReturnForAcceptedLoginHandle = null;

  @override
  Future<Iterable<Note>?> getNotes({required LoginHandle loginHandle}) async {
    if (loginHandle == acceptedLoginHandle) {
      return notesToReturnForAcceptedLoginHandle;
    } else {
      return null;
    }
  }
}

@immutable
class DummyLoginApi implements LoginApiProtocol {
  final String acceptedEmail;
  final String acceptedPassword;
  final LoginHandle handleToReturn;

  const DummyLoginApi(
      {required this.acceptedEmail,
      required this.acceptedPassword,
      required this.handleToReturn});

  const DummyLoginApi.empty()
      : acceptedEmail = '',
        acceptedPassword = '',
        handleToReturn = const LoginHandle.fooBar();

  @override
  Future<LoginHandle?> login(
      {required String email, required String password}) async {
    if (email == acceptedEmail && password == acceptedPassword) {
      return handleToReturn;
    } else {
      return null;
    }
  }
}

void main() {
  blocTest<AppBloc, AppState>('Initial state',
      build: () => AppBloc(
            loginApi: const DummyLoginApi(
                acceptedEmail: 'foo@bar.com',
                acceptedPassword: 'foo',
                handleToReturn: LoginHandle(token: 'ABC')),
            notesApi: const DummpNotesApi.empty(),
          ),
      act: (appBloc) =>
          appBloc.add(const LoginAction(email: 'bar@bar.com', password: 'foo')),
      expect: () => [
            const AppState(
                isLoading: true,
                loginErrors: null,
                loginHandle: null,
                fetchedNotes: null),
            const AppState(
                isLoading: false,
                loginErrors: LoginErrors.invalidHandle,
                loginHandle: null,
                fetchedNotes: null)
          ]);
}
