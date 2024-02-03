import 'package:blocstatemanagement/models.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class NotesApiProtocol {
  const NotesApiProtocol();

  Future<Iterable<Note>?> getNotes({required LoginHandle loginHandle});
}

@immutable
class NotesApi implements NotesApiProtocol {
  @override
  getNotes({required LoginHandle loginHandle}) => Future.delayed(
      const Duration(seconds: 2),
      () => loginHandle == const LoginHandle.fooBar() ? mockNote : null);
}
