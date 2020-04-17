import 'package:carlabirint/view_model/map_view_model.dart';
import 'package:carlabirint/widget/tile_view.dart';
import 'package:flutter/material.dart';

import 'model/tile.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapViewModel viewModel = MapViewModel(6, 10);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Map with car"),
      ),
      body: Center(
        child: StreamBuilder<List<List<Tile>>>(
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          viewModel.recreateMap(6, 10);
        },
        tooltip: 'Increment',
        child: Icon(Icons.refresh),
      ),
    );
  }
}
