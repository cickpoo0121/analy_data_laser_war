import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import '../models/player.dart';

class ReadFileTest extends StatefulWidget {
  const ReadFileTest({Key? key}) : super(key: key);

  @override
  State<ReadFileTest> createState() => _ReadFileTestState();
}

class _ReadFileTestState extends State<ReadFileTest> {
  String souceFile =
      "F:/Freelance/fotoclubProject/POC/read_files_test/app_ver/assets/RealtimeStatistics.json";
  final killScore = 5;

  void readFIles() {
    File file = File(souceFile);
    List<String> raw = file.readAsLinesSync();

    Map<String, dynamic> lineOne = jsonDecode(raw[0]); // line 1 for get players

    // List listPlayJson = lineOne['Item']['Players'];

    List<Player> players = (lineOne['Item']['Players'])
        .map<Player>((p) => Player.fromJson(p))
        .toList();

    // Loop start with line two
    for (int i = 1; i < raw.length; i++) {
      // check kill
      if (raw[i].contains('Frags')) {
        // convert to json
        Map<String, dynamic> killerEvent = jsonDecode(raw[i]);

        // get player index
        int killerIndex = players.indexWhere(
            (element) => element.playerId == killerEvent['Item']['PlayerId']);

        // find victim
        int victimIndex = lookUpVictim(players, raw, i);

        Player killer = players[killerIndex];
        Player victim = players[victimIndex];

        if (victimIndex > -1) {
          killer.killed?.add(victim.name.toString());
        }

        print('killer === ${killer.toJson().toString()}, score === ${killerEvent["Item"]["Score"]}');
        print('victim === ${victim.toJson().toString()}');
      }
    }

    inspect(players);
    print(players.map((e) => e.toJson()).toList());
  }

  int lookUpVictim(List<Player> players, List<String> raw, int eventIndex) {
    for (int i = eventIndex - 1; i >= 0; i--) {
      if (raw[i].contains('Wounds')) {
        Map<String, dynamic> victim = jsonDecode(raw[i]);
        int victimIndex = players.indexWhere(
            (element) => element.playerId == victim['Item']['PlayerId']);
        return victimIndex;
      }
    }
    return -1;
  }

  @override
  void initState() {
    super.initState();
    readFIles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Title'),
      ),
      body: Container(),
    );
  }
}
