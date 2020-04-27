import 'package:carlabirint/model/tile.dart';
import 'package:rxdart/rxdart.dart';

class MapViewModel {
  final BehaviorSubject<List<List<Tile>>> _tilesController = BehaviorSubject();
  Stream<List<List<Tile>>> get tiles => _tilesController.stream;
  List<List<Tile>> _map;
  List<List<bool>> _visited;
  int actualX, actualY;

  final BehaviorSubject<bool> _isOnCorrectTileController = BehaviorSubject();
  Stream<bool> get isOnCorrectTile => _isOnCorrectTileController.stream;

  final BehaviorSubject<int> _rotationController = BehaviorSubject();
  Stream<int> get rotation => _rotationController.stream;

  int get mapWidth => _map.length;
  int get mapHeight => _map?.first?.length;

  void recreateMap(int width, int height) {
    _generateMap(width, height);
    _tilesController.add(_map);
  }

  void close() {
    _tilesController.close();
    _isOnCorrectTileController?.close();
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
    if (!_mapIsCorrect()) {
      print('map is incorrect');
      _generateMap(width, height);
    }
  }

  bool _mapIsCorrect() {
    _visited = List.generate(
        mapWidth, (_) => List.filled(mapHeight, false, growable: false),
        growable: false);
    return _doesPathExist(0, 1, mapWidth - 1, mapHeight - 1);
  }

  bool _doesPathExist(int startX, int startY, int endX, int endY) {
    if (startX == endX && startY == endY) {
      return true;
    } else {
      _visited[startX][startY] = true;
      if (_map[startX][startY].leftInput == Tile.road &&
          _canBeVisited(startX - 1, startY) &&
          _doesPathExist(startX - 1, startY, endX, endY)) {
        return true;
      }
      if (_map[startX][startY].rightInput == Tile.road &&
          _canBeVisited(startX + 1, startY) &&
          _doesPathExist(startX + 1, startY, endX, endY)) {
        return true;
      }
      if (_map[startX][startY].topInput == Tile.road &&
          _canBeVisited(startX, startY - 1) &&
          _doesPathExist(startX, startY - 1, endX, endY)) {
        return true;
      }
      if (_map[startX][startY].bottomInput == Tile.road &&
          _canBeVisited(startX, startY + 1) &&
          _doesPathExist(startX, startY + 1, endX, endY)) {
        return true;
      }
      return false;
    }
  }

  void setCarPosition(int x, int y) {
    actualX = x;
    actualY = y;
  }

  bool _canBeVisited(int x, int y) {
    return x >= 0 && x < mapWidth && y >= 0 && y < mapHeight && !_visited[x][y];
  }

  bool canGo(int x, int y) {
    bool result = false;
    if (actualY == y && actualX == x) {
      //result = true;
      //_rotationController.add(moving_right);
    } else if (actualX == x && actualY + 1 == y) {
      //moving down
      _rotationController.add(moving_down);
      result = _map[actualX][actualY].bottomInput == Tile.road;
    } else if (actualX == x && actualY - 1 == y) {
      //moving up
      _rotationController.add(moving_up);
      result = _map[actualX][actualY].topInput == Tile.road;
    } else if (actualX + 1 == x && actualY == y) {
      //moving right
      _rotationController.add(moving_right);
      result = _map[actualX][actualY].rightInput == Tile.road;
    } else if (actualX - 1 == x && actualY == y) {
      //moving left
      _rotationController.add(moving_left);
      result = _map[actualX][actualY].leftInput == Tile.road;
    }
    print("isOnCorrect $result");
    _isOnCorrectTileController.add(result);
    return result;
  }

  static const moving_right = 0;
  static const moving_down = 1;
  static const moving_left = 2;
  static const moving_up = 3;

  void finishMoving() {
    _rotationController.add(moving_right);
    _isOnCorrectTileController.add(false);
  }
}
