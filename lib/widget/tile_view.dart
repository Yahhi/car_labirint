import 'package:carlabirint/model/tile.dart';
import 'package:flutter/material.dart';

class TileView extends StatelessWidget {
  static const tile_size = 50.0;

  final Tile tile;

  const TileView({Key key, this.tile}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      tile.imageAddress,
      height: tile_size,
      width: tile_size,
    );
  }
}
