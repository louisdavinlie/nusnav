import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class NUSFavoriteStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/nusfavorites.txt');
  }

  Future<String> readFavorites() async {
    try {
      final file = await _localFile;

      final String contents = await file.readAsString();

      return contents;
    } catch (e) {
      return '';
    }
  }

  Future<File> writeFavorites(List<String> favoriteNUSBusStopList) async {
    final file = await _localFile;

    String busListString = favoriteNUSBusStopList.join(" ");
    print('$favoriteNUSBusStopList');

    return file.writeAsString(busListString);
  }
}
