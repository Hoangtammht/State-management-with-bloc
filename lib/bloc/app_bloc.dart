import 'package:bloc/bloc.dart';
import 'package:blocstatemanagement/bloc/actions.dart';
import 'package:blocstatemanagement/bloc/app_state.dart';
import 'package:blocstatemanagement/models.dart';

import '../apis/login_api.dart';
import '../apis/notes_api.dart';

class AppBloc extends Bloc<AppAction, AppState> {
  final LoginApiProtocol loginApi;
  final NotesApiProtocol notesApi;

  AppBloc({required this.loginApi, required this.notesApi})
      : super(const AppState.empty()) {
    on<LoginAction>((event, emit) async {
      emit(const AppState(
          isLoading: true,
          loginErrors: null,
          loginHandle: null,
          fetchedNotes: null));

      final loginHandle =
          await loginApi.login(email: event.email, password: event.password);

      emit(AppState(
          isLoading: false,
          loginErrors: loginHandle == null ? LoginErrors.invalidHandle : null,
          loginHandle: loginHandle,
          fetchedNotes: null));
    });

    on<LoadNotesAction>((event, emit) async {
      emit(AppState(
          isLoading: true,
          loginErrors: null,
          loginHandle: state.loginHandle,
          fetchedNotes: null));

      final loginHandle = state.loginHandle;
      if (loginHandle != const LoginHandle.fooBar()) {
        emit(AppState(
            isLoading: false,
            loginErrors: LoginErrors.invalidHandle,
            loginHandle: loginHandle,
            fetchedNotes: null));

        return;
      }
      //we have a valid login handle and want to fetch notes
      final notes = await notesApi.getNotes(loginHandle: loginHandle!);

      emit(AppState(
          isLoading: false,
          loginErrors: null,
          loginHandle: loginHandle,
          fetchedNotes: notes));
    });
  }
}
