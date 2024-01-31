import 'dart:convert';
import 'dart:io';
import 'package:blocstatemanagement/bloc/bloc_actions.dart';
import 'package:blocstatemanagement/bloc/person.dart';
import 'package:blocstatemanagement/bloc/persons_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as devtools show log;

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
      home: BlocProvider(create: (_) => PersonsBloc(), child: const HomePage()),
    );
  }
}

Future<Iterable<Person>> getPerson(String url) => HttpClient()
    .getUrl(Uri.parse(url))
    .then((req) => req.close())
    .then((resp) => resp.transform(utf8.decoder).join())
    .then((str) => json.decode(str) as List<dynamic>)
    .then((list) => list.map((e) => Person.fromJson(e)));


extension Subscript<T> on Iterable<T> {
  T? operator [](int index) => length > index ? elementAt(index) : null;
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late final Bloc myBloc;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Row(
            children: [
              TextButton(
                  onPressed: () {
                    final foo = context
                        .read<PersonsBloc>()
                        .add(const LoadPersonAction(url: person1Url, loader: getPerson));
                  },
                  child: Text("Load json #1")),
              TextButton(
                  onPressed: () {
                    final foo = context
                        .read<PersonsBloc>()
                        .add(const LoadPersonAction(url: person2Url, loader: getPerson));
                  },
                  child: Text("Load json #2")),
            ],
          ),
          BlocBuilder<PersonsBloc, FetchResult?>(
              buildWhen: (previousResult, currentResult) {
            return previousResult?.persons != currentResult?.persons;
          }, builder: (context, fetchResult) {
            fetchResult?.log();
            final persons = fetchResult?.persons;
            print(persons);
            if (persons == null) {
              return const SizedBox();
            }
            return Expanded(
              child: ListView.builder(
                  itemCount: persons.length,
                  itemBuilder: (context, index) {
                    final person = persons[index]!;
                    return ListTile(
                      title: Text(
                        person.name,
                      ),
                    );
                  }),
            );
          })
        ],
      ),
    );
  }
}
