import 'package:blocstatemanagement/bloc/bloc_actions.dart';
import 'package:blocstatemanagement/bloc/person.dart';
import 'package:blocstatemanagement/bloc/persons_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

const mockedPersons1 = [
  Person(name: 'Foo', age: 20),
  Person(name: 'Bar', age: 18)
];

const mockedPersons2 = [
  Person(name: 'Foo2', age: 20),
  Person(name: 'Baz', age: 48)
];

Future<Iterable<Person>> mockGetPersons1(String _) =>
    Future.value(mockedPersons1);

Future<Iterable<Person>> mockGetPersons2(String _) =>
    Future.value(mockedPersons2);

void main() {
  group("Testing bloc", () {
    late PersonsBloc bloc;

    setUp(() {
      bloc = PersonsBloc();
    });

    blocTest<PersonsBloc, FetchResult?>(
      'Test initial state',
      build: () => bloc,
      verify: (bloc) => expect(bloc.state, null),
    );

    blocTest('Mock retrieving person from first iteratable',
        build: () => bloc,
        act: (bloc) {
          bloc.add(
              LoadPersonAction(url: 'dummy_url_2', loader: mockGetPersons2));
          bloc.add(
              LoadPersonAction(url: 'dummy_url_2', loader: mockGetPersons2));
        },
        expect: () => [
          FetchResult(persons: mockedPersons2, isRetrievedFromCache: false),
          FetchResult(persons: mockedPersons2, isRetrievedFromCache: true)
        ]
    );
  });
}
