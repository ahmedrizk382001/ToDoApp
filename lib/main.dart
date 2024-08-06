import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/Layout/HomeScreen/HomeScreen.dart';
import 'Shared/Cubit/BlocObserver.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
