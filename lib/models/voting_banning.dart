import 'package:acservermanager/models/enums/blacklist_enum.dart';

class VotingBanning {
  final int kickQuorum;
  final int sessionQuorum;
  final int maxCollisions;
  final BlackList blackList;

  const VotingBanning({
    this.kickQuorum = 70,
    this.sessionQuorum = 70,
    this.maxCollisions = 5,
    this.blackList = BlackList.kickPlayer,
  });

  VotingBanning copyWith({
    int? kickQuorum,
    int? sessionQuorum,
    int? maxCollisions,
    BlackList? blackList,
  }) {
    return VotingBanning(
      kickQuorum: kickQuorum ?? this.kickQuorum,
      sessionQuorum: sessionQuorum ?? this.sessionQuorum,
      maxCollisions: maxCollisions ?? this.maxCollisions,
      blackList: blackList ?? this.blackList,
    );
  }
}
