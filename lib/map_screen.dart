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
  int carX = 0;
  int carY = 1;
  int activeAreaX = 0;
  int activeAreaY = 1;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_calculateTiles);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<List<Tile>>>(
        stream: viewModel.tiles,
        builder: (context, data) {
          if (data.data == null) {
            return CircularProgressIndicator();
          }
          int x = -1;
          int y = 0;
          return Stack(
            children: <Widget>[
              Row(
                children: data.data.map((columnList) {
                  y = -1;
                  x++;
                  return Column(
                    children: columnList.map(
                      (tileItem) {
                        y++;
                        final itemX = x;
                        final itemY = y;
                        return DragTarget(
                          onWillAccept: (_) {
                            final bool canGo = viewModel.canGo(itemX, itemY);
                            print("canGo to $itemX, $itemY: $canGo");
                            return canGo;
                          },
                          onLeave: (_) {
                            print('on leave $itemX, $itemY');
                            if (viewModel.canGo(itemX, itemY)) {
                              viewModel.setCarPosition(itemX, itemY);
                              setState(() {
                                carX = itemX;
                                carY = itemY;
                              });
                            }
                          },
                          onAccept: (_) {
                            viewModel.setCarPosition(itemX, itemY);
                            print("will set car position to $itemX, $itemY");
                            setState(() {
                              carX = itemX;
                              carY = itemY;
                            });
                          },
                          builder: (context, List<dynamic> candidateData,
                              List<dynamic> rejectedData) {
                            return TileView(
                              tile: tileItem,
                            );
                          },
                        );
                      },
                    ).toList(growable: false),
                  );
                }).toList(growable: false),
              ),
              Positioned(
                top: TileView.tile_size * (((viewModel.mapHeight ?? 1) - 1)),
                right: 0,
                child: Image.asset(
                  "assets/bus2_wait.png",
                  height: TileView.tile_size,
                  width: TileView.tile_size,
                ),
              ),
              Positioned(
                top: carY * TileView.tile_size,
                left: carX * TileView.tile_size,
                child: StreamBuilder<bool>(
                  stream: viewModel.isOnCorrectTile,
                  builder: (context, snapshot) {
                    if (snapshot.data == null || !snapshot.data) {
                      return Image.asset(
                        "assets/bus2.png",
                        height: TileView.tile_size,
                        width: TileView.tile_size,
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
              Positioned(
                left: activeAreaX * TileView.tile_size,
                top: activeAreaY * TileView.tile_size,
                child: Draggable(
                  onDragStarted: () {
                    viewModel.setCarPosition(carX, carY);
                  },
                  onDragCompleted: () {
                    print("drag completed");
                  },
                  onDraggableCanceled: (_, __) {
                    print("drag cancelled");
                  },
                  onDragEnd: (_) {
                    print("drag end");
                    setState(() {
                      activeAreaX = carX;
                      activeAreaY = carY;
                    });
                  },
                  childWhenDragging: Container(),
                  child: Image.asset(
                    "assets/transparent_tile.png",
                    height: TileView.tile_size,
                    width: TileView.tile_size,
                  ),
                  feedback: StreamBuilder<bool>(
                    stream: viewModel.isOnCorrectTile,
                    builder: (context, snapshot) {
                      if (snapshot.data == null || !snapshot.data) {
                        return Container();
                      } else {
                        return Image.asset(
                          "assets/bus2.png",
                          height: TileView.tile_size,
                          width: TileView.tile_size,
                        );
                      }
                    },
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  void _calculateTiles(_) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    viewModel.recreateMap((width / 50).floor(), (height / 50).floor());
  }
}
