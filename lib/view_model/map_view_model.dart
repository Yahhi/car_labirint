import 'package:carlabirint/model/tile.dart';
import 'package:rxdart/rxdart.dart';

class MapViewModel {
  BehaviorSubject<List<List<Tile>>> _tilesController = BehaviorSubject();
  Stream<List<List<Tile>>> get tiles => _tilesController.stream;
  List<List<Tile>> _map;

  MapViewModel(int width, int height) {
    recreateMap(width, height);
  }

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
    _map[0][0] = Tile.horizontal_low;
    _map[0][1] = Tile.horizontal_high;
    for (int j = 0; j < height; j++) {
      for (int i = 0; i < width; i++) {
        if (_map[i][j] == null) {
          _map[i][j] = Tile.suitableTile(
            leftInputs: i == 0 ? null : _map[i - 1][j].rightInputs,
            rightInputs: i == width - 1 ? null : _map[i + 1][j]?.leftInputs,
            topInputs: j == 0 ? null : _map[i][j - 1].bottomInputs,
            bottomInputs: j == height - 1 ? null : _map[i][j + 1]?.topInputs,
          );
        }
      }
    }
  }
}
