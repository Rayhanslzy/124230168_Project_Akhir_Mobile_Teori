// ---------------------------------------------------
// lib/data/models/user_model.dart (Versi Final - Bersih)
// ---------------------------------------------------
import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  final String username;

  @HiveField(1)
  final String encryptedPassword;

  User({
    required this.username,
    required this.encryptedPassword,
  });
}