import 'package:shared_preferences/shared_preferences.dart';


class CineplusSharedPreferences{
  static const String kToken = "TOKEN";
  static const String kId = "IDUSER";


  CineplusSharedPreferences._internal();

  static CineplusSharedPreferences instance = CineplusSharedPreferences._internal();

  Future<String> getToken() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(kToken);
  }

  Future<int> getIdUser() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt(kId);
  }

  Future<bool> saveToken(String newToken) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setString(kToken, newToken);
  }

  Future<bool> saveIdUser(int id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setInt(kId, id);
  }

  Future<void> clearShared() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
  }


}

