import 'package:sqliteapp/model/coin.dart';
import 'package:sqliteapp/database/database.dart';
import 'package:dio/dio.dart';

class TodoApiProvider {
  static Future<List<Coin>> getAllTodos() async {
    var url = "6d519adf-0a0d-4a62-9784-6fd765088f38.mock.pstmn.io/coins";
    Response response = await Dio().get(url);

    print(response.data);

    return (response.data as List).map((coin) {
      print('Inserting $coin');
      DatabaseProvider.dbProvider.addCoin(coin);
    }).toList();
  }
}
