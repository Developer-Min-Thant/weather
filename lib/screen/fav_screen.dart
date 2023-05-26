import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


import '../models/weather_forecast.dart';
import '../utils/constants.dart';
import '../utils/database_helper.dart';
import 'fav_detail_screen.dart';

class FavScreen extends StatefulWidget {
  const FavScreen({Key? key}) : super(key: key);

  @override
  State<FavScreen> createState() => _FavScreenState();
}

class _FavScreenState extends State<FavScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Favourite City List',
            style: TextStyle(
              color: Colors.blue, // Set text color to black
            ),
          ),
        ),
        backgroundColor: Colors.white, // Set background color to white
      ),
      
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: FutureBuilder<List<WeatherModel>>(
            future: DatabaseHelper().getAllCityWeather(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final List<WeatherModel>? data = snapshot.data;
                return ListView.builder(
                  itemCount: data?.length,
                  itemBuilder: (context, index) {
                    final weatherModel = data![index];
                    return Card(
                      elevation: 3,
                      child: ListTile(
                        trailing: GestureDetector(
                          onTap: () async {
                          final result = await DatabaseHelper().removeWeather(weatherModel.locationName.toString());
                          if(result > 0) {
                            setState(() {});
                            // ignore: use_build_context_synchronously
                            showSnackBar(
                            context,
                            "Remove from Favourite Successful.");
                          } else {
                            // ignore: use_build_context_synchronously
                            showSnackBar(
                            context,
                            "Remove Unsuccessful.");
                          }
                          // refresh the builder
                        },
                        child: const Icon(Icons.favorite, color: Colors.red)),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FavDetailScreen(weatherModel: weatherModel),
                            ),
                          );
                        },
                        leading: appText(size: 16, text: weatherModel.locationName.toString(), color: darkGreyColor),
                        title: Text('${weatherModel.feelslikeC}°C'),
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return const Center(child: SpinKitCubeGrid(color: Colors.blue, size: 80));
              }
            })
        )
      )
    );
  }
}


