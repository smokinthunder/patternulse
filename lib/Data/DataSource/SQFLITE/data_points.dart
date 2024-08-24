import 'dart:developer';

import 'package:patternpulse/Data/Models/drawing_point_model.dart';
import 'package:sqflite/sqflite.dart';

late Database database;

Future<void> initializeDataPointsDatabase() async {
  database = await openDatabase('data_points.db', version: 1,
      onCreate: (db, version) async {
    await db.execute(
        'CREATE TABLE data_points(id INTEGER PRIMARY KEY, x REAL, y REAL)');
  });
}

Future<void> getDataPoints() async {
  final values = await database.rawQuery('SELECT * FROM data_points');
  log(values.toString());
}

Future<void> insertDataPoint(DrawingPointModel points) async {
  await database.rawInsert(
      'INSERT INTO data_points(x, y) VALUES(?, ?)', [points.x, points.y]);
}

Future<void> deleteDataPoints() async {
  await database.rawDelete('DELETE FROM data_points');
}