import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/favourite_btn_cubit.dart';
import '../cubit/weather_cubit.dart';
import '../screen/my_bottom_navigation_bar.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: MultiBlocProvider(
          providers: [
            BlocProvider<WeatherCubit>(
              create: (context) => WeatherCubit(),
            ),
            BlocProvider<FavouriteBtnCubit>(
              create: (context) => FavouriteBtnCubit(),
            ),
          ],
          child: const MyBottomNavigationBar(),
        )
      ),
    );
  }
}

