import 'package:flutter/material.dart';
import '../models/weather_forecast.dart';
import 'main_screen.dart';

class FavDetailScreen extends StatelessWidget {
  final WeatherModel weatherModel;
  const FavDetailScreen({Key? key, required this.weatherModel}) : super(key: key);


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.blue,),
          onPressed: () {
            Navigator.pop(context); // Pop the current route to go back
          },
        ),
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Favourite City Detail',
            style: TextStyle(
              color: Colors.blue, // Set text color to black
            ),
          ),
        ),
        backgroundColor: Colors.white, // Set background color to white
      ),
      body: SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CityInfoWidget(weather: weatherModel),
            const SizedBox(height: 15),
            WindWidget(weather: weatherModel),
            const SizedBox(height: 15),
            BarometerWidget(weather: weatherModel),
            const SizedBox(height: 15),
            ForecastFutureDay(weather: weatherModel),
          ]),
      ),
      )
    );
  }
}