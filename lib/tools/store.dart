import 'package:flutter/material.dart';

class Store {
  String type;
  String name;
  String subName;
  double price;
  String description;
  String image;
  List<String> availableDecoration;
  List<String> availableShapes;

  Store({
    this.type = 'notcake',
    @required this.name,
    @required this.subName,
    @required this.description,
    @required this.image,
    @required this.price,
    @required this.availableDecoration,
    @required this.availableShapes,
  });
}

List<Store> storeItems = [
  Store(
    type: 'Cake',
    name: 'Candlect',
    subName: "Cheese Cake",
    description:
        "Light and sweet but moist and rich in flavor, our Vanilla Almond cake is filled and frosted with our house vanilla buttercream. Vanilla Almond Amycakes are decorated with sparkly clear crystal sprinkles, pearl sprinkles and a ring of buttercream rosettes.",
    image:
        "https://media.gettyimages.com/photos/birthday-candles-picture-id172917568?s=2048x2048",
    price: 100,
    availableDecoration: ['fruit', 'walnut', 'almond'],
    availableShapes: ['round', 'square', 'heart', 'rectangle'],
  ),
  Store(
    name: 'Meow',
    subName: "Chocolate Cake",
    description:
        "Rich, fudgy chocolate cake filled and frosted with our house chocolate buttercream. Double Chocolate Amycakes are decorated with chocolate flakes and chocolate ganache drizzle",
    image:
        "https://media.gettyimages.com/photos/cat-wearing-birthday-hat-blowing-out-candles-on-birthday-cake-picture-idsb10064212b-001?s=2048x2048",
    price: 200,
    availableDecoration: ['fruit', 'cheese', 'sprinkles'],
    availableShapes: ['rectangle', 'square', 'heart'],
  ),
  Store(
    name: 'Ballonie',
    subName: "White Forest",
    description:
        "Moist Vanilla Almond cake studded with confetti sprinkles in the batter. Confetti Amycakes are frosted with vanilla buttercream and decorated with colorful sprinkles.",
    image:
        "https://media.gettyimages.com/photos/birthday-cake-on-white-picture-id117239542?s=2048x2048",
    price: 300,
    availableDecoration: ['fruit', 'walnut', 'almond'],
    availableShapes: ['round', 'square', 'heart', 'rectangle'],
  ),
  Store(
    type: 'Cake',
    name: 'Fudgie',
    subName: "Black Forest",
    description:
        "Alternating layers of vanilla almond and chocolate cakes, filled and frosted with our house vanilla buttercream.  Zebra Amycakes are decorated with chocolate ganache drizzle and white and chocolate curls.",
    image:
        "https://media.gettyimages.com/photos/cropped-image-of-friends-lighting-birthday-candles-picture-id608987581?s=2048x2048",
    price: 400,
    availableDecoration: ['fruit', 'walnut', 'almond'],
    availableShapes: ['round', 'rectangle'],
  ),
];
