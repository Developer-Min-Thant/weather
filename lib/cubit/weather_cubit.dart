import 'package:bloc/bloc.dart';
import '../../../../api/weather_api.dart';
import '../models/weather_forecast.dart';

part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit() : super(const WeatherInitial()) {
    getWeather('Yangon');
  }


  Future<void> getWeather(String cityName) async {
    try {
      emit(const WeatherLoading());
      final weather = await WeatherApi().fetchWeatherForecast(cityName: cityName);
      emit(WeatherLoaded(weather));
    } catch(e) {
      emit(const WeatherError("Something went wrong please connect to developer."));
    }
  }
}
