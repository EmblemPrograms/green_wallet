import 'dart:developer';

import 'package:green_wallet/dbase/constant.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoDatabase {
  static var db, userCollection;
  static Future<void> connect() async {
    try {
      db = await Db.create(MONGO_CONN_URL);
      await db.open();
      inspect(db);
      userCollection = db.collection(USER_COLLECTION);
      print("✅ MongoDB Connected Successfully!");
    } catch (e) {
      print("❌ MongoDB Connection Error: $e");
    }
  }
}