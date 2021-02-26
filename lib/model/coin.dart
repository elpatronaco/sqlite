class Coin {
  String id;
  String name;
  DateTime dateOfCreation;
  double price;
  String image;

  Coin(
      {this.id,
      this.name,
      this.dateOfCreation,
      this.price,
      this.image =
          "https://images.clarin.com/2020/12/16/el-precio-del-bitcoin-se___lr5a9rX9H_340x340__1.jpg"});

  factory Coin.fromDatabaseJson(Map<String, dynamic> data) => Coin(
      id: data['id'],
      name: data['name'],
      dateOfCreation: DateTime.parse(data['dateOfCreation']),
      price: data['price'],
      image: data['image']);

  Map<String, dynamic> toDatabaseJson() => {
        "id": this.id,
        "name": this.name,
        "dateOfCreation": this.dateOfCreation.toIso8601String(),
        "price": this.price,
        "image": this.image
      };
}
