import 'package:carlabirint/view_model/map_view_model.dart';
import 'package:carlabirint/widget/tile_view.dart';
import 'package:flutter/material.dart';

import 'model/tile.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapViewModel viewModel = MapViewModel();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_calculateTiles);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        StreamBuilder<List<List<Tile>>>(
          stream: viewModel.tiles,
          builder: (context, data) {
            if (data.data == null) {
              return CircularProgressIndicator();
            }
            return Row(
              children: data.data
                  .map((columnList) => Column(
                        children: columnList
                            .map((tileItem) => TileView(
                                  tile: tileItem,
                                ))
                            .toList(growable: false),
                      ))
                  .toList(growable: false),
            );
          },
        ),
        Positioned(
          top: TileView.tile_size * (viewModel.mapHeight - 1 ?? 0),
          right: 0,
          child: Image.asset(
            "assets/bus2_wait.png",
            height: TileView.tile_size,
            width: TileView.tile_size,
          ),
        ),
        Positioned(
          top: TileView.tile_size,
          left: 0,
          child: Image.asset(
            "assets/bus2.png",
            height: TileView.tile_size,
            width: TileView.tile_size,
          ),
        )
      ],
    ));
  }

  void _calculateTiles(_) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    viewModel.recreateMap((width / 50).floor(), (height / 50).floor());
  }
}
