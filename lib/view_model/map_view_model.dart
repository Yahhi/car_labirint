import 'package:carlabirint/model/tile.dart';
import 'package:rxdart/rxdart.dart';

class MapViewModel {
  BehaviorSubject<List<List<Tile>>> _tilesController = BehaviorSubject();
  Stream<List<List<Tile>>> get tiles => _tilesController.stream;
  List<List<Tile>> _map;

  int get mapWidth => _map.length;
  int get mapHeight => _map?.first?.length;

  void recreateMap(int width, int height) {
    _generateMap(width, height);
    _tilesController.add(_map);
  }

  void close() {
    _tilesController.close();
  }

  void _generateMap(int width, int height) {
    _map = List.generate(width, (_) => List.generate(height, (_) => null),
        growable: false);
    for (int i = 0; i < width; i++) {
      _map[i][0] = Tile.no_roads;
    }
    _map[0][1] = Tile.horizontal;
    _map[width - 1][height - 1] = Tile.horizontal;
    for (int j = 1; j < height; j++) {
      for (int i = 0; i < width; i++) {
        if (_map[i][j] == null) {
          _map[i][j] = Tile.suitableTile(
            leftInput: i == 0 ? null : _map[i - 1][j].rightInput,
            rightInput: i == width - 1 ? null : _map[i + 1][j]?.leftInput,
            topInput: j == 0 ? null : _map[i][j - 1].bottomInput,
            bottomInput: j == height - 1 ? null : _map[i][j + 1]?.topInput,
          );
        }
      }
    }
  }
}
