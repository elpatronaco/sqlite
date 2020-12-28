import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqliteapp/bloc/coin_bloc.dart';
import 'package:sqliteapp/model/coin.dart';

class HomePage extends StatelessWidget {
  HomePage({Key key, this.title}) : super(key: key);

  //We load our Todo BLoC that is used to get
  //the stream of Todo for StreamBuilder
  final CoinBloc coinBloc = CoinBloc();
  final String title;

  //Allows Todo card to be dismissable horizontally
  final DismissDirection _dismissDirection = DismissDirection.horizontal;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark));
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SafeArea(
            child: Container(
                color: Colors.white,
                padding:
                    const EdgeInsets.only(left: 2.0, right: 2.0, bottom: 2.0),
                child: Container(
                    //This is where the magic starts
                    child: getTodosWidget()))),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: 25),
          child: FloatingActionButton(
            elevation: 5.0,
            onPressed: () {
              _showAddTodoSheet(context);
            },
            backgroundColor: Colors.white,
            child: Icon(
              Icons.add,
              size: 32,
              color: Colors.indigoAccent,
            ),
          ),
        ));
  }

  void _showAddTodoSheet(BuildContext context) {
    final _coinAliasTextField = TextEditingController();
    final _coinNameTextField = TextEditingController();
    final _coinPriceTextField = TextEditingController();
    final _coinImageTextField = TextEditingController();
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: new Container(
              color: Colors.transparent,
              child: new Container(
                height: 200,
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(10.0),
                        topRight: const Radius.circular(10.0))),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 15, top: 25.0, right: 15, bottom: 30),
                  child: ListView(
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                              child: Column(
                            children: [
                              TextFormField(
                                controller: _coinAliasTextField,
                                textInputAction: TextInputAction.newline,
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 21, fontWeight: FontWeight.w400),
                                autofocus: true,
                                decoration: const InputDecoration(
                                    hintText: 'BTC',
                                    labelText: 'Alias',
                                    labelStyle: TextStyle(
                                        color: Colors.indigoAccent,
                                        fontWeight: FontWeight.w500)),
                              ),
                              TextFormField(
                                controller: _coinNameTextField,
                                textInputAction: TextInputAction.newline,
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 21, fontWeight: FontWeight.w400),
                                autofocus: true,
                                decoration: const InputDecoration(
                                    hintText: 'Bitcoin',
                                    labelText: 'Name',
                                    labelStyle: TextStyle(
                                        color: Colors.indigoAccent,
                                        fontWeight: FontWeight.w500)),
                              ),
                              TextFormField(
                                controller: _coinPriceTextField,
                                textInputAction: TextInputAction.newline,
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 21, fontWeight: FontWeight.w400),
                                autofocus: true,
                                decoration: const InputDecoration(
                                    hintText: '25011',
                                    labelText: 'Price',
                                    labelStyle: TextStyle(
                                        color: Colors.indigoAccent,
                                        fontWeight: FontWeight.w500)),
                              ),
                              TextFormField(
                                controller: _coinImageTextField,
                                textInputAction: TextInputAction.newline,
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 21, fontWeight: FontWeight.w400),
                                autofocus: true,
                                decoration: const InputDecoration(
                                    hintText: 'www.google.com/image.png',
                                    labelText: 'Image',
                                    labelStyle: TextStyle(
                                        color: Colors.indigoAccent,
                                        fontWeight: FontWeight.w500)),
                              ),
                            ],
                          )),
                          Padding(
                            padding: EdgeInsets.only(left: 5, top: 15),
                            child: CircleAvatar(
                              backgroundColor: Colors.indigoAccent,
                              radius: 18,
                              child: IconButton(
                                icon: Icon(
                                  Icons.save,
                                  size: 22,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  final newTodo = Coin(
                                      id: _coinAliasTextField.value.text,
                                      name: _coinNameTextField.value.text,
                                      price: double.parse(
                                          _coinPriceTextField.value.text),
                                      image: _coinImageTextField.value.text,
                                  );

                                  coinBloc.addCoin(newTodo);
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget getTodosWidget() {
    /*The StreamBuilder widget,
    basically this widget will take stream of data (todos)
    and construct the UI (with state) based on the stream
    */
    return StreamBuilder(
      stream: coinBloc.todos,
      builder: (BuildContext context, AsyncSnapshot<List<Coin>> snapshot) {
        return getTodoCardWidget(snapshot);
      },
    );
  }

  Widget getTodoCardWidget(AsyncSnapshot<List<Coin>> snapshot) {
    /*Since most of our operations are asynchronous
    at initial state of the operation there will be no stream
    so we need to handle it if this was the case
    by showing users a processing/loading indicator*/
    if (snapshot.hasData) {
      /*Also handles whenever there's stream
      but returned returned 0 records of Todo from DB.
      If that the case show user that you have empty Todos
      */
      return snapshot.data.length != 0
          ? ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, itemPosition) {
                Coin coin = snapshot.data[itemPosition];
                final Widget dismissibleCard = new Dismissible(
                    background: Container(
                      child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Lol",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      color: Colors.redAccent,
                    ),
                    onDismissed: (direction) {
                      coinBloc.deleteTodoById(coin.id);
                    },
                    direction: _dismissDirection,
                    key: new ObjectKey(coin),
                    child: Card(
                        child: ListTile(
                            leading: coin.image != ""
                                ? Image.network(coin.image)
                                : Image.asset("assets/peseta.png"),
                            title: Text(coin.name),
                        )));
                return dismissibleCard;
              },
            )
          : Container(
              child: Center(
              //this is used whenever there 0 Todo
              //in the data base
              child: Container(
                child: Text(
                  "Start adding coins... length: ${snapshot.data.length}",
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
                ),
              ),
            ));
    } else {
      return Center(
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                Text("Loading...",
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500))
              ],
            ),
          ),
        ),
      );
    }
  }

  dispose() {
    /*close the stream in order
    to avoid memory leaks
    */
    coinBloc.dispose();
  }
}
