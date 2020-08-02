import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:summariser_client/services/summary_service.dart';
import 'package:summariser_client/views/summary_list.dart';

void setupLocator() {
  GetIt.I.registerLazySingleton(() => SummariesService());
}

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Article Summariser',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SummaryList(),
    );
  }
}
