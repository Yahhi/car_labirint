import 'dart:math';

class Tile {
  final int leftInput;
  final int rightInput;
  final int topInput;
  final int bottomInput;
  final String imageAddress;

  const Tile._internal(
    this.imageAddress, {
    this.leftInput = grass,
    this.rightInput = grass,
    this.topInput = grass,
    this.bottomInput = grass,
  });

  static const grass = 0;
  static const road = 2;

  static Random _random = Random();

  static const horizontal = Tile._internal(
    "assets/horizontal.png",
    leftInput: road,
    rightInput: road,
  );
  static const horizontal_with_zebra = Tile._internal(
    "assets/horizontal_zebra.png",
    leftInput: road,
    rightInput: road,
  );
  static const vertical = Tile._internal(
    "assets/vertical.png",
    bottomInput: road,
    topInput: road,
  );
  static const vertical_with_zebra = Tile._internal(
    "assets/vertical_zebra.png",
    bottomInput: road,
    topInput: road,
  );
  static const cross = Tile._internal("assets/cross.png",
      topInput: road, bottomInput: road, leftInput: road, rightInput: road);

  static const cross_closed_top = Tile._internal("assets/cross_closed_top.png",
      leftInput: road, rightInput: road, bottomInput: road);
  static const cross_closed_bottom = Tile._internal(
      "assets/cross_closed_bottom.png",
      topInput: road,
      leftInput: road,
      rightInput: road);
  static const cross_closed_left = Tile._internal(
      "assets/cross_closed_left.png",
      topInput: road,
      bottomInput: road,
      rightInput: road);
  static const cross_closed_right = Tile._internal(
      "assets/cross_closed_right.png",
      topInput: road,
      bottomInput: road,
      leftInput: road);

  static const no_roads = Tile._internal('assets/grass.png');

  static const _variants = [
    horizontal,
    horizontal_with_zebra,
    vertical,
    vertical_with_zebra,
    cross_closed_left,
    cross_closed_right,
    cross_closed_top,
    cross_closed_bottom,
    no_roads
  ];

  factory Tile.suitableTile({
    int leftInput,
    int rightInput,
    int topInput,
    int bottomInput,
  }) {
    return _randomFrom(_variants.where((element) =>
        (leftInput == null ||
            (leftInput != null && element.leftInput == leftInput)) &&
        (rightInput == null ||
            (rightInput != null && element.rightInput == rightInput)) &&
        (topInput == null ||
            (topInput != null && element.topInput == topInput)) &&
        (bottomInput == null ||
            (bottomInput != null && element.bottomInput == bottomInput))));
  }

  static Tile _randomFrom(Iterable<Tile> list) {
    if (list.length == 0) {
      return no_roads;
    } else if (list.length == 1) {
      return list.first;
    } else {
      return list.toList()[_random.nextInt(list.length)];
    }
  }
}
