import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/weather_forecast.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  DatabaseHelper.internal();

  Future<Database> initDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/my_database.db';
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
       db.execute('''
          CREATE TABLE weather (
            id INTEGER PRIMARY KEY,
            locationName TEXT,
            tempC REAL,
            feelslikeC REAL,
            windDegree INTEGER,
            humidity INTEGER,
            pressureMb REAL,
            windKph REAL,
            windDir TEXT,
            icon TEXT,
            dateOne TEXT,
            dateTwo TEXT,
            dateThree TEXT,
            avgtempCOne REAL,
            avgtempCTwo REAL,
            avgtempCThree REAL,
            iconOne TEXT,
            iconTwo TEXT,
            iconThree TEXT
          )
        ''');
      },
    );
  }

  Future<bool> checkDataExists(String locationName) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'weather',
      where: 'locationName = ?',
      whereArgs: [locationName],
    );

    return result.isNotEmpty;
  }

  Future<int> insertWeather(WeatherModel weatherModel) async {
    final db = await database;
    bool exists = await checkDataExists(weatherModel.locationName.toString());
    if (!exists) {
      return await db.insert('weather', weatherModel.toMap());
    } 

    return -1;
  }

  Future<int> removeWeather(String locationName) async {
    Database db = await database;
    int result = await db.delete('weather', where: 'locationName = ?', whereArgs: [locationName]);
    return result;
  }

  Future<List<WeatherModel>> getAllCityWeather() async {
    final db = await database;
    final result = await db.query('weather');
    return result.map((row) => WeatherModel.fromJsonLocal(row)).toList();
  }
}
