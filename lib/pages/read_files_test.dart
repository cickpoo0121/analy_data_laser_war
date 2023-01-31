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
      "F:/Freelance/fotoclubProject/POC/read_files_test/app_ver/assets/RealtimeStatistics_1.json";
  final killScore = 5;

  void readFIles() {
    File file = File(souceFile);
    List<String> raw = file.readAsLinesSync();
    // inspect(raw);

    Map<String, dynamic> lineOne = jsonDecode(raw[0]); // line 1 for get players
    // inspect(lineOne['Item']['Players']);

    List listPlayJson = lineOne['Item']['Players'];
    // inspect(listPlayJson);

    List<Player> players =
        listPlayJson.map<Player>((p) => Player.fromJson(p)).toList();
    // inspect(players);

    // Loop start with line two
    for (int i = 1; i < raw.length; i++) {
      // print(raw[i]);

      // Have events score and hits
      if (raw[i].contains('Score')) {
        // print('score, hits');

        // convert to json
        Map<String, dynamic> killerEvent = jsonDecode(raw[i]);

        // get player index
        int killerIndex = players.indexWhere(
            (element) => element.playerId == killerEvent['Item']['PlayerId']);

        // update player score
        int? pastScore = players[killerIndex].score;
        players[killerIndex].score = killerEvent['Item']['Score'];
        int? nowScore = players[killerIndex].score;

        // print('score calcuated:${nowScore! - pastScore!}');
        // print('${nowScore} - ${pastScore}');

        // add killed when score gap equal 5
        if (
            // nowScore! - pastScore! >= killScore
            // &&
            raw[i].contains('Frags')) {
          // print('has score and hits then to check get 5 point or not');

          Map<String, dynamic> victim = jsonDecode(raw[i - 1]);
          int victimIndex = players.indexWhere(
              (element) => element.playerId == victim['Item']['PlayerId']);
          players[killerIndex]
              .killed!
              .add(players[victimIndex].name.toString());

          // print(
          //   'killerId: ${players[killerIndex].playerId} ===== ${raw[i]}',
          // );
          // print(
          //   'victimId: ${players[victimIndex].playerId} ===== ${raw[i-1]} \n',
          // );

          print(
            'killerId: ${players[killerIndex].playerId} ===== ${raw[i]}',
          );
          print(
            'victimId: ${players[victimIndex].playerId} ===== ${raw[i - 1]} \n',
          );
        }
      }
    }

    inspect(players);
    print(players.map((e) => e.toJson()).toList().toString());
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
