import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/bloc_observe.dart';
import 'layout/home_layout.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: ThemeData(scaffoldBackgroundColor: Colors.white,appBarTheme: AppBarTheme(backwardsCompatibility: false,systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.white70),)
    ),
      debugShowCheckedModeBanner: false,color: Colors.white ,
      home:  HomeLayout( ),
    );
  }
}



