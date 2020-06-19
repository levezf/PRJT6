import 'package:shared_preferences/shared_preferences.dart';


class CineplusSharedPreferences{
  static const String kToken = "TOKEN";


  CineplusSharedPreferences._internal();

  static CineplusSharedPreferences instance = CineplusSharedPreferences._internal();

  Future<String> getToken() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(kToken);
  }

  Future<bool> saveToken(String newToken) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setString(kToken, newToken);
  }

  Future<void> clearShared() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
  }

}

