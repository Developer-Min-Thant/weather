// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/favourite_btn_cubit.dart';
import '../models/weather_forecast.dart';
import 'database_helper.dart';

const primaryColor = Color(0xff2c2c2c);
const blackColor = Colors.black;
const whiteColor = Colors.white;
const greyColor = Color(0xffc4c4c4);
const bgGreyColor = Color(0xfffdfcfc);
const darkGreyColor = Color(0xff9a9a9a);

// custom Text Widget
Widget appText(
    {FontWeight isBold = FontWeight.normal,
    Color color = blackColor,
    required double size,
    required String text,
    int maxLines = 0,
    bool overflow = false,
    bool alignCenter = false}) {
  return Text(
    text,
    textAlign: alignCenter == true ? TextAlign.center : null,
    maxLines: maxLines == 0 ? null : maxLines,
    overflow: overflow == true ? TextOverflow.ellipsis : null,
    style: TextStyle(
      color: color,
      fontSize: size,
      fontWeight: isBold,
    ),
  );
}

// for displaying snackbars
showSnackBar(BuildContext context, String text, {Color color = primaryColor}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: color,
      elevation: 3,
      content: Text(text, textAlign: TextAlign.center),
      duration: const Duration(seconds: 1),
    ),
  );
}

// Custom ListTile for MainScreen
Widget customListTile({
  required String first,
  required String second,
  required IconData icon,
  required Color iconColor,
  String text = '',
  String url = '',
}) {
  return ListTile(
    trailing: appText(size: 16, text: text, color: darkGreyColor),
    leading: url == '' ? Icon(icon, color: iconColor) : 
    Image(
      image: AssetImage(url),
      width: 30,
      height: 30,
      fit: BoxFit.contain,
    ),
    title: RichText(
      maxLines: 1,
      text: TextSpan(
        children: [
          TextSpan(
            text: first,
            style: const TextStyle(
              color: darkGreyColor,
              fontSize: 16,
            ),
          ),
          TextSpan(
            text: second,
            style: const TextStyle(
              color: primaryColor,
              fontSize: 16,
            ),
          ),
        ],
      ),
    ),
  );
}

Future<void> checkFavIcon(String locationName, final favouriteBtnCubit) async {
  bool exitInLocal = await DatabaseHelper().checkDataExists(locationName);
  // ignore: use_build_context_synchronously
  if(exitInLocal) {
    favouriteBtnCubit.onFavChanged(2);
  } else {
    favouriteBtnCubit.onFavChanged(1);
  }
}

Widget favouriteButton(BuildContext context, WeatherModel weatherModel) {
  final favouriteBtnCubit = BlocProvider.of<FavouriteBtnCubit>(context);
  checkFavIcon(weatherModel.locationName.toString(), favouriteBtnCubit);
  return BlocBuilder<FavouriteBtnCubit, int>(
    builder: (context, state) {
      return OutlinedButton.icon(
        onPressed: favouriteBtnCubit.state == 0 ? null : () async {
          if(favouriteBtnCubit.state == 2) {
            // remove 
            favouriteBtnCubit.onFavChanged(0);
            final result = await DatabaseHelper().removeWeather(weatherModel.locationName.toString());
            favouriteBtnCubit.onFavChanged(1);
            if(result > 0) {
              // ignore: use_build_context_synchronously
              showSnackBar(
              context,
              "Remove from Favourite Successful.");
            } else {
              // ignore: use_build_context_synchronously
              showSnackBar(
              context,
              "No data to remove.");
            }
           
          } else if(favouriteBtnCubit.state == 1){
            // add 
            favouriteBtnCubit.onFavChanged(0);
            final result = await DatabaseHelper().insertWeather(weatherModel);
            favouriteBtnCubit.onFavChanged(2);
            if(result != -1) {
              // ignore: use_build_context_synchronously
              showSnackBar(
              context,
              "Add to Favourite Successful.");
            } else {
               // ignore: use_build_context_synchronously
               showSnackBar(
              context,
              "Already in the Favourite.");
            }
          }

        },
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red,
          side: const BorderSide(color: Colors.red), // Set the border color
        ),
        icon: Icon(
          favouriteBtnCubit.state == 2
              ? Icons.favorite
              : Icons.favorite_border,
          color: Colors.red, // Set the icon color
        ),
        label: Text(
          favouriteBtnCubit.state == 2 
              ? 'Remove From Favourite'
              : 'Add To Favourite',
          style: const TextStyle(color: Colors.red), // Set the label text color
        ),
      );
    },
  );
}


// API
class Constants {
  static const String WEATHER_APP_ID = '813f6fc7fe6d450596e21038232005';
  static const String WEATHER_BASE_SCHEME = 'https://';
  static const String WEATHER_BASE_URL_DOMAIN = 'api.weatherapi.com';
  static const String WEATHER_FORECAST_PATH = '/v1/forecast.json';

}
