// lib/env/env.dart
import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
final class Env {
  @EnviedField(varName: 'API_KEY')
  static const String apikey = _Env.apikey;
  @EnviedField(varName: 'TOKEN')
  static const String token = _Env.token;

}
