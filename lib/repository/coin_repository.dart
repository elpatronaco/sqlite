import 'package:sqliteapp/dao/todo_dao.dart';
import 'package:sqliteapp/model/coin.dart';

class CoinRepository {
  final todoDao = TodoDao();

  Future getAllTodos({String query}) => todoDao.getTodos(query: query);

  Future insertCoin(Coin coin) => todoDao.createTodo(coin);

  Future updateTodo(Coin coin) => todoDao.updateTodo(coin);

  Future deleteTodoById(String id) => todoDao.deleteTodo(id);

  //We are not going to use this in the demo
  Future deleteAllTodos() => todoDao.deleteAllTodos();
}
