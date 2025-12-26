import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/price_alert.dart';

class PriceAlertsService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('price_alerts.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE alerts(
        id TEXT PRIMARY KEY,
        symbol TEXT,
        targetPrice REAL,
        condition INTEGER,
        isActive INTEGER
      )
    ''');
  }

  Future<List<PriceAlert>> getAlerts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('alerts');

    return List.generate(maps.length, (i) {
      return PriceAlert(
        id: maps[i]['id'],
        symbol: maps[i]['symbol'],
        targetPrice: maps[i]['targetPrice'],
        condition: AlertCondition.values[maps[i]['condition']],
        isActive: maps[i]['isActive'] == 1,
      );
    });
  }

  Future<void> addAlert(PriceAlert alert) async {
    final db = await database;
    await db.insert(
      'alerts',
      {
        'id': alert.id,
        'symbol': alert.symbol,
        'targetPrice': alert.targetPrice,
        'condition': alert.condition.index,
        'isActive': alert.isActive ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteAlert(String id) async {
    final db = await database;
    await db.delete(
      'alerts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> toggleAlert(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'alerts',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      final currentStatus = maps.first['isActive'] == 1;
      await db.update(
        'alerts',
        {'isActive': currentStatus ? 0 : 1},
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }

  Future<void> updateAlert(PriceAlert alert) async {
    final db = await database;
    await db.update(
      'alerts',
      {
        'symbol': alert.symbol,
        'targetPrice': alert.targetPrice,
        'condition': alert.condition.index,
        'isActive': alert.isActive ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [alert.id],
    );
  }
}