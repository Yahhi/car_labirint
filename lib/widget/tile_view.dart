import 'package:carlabirint/model/tile.dart';
import 'package:flutter/material.dart';

class TileView extends StatelessWidget {
  final Tile tile;

  const TileView({Key key, this.tile}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      tile.imageAddress,
      height: 50,
      width: 50,
    );
  }
}
