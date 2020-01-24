import 'dart:convert';
import 'dart:ui';

import 'package:VirtualFlightThrottle/data/data_sqlite3_helper.dart';
import 'package:VirtualFlightThrottle/panel/panel_setting.dart';
import 'package:VirtualFlightThrottle/utility/utility_dart.dart';
import 'package:flutter/services.dart' show rootBundle;

class PanelUtility {
  static const double MIN_BLOCK_WIDTH = 75.0;
  static const double MIN_BLOCK_HEIGHT = 100.0;

  static const double TOP_MARGIN = 20;

  static bool canBuildPanelPerfectly(PanelSetting panelSetting, Size screenSize) =>
      screenSize.width / panelSetting.width < MIN_BLOCK_WIDTH || (screenSize.height - TOP_MARGIN) / panelSetting.height < MIN_BLOCK_HEIGHT;

  static Pair<int, int> getMaxPanelSize(Size screenSize) =>
      Pair(screenSize.width ~/ MIN_BLOCK_WIDTH, screenSize.height ~/ MIN_BLOCK_HEIGHT);

  static Size getBlockSize(PanelSetting panelSetting, Size screenSize) =>
      Size(screenSize.width / panelSetting.width, (screenSize.height - TOP_MARGIN) / panelSetting.height);

}

class AppPanelManager {
  static final AppPanelManager _singleton = new AppPanelManager._internal();
  factory AppPanelManager() => _singleton;
  AppPanelManager._internal();

  bool needMainPanelUpdate = false;
  List<PanelSetting> panelList = List<PanelSetting>();

  Future<void> loadSavedPanelList() async {
    await SQLite3Helper().getSavedPanelList().then((val) async {
      if (val.length == 0) {
        PanelSetting defaultPanelSetting = await _getSavedDefaultPanel(true);
        SQLite3Helper().insertPanel("Default Panel", jsonEncode(defaultPanelSetting.toJSON()));
        this.panelList.add(await _getSavedDefaultPanel(true));
      } else val.forEach((key, value) => this.panelList.add(PanelSetting.fromJSON(key, jsonDecode(value))));
    });
  }

  void insertPanel(PanelSetting panelSetting) {
    this.panelList.insert(0, panelSetting);
    SQLite3Helper().insertPanel(panelSetting.name, jsonEncode(panelSetting.toJSON()));
  }

  void removeSavedPanel(String panelName) {
    this.panelList.removeAt(this.panelList.indexWhere((val) => val.name == panelName));
    SQLite3Helper().removePanel(panelName);
  }

  Future<PanelSetting> _getSavedDefaultPanel(bool loadSmall) async =>
    PanelSetting.fromJSON("Default Panel", jsonDecode(await rootBundle.loadString("assets/jsons/default_panel_${loadSmall? "small" : "large"}.json")));

}
