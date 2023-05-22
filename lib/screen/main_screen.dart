
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

import '../cubit/weather_cubit.dart';
import '../models/weather_forecast.dart';
import '../utils/constants.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _ViewWidget(),
    );
  }
}


class _ViewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          BlocConsumer<WeatherCubit, WeatherState>(builder: (context, state) {
            if (state is WeatherInitial) {
              return const HeaderWidget();
            } else if (state is WeatherLoading) {
              return const Center(
                  child: SpinKitCubeGrid(color: Colors.blue, size: 80));
            } else if (state is WeatherLoaded) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const HeaderWidget(),
                      const SizedBox(height: 10),
                      CityInfoWidget(weather: state.weather),
                      const SizedBox(height: 15),
                      favouriteButton(context, state.weather),
                      const SizedBox(height: 15),
                      WindWidget(weather: state.weather),
                      const SizedBox(height: 15),
                      BarometerWidget(weather: state.weather),
                      const SizedBox(height: 15),
                      ForecastFutureDay(weather: state.weather),
                    ]),
              );
            } else {
              // (state is WeatherError)
              return Column(
                children: [
                  const HeaderWidget(),
                  const SizedBox(
                    height: 100,
                  ),
                  appText(
                      size: 16,
                      text: 'An error has occurred or',
                      color: Colors.red),
                  appText(
                      size: 16,
                      text: 'May be no internet connection.',
                      color: Colors.red),
                ],
              );
            }
          }, listener: (context, state) {
            if (state is WeatherError) {
              showSnackBar(context, state.message);
            }
          }),
        ],
      ),
    );
  }
}

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onSubmitted: (value) => context.read<WeatherCubit>().getWeather(value),
              decoration: InputDecoration(
                filled: true,
                fillColor: bgGreyColor.withAlpha(235),
                hintText: 'Search City',
                hintStyle: TextStyle(color: Colors.blue.withAlpha(135)),
                prefixIcon: IconButton(
                  icon: const Icon(Icons.search, color: Colors.blue),
                  onPressed: () => context.read<WeatherCubit>().getWeather(''),
                ),
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: bgGreyColor.withAlpha(235),
            ),
            child: IconButton(
              padding: const EdgeInsets.all(12),
              iconSize: 26,
              onPressed: () => context.read<WeatherCubit>().getWeather(''),
              icon: const Icon(Icons.location_on_outlined, color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }
}

class CityInfoWidget extends StatelessWidget {
  final WeatherModel weather;
  const CityInfoWidget({Key? key, required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var city = weather.locationName;
    var temp = weather.tempC?.round();
    var feelTemp = weather.feelslikeC;
    var windDegree = weather.windDegree;
    var url = getUrlForLocal(weather.icon.toString());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image(
          image: AssetImage(url),
          width: 80,
          height: 80,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            appText(
              size: 30,
              text: '$city',
              isBold: FontWeight.bold,
              color: primaryColor,
            ),
            RotationTransition(
              turns: AlwaysStoppedAnimation(windDegree! / 360),
              child: const Icon(Icons.north, color: primaryColor),
            )
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            appText(
              size: 70,
              text: '$temp°',
            ),
            appText(size: 20, text: '$feelTemp°', color: darkGreyColor),
          ],
        ),
      ],
    );
  }
}

class BarometerWidget extends StatelessWidget {
  final WeatherModel weather;
  const BarometerWidget({Key? key, required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var temperature = weather.tempC;
    var humidity = weather.humidity;
    var pressure = weather.pressureMb;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: appText(
              size: 20,
              color: primaryColor.withOpacity(.8),
              text: 'Barometer',
              isBold: FontWeight.bold,
            ),
          ),
          Card(
            color: bgGreyColor,
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
            child: SizedBox(
              width: double.maxFinite,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customListTile(
                    first: 'Temperature:',
                    second: ' $temperature °C',
                    icon: Icons.thermostat,
                    iconColor: Colors.orange,
                    url: '',
                  ),
                  customListTile(
                    first: 'Humidity:',
                    second: ' $humidity %',
                    icon: Icons.water_drop_outlined,
                    iconColor: Colors.blueGrey,
                    url: '',
                  ),
                  customListTile(
                    first: 'Pressure:',
                    second: ' $pressure hPa',
                    icon: Icons.speed,
                    iconColor: Colors.red[300]!,
                    url: '',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WindWidget extends StatelessWidget {
  final WeatherModel weather;
  const WindWidget({Key? key, required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var speed = weather.windKph;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: appText(
              size: 20,
              color: primaryColor.withOpacity(.8),
              text: 'Wind',
              isBold: FontWeight.bold,
            ),
          ),
          Card(
            color: bgGreyColor,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
            child: SizedBox(
              width: double.maxFinite,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customListTile(
                    text: weather.windDir.toString(),
                    first: 'Speed:',
                    second: ' $speed km/h',
                    icon: Icons.air,
                    iconColor: Colors.blue,
                    url: '',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ForecastFutureDay extends StatelessWidget {
  final WeatherModel weather;
  const ForecastFutureDay({Key? key, required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var firstDate = DateFormat.yMMMMd()
        .format(DateTime.parse(weather.dateOne.toString())); // print long date
    var secondDate = DateFormat.yMMMMd()
        .format(DateTime.parse(weather.dateTwo.toString())); // print long date
    var thirdDate = DateFormat.yMMMMd().format(
        DateTime.parse(weather.dateThree.toString())); // print long date

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: appText(
              size: 20,
              color: primaryColor.withOpacity(.8),
              text: '3-Day Forecast',
              isBold: FontWeight.bold,
            ),
          ),
          Card(
            color: bgGreyColor,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
            child: SizedBox(
              width: double.maxFinite,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  customListTile(
                    first: '',
                    second: firstDate,
                    text: "${weather.avgtempCOne} °C",
                    icon: Icons.thermostat,
                    iconColor: Colors.orange,
                    url: getUrlForLocal(weather.iconOne.toString()),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  customListTile(
                    first: '',
                    second: secondDate,
                    text: "${weather.avgtempCTwo} °C",
                    icon: Icons.water_drop_outlined,
                    iconColor: Colors.blueGrey,
                    url: getUrlForLocal(weather.iconTwo.toString()),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  customListTile(
                    first: '',
                    second: thirdDate,
                    text: "${weather.avgtempCThree} °C",
                    icon: Icons.speed,
                    iconColor: Colors.red[300]!,
                    url: getUrlForLocal(weather.iconThree.toString()),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}



String getUrlForLocal(String value) {
  List<String> parts = value.split('/');
  String url = "assets/${parts[5]}/${parts[6]}";
  return url;
}
