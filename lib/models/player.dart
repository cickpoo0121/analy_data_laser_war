class Player {
  int? playerId;
  String? name;
  String? nickname;
  String? team;
  int? score;
  List<String>? killed;

  Player({
    this.playerId,
    this.name,
    this.nickname,
    this.team,
    this.score,
    this.killed,
  });

  factory Player.fromJson(Map<String, dynamic> json) => Player(
        playerId: json['PlayerId'] ?? 0,
        name: json['Name'] ?? '',
        nickname: json['Nickname'] ?? '',
        team: json['Team'] ?? '',
        score: json['Score'] ?? 0,
        killed: json['killed'] ?? [],
      );

  Map<String, dynamic> toJson() => {
        "PlayerId": playerId,
        "Name": name,
        "Nickname": nickname,
        "Team": team,
        'score': score,
        "killed": killed.toString(),
      };
}
