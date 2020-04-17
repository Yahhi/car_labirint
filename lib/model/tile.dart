import 'dart:math';

class Tile {
  final List<int> leftInputs;
  final List<int> rightInputs;
  final List<int> topInputs;
  final List<int> bottomInputs;
  final String imageAddress;

  const Tile._internal(
    this.imageAddress, {
    this.leftInputs = const [grass, grass],
    this.rightInputs = const [grass, grass],
    this.topInputs = const [grass, grass],
    this.bottomInputs = const [grass, grass],
  });

  static const grass = 0;
  static const input_road = 1;
  static const road = 2;

  static Random _random = Random();

  static const horizontal_low = Tile._internal("assets/horizontal_low.png",
      leftInputs: [grass, input_road],
      rightInputs: [grass, input_road],
      bottomInputs: [road, road]);
  static const horizontal_high = Tile._internal("assets/horizontal_high.png",
      leftInputs: [input_road, grass],
      rightInputs: [input_road, grass],
      topInputs: [road, road]);
  static const vertical_left = Tile._internal("assets/vertical_left.png",
      topInputs: [input_road, grass],
      bottomInputs: [input_road, grass],
      leftInputs: [road, road]);
  static const vertical_right = Tile._internal("assets/vertical_right.png",
      topInputs: [grass, input_road],
      bottomInputs: [grass, input_road],
      rightInputs: [road, road]);

  static const turn_left_top = Tile._internal("assets/turn_left_top.png",
      leftInputs: [grass, input_road],
      rightInputs: [road, input_road],
      topInputs: [grass, road],
      bottomInputs: [road, input_road]);
  static const turn_top_right = Tile._internal("assets/turn_top_right.png",
      leftInputs: [road, input_road],
      rightInputs: [grass, input_road],
      topInputs: [input_road, grass],
      bottomInputs: [input_road, road]);
  static const turn_bottom_right = Tile._internal(
      "assets/turn_bottom_right.png",
      leftInputs: [input_road, road],
      rightInputs: [input_road, grass],
      topInputs: [input_road, road],
      bottomInputs: [input_road, grass]);
  static const turn_left_bottom = Tile._internal("assets/turn_left_bottom.png",
      leftInputs: [input_road, grass],
      rightInputs: [input_road, road],
      topInputs: [road, input_road],
      bottomInputs: [grass, input_road]);
  static const no_roads = Tile._internal('assets/grass.png');

  static const _variants = [
    horizontal_high,
    horizontal_low,
    vertical_left,
    vertical_right,
    turn_bottom_right,
    turn_left_bottom,
    turn_left_top,
    turn_top_right,
    no_roads
  ];

  factory Tile.suitableTile({
    List<int> leftInputs,
    List<int> rightInputs,
    List<int> topInputs,
    List<int> bottomInputs,
  }) {
    return _randomFrom(_variants.where((element) =>
        (leftInputs == null ||
            (leftInputs != null && element.leftInputs == leftInputs)) &&
        (rightInputs == null ||
            (rightInputs != null && element.rightInputs == rightInputs)) &&
        (topInputs == null ||
            (topInputs != null && element.topInputs == topInputs)) &&
        (bottomInputs == null ||
            (bottomInputs != null && element.bottomInputs == bottomInputs))));
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
