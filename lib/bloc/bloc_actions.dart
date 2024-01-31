import 'package:blocstatemanagement/bloc/person.dart';
import 'package:flutter/foundation.dart' show immutable;

const person1Url = 'http://192.168.1.12:5500/persons1.json';
const person2Url = 'http://192.168.1.12:5500/persons2.json';

typedef PersonsLoader = Future<Iterable<Person>> Function(String url);

@immutable
abstract class LoadAction {
  const LoadAction();
}

@immutable
class LoadPersonAction extends LoadAction {
  final String url;
  final PersonsLoader loader;
  const LoadPersonAction({required this.url, required this.loader,}) : super();
}