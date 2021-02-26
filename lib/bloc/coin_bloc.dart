import 'dart:async';

import 'package:sqliteapp/model/coin.dart';
import 'package:sqliteapp/repository/coin_repository.dart';

class CoinBloc {
  //Get instance of the Repository
  final _todoRepository = CoinRepository();

  //Stream controller is the 'Admin' that manages
  //the state of our stream of data like adding
  //new data, change the state of the stream
  //and broadcast it to observers/subscribers
  final _todoController = StreamController<List<Coin>>.broadcast();

  get todos => _todoController.stream;

  CoinBloc() {
    getTodos();
  }

  getTodos({String query}) async {
    //sink is a way of adding data reactively to the stream
    //by registering a new event
    _todoController.sink.add(await _todoRepository.getAllTodos(query: query));
  }

  addCoin(Coin coin) async {
    await _todoRepository.insertCoin(coin);
    getTodos();
  }

  updateTodo(Coin coin) async {
    await _todoRepository.updateTodo(coin);
    getTodos();
  }

  deleteTodoById(String id) async {
    _todoRepository.deleteTodoById(id);
    getTodos();
  }

  dispose() {
    _todoController.close();
  }
}
