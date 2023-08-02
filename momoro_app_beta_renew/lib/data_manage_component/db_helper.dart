import 'package:sqflite/sqflite.dart' as sql;
import 'package:intl/intl.dart';

// 테이블 생성
class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE data(
      id INTEGER PRIMARY KEY NOT NULL,
      rating REAL NOT NULL,
      thanksDesc TEXT,
      reliefDesc TEXT,
      goodDesc TEXT,
      createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )""");
  } // 아이디, 하루 점수, 감사한 일 글, 다행인 일 글, 잘한 일 글, 해당일 날짜

  /*
  id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  title TEXT,
  desc TEXT,
  createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
  */

  // 최초로 앱 실행하여 데이터 아무것도 없는 경우에 데이터베이스 생성을 위한 함수
  static Future<sql.Database> db() async {
    return await sql.openDatabase("database_name_renew.db", version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  // InputListFirstScreen에서 '저장' 버튼 누를 경우 데이터가 데이터베이스에 저장되도록 하는 함수
  static Future<int> createData(double rating, String? thanksDesc,
      String? reliefDesc, String? goodDesc, DateTime createdAt) async {
    final db = await SQLHelper.db();

    final data = {
      'rating': rating,
      'thanksDesc': thanksDesc,
      'reliefDesc': reliefDesc,
      'goodDesc': goodDesc,
      // 'createdAt': createdAt,
    };
    final id = await db.insert('data', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);

    return id;
  }

  // 생성한 모든 데이터(레코드)를 저장해두는 데이터베이스
  static Future<List<Map<String, dynamic>>> getAllData() async {
    final db = await SQLHelper.db();
    return db.query('data', orderBy: 'id');
  }

  // 전체 데이터 중 특정 월에 대한 데이터만 추출해주는 함수 (where 조건 createdAt 이용해서 범위로 조절)
  static Future<List<Map<String, dynamic>>> getMonthData(
      DateTime createdAt) async {
    final db = await SQLHelper.db();
    return db.query('data',
        where: 'createdAt = ?', whereArgs: [createdAt], limit: 1);
  }

  // 전체 데이터 중 특정 일에 대한 데이터만 추출해주는 함수 (where 조건 createdAt 이용해서 캘린더에서 선택한 일에 대한 데이터 추출)
  static Future<List<Map<String, dynamic>>> getDayData(
      DateTime selectedDate) async {
    final db = await SQLHelper.db();

    String from = DateFormat('yyyy-MM-dd')
        .format(DateTime(selectedDate.year, selectedDate.month, 1));
    String to = DateFormat('yyyy-MM-dd')
        .format(DateTime(selectedDate.year, selectedDate.month + 1, 0));
    return db.query('data',
        where: 'createdAt >= ? and createdAt <= ?', whereArgs: [from, to]);
  }

  // InputListLaterScreen에서 '텍스트 수정 시' 수정내용 반영될 수 있도록 하기
  static Future<int> updateDescData(DateTime createdAt, String? thanksDesc,
      String? reliefDesc, String? goodDesc) async {
    final db = await SQLHelper.db();
    final data = {
      'thanksDesc': thanksDesc,
      'reliefDesc': reliefDesc,
      'goodDesc': goodDesc,
    };
    final result = await db.update('data', data,
        where: 'createdAt >= ? and createdAt <= ?', whereArgs: [createdAt]);
    return result;
  }
}
