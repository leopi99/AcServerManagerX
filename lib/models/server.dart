import 'package:acservermanager/models/assists.dart';
import 'package:acservermanager/models/realism.dart';
import 'package:acservermanager/models/server_base_settings.dart';
import 'package:acservermanager/models/session.dart';
import 'package:acservermanager/models/voting_banning.dart';
import 'package:fluent_ui/fluent_ui.dart';

class Server extends ServerBaseSettings {
  final Session session;
  final Assists assists;
  final Realism realism;
  final VotingBanning votingBanning;

  final bool pickupMode;
  final bool loopMode;
  final bool showOnLobby;
  final bool pickupLockedEntryList;
  final int resultScreenTime;
  final int clientsAllowed;
  final String? managerDescription;
  final String serverFilesPath;

  Server({
    String adminPassword = "admin",
    String name = "New Server",
    String? password,
    String httpPort = "80",
    int packetHz = 18,
    String tcpPort = "9600",
    String udpPort = "9600",
    int threads = 2,
    this.loopMode = true,
    this.pickupLockedEntryList = false,
    this.pickupMode = true,
    this.resultScreenTime = 60,
    this.showOnLobby = true,
    this.assists = const Assists(),
    this.session = const Session(),
    this.realism = const Realism(),
    this.votingBanning = const VotingBanning(),
    this.clientsAllowed = 12,
    this.managerDescription,
    required this.serverFilesPath,
  })  : assert(clientsAllowed >= 2 && clientsAllowed <= 24),
        super(
          name: name,
          adminPassword: adminPassword,
          httpPort: httpPort,
          packetHz: packetHz,
          password: password,
          tcpPort: tcpPort,
          threads: threads,
          udpPort: udpPort,
        );

  factory Server.fromFileData(List<String> data, String path) {
    //The file is read as List<String>, every item is a line in the file.
    debugPrint('From $path\n$data');
    return Server(
      name: data
          .firstWhere((element) => element.contains("NAME"))
          .split('=')
          .last,
      adminPassword: data
          .firstWhere((element) => element.contains("ADMIN_PASSWORD"))
          .split('=')
          .last,
      httpPort: data
          .firstWhere((element) => element.contains("HTTP_PORT"))
          .split('=')
          .last,
      udpPort: data
          .firstWhere((element) => element.contains("UDP_PORT"))
          .split('=')
          .last,
      tcpPort: data
          .firstWhere((element) => element.contains("TCP_PORT"))
          .split('=')
          .last,
      packetHz: int.tryParse(data
              .firstWhere(
                  (element) => element.contains("CLIENT_SEND_INTERVAL_HZ"))
              .split('=')
              .last) ??
          18,
      loopMode: data
              .firstWhere((element) => element.contains("LOOP_MODE"))
              .split('=')
              .last ==
          "1",
      password: data
          .firstWhere((element) => element.contains("PASSWORD"))
          .split('=')
          .last,
      pickupMode: data
              .firstWhere((element) => element.contains("PICKUP_MODE_ENABLED"))
              .split('=')
              .last ==
          "1",
      pickupLockedEntryList: data
              .firstWhere((element) => element.contains("LOCKED_ENTRY_LIST"))
              .split('=')
              .last ==
          "1",
      threads: int.tryParse(data
              .firstWhere((element) => element.contains("THREADS"))
              .split('=')
              .last) ??
          2,
      showOnLobby: data
              .firstWhere((element) => element.contains("REGISTER_TO_LOBBY"))
              .split('=')
              .last ==
          "1",
      serverFilesPath: path,
    );
  }

  String get cfgFilePath => '$serverFilesPath/server_cfg.ini';
  String get entryListPath => '$serverFilesPath/entry_list.ini';

  Server copyWith({
    String? adminPassword,
    String? name,
    String? password,
    String? httpPort,
    int? packetHz,
    String? tcpPort,
    String? udpPort,
    int? threads,
    Session? session,
    Assists? assists,
    int? clientsAllowed,
    bool? loopMode,
    bool? pickupLockedEntryList,
    bool? pickupMode,
    Realism? realism,
    int? resultScreenTime,
    bool? showOnLobby,
    VotingBanning? votingBanning,
    String? managerDescription,
    String? serverFilesPath,
  }) =>
      Server(
        adminPassword: adminPassword ?? this.adminPassword,
        name: name ?? this.name,
        password: password ?? this.password,
        httpPort: httpPort ?? this.httpPort,
        packetHz: packetHz ?? this.packetHz,
        tcpPort: tcpPort ?? this.tcpPort,
        threads: threads ?? this.threads,
        udpPort: udpPort ?? this.udpPort,
        assists: assists ?? this.assists,
        session: session ?? this.session,
        clientsAllowed: clientsAllowed ?? this.clientsAllowed,
        loopMode: loopMode ?? this.loopMode,
        pickupLockedEntryList:
            pickupLockedEntryList ?? this.pickupLockedEntryList,
        pickupMode: pickupMode ?? this.pickupMode,
        realism: realism ?? this.realism,
        resultScreenTime: resultScreenTime ?? this.resultScreenTime,
        showOnLobby: showOnLobby ?? this.showOnLobby,
        votingBanning: votingBanning ?? this.votingBanning,
        managerDescription: managerDescription ?? this.managerDescription,
        serverFilesPath: serverFilesPath ?? this.serverFilesPath,
      );
}
