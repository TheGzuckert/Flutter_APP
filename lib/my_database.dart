import 'package:moor_flutter/moor_flutter.dart';

part 'my_database.g.dart';

class User extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get username => text().withLength(min: 6, max: 32)();
  TextColumn get password => text().withLength(min: 6, max: 32)();
}

@UseMoor(tables: [User])
class MyDatabase extends _$MyDatabase {
  MyDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(
      path: 'db.sqlite', logStatements: true));

  @override
  int get schemaVersion => 1;

  Future<int> insertUser(User user) => into(user).insert(user);
}
