import 'package:acservermanager/models/assists.dart';
import 'package:acservermanager/models/realism.dart';
import 'package:acservermanager/models/server/server_base_settings.dart';
import 'package:acservermanager/models/server/server_file_names.dart';
import 'package:acservermanager/models/session.dart';
import 'package:acservermanager/models/voting_banning.dart';
import 'package:equatable/equatable.dart';
import 'package:fluent_ui/fluent_ui.dart';

class Server extends ServerBaseSettings implements Equatable {
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
    return Server(
      name: _getStringFromData(data, ServerFileNames.serverName),
      adminPassword: _getStringFromData(data, ServerFileNames.adminPassword),
      httpPort: _getStringFromData(data, ServerFileNames.httpPort),
      udpPort: _getStringFromData(data, ServerFileNames.udpPort),
      tcpPort: _getStringFromData(data, ServerFileNames.tcpPort),
      packetHz: _getIntFromData(data, ServerFileNames.packetHz, 18),
      loopMode: _getBoolFromData(data, ServerFileNames.loopMode),
      password: _getStringFromData(data, ServerFileNames.password),
      pickupMode: _getBoolFromData(data, ServerFileNames.pickupModeEnabled),
      pickupLockedEntryList:
          _getBoolFromData(data, ServerFileNames.lockedEntryList),
      threads: _getIntFromData(data, ServerFileNames.numThreads, 2),
      showOnLobby: _getBoolFromData(data, ServerFileNames.registerToLobby),
      serverFilesPath: path,
    );
  }

  ///Returns the [String] value of the [key] in the [data] list.
  static String _getStringFromData(List<String> data, String key) {
    return data
        .firstWhere((element) => element.split('=').first == key)
        .split('=')
        .last;
  }

  ///Returns the [int] value of the [key] in the [data] list.
  static bool _getBoolFromData(List<String> data, String key) {
    return data
            .firstWhere((element) => element.split('=').first == key)
            .split('=')
            .last ==
        "1";
  }

  ///Returns the [int] value of the [key] in the [data] list.
  ///
  ///If none is found (or an error occurred), returns the [defaultValue].
  static int _getIntFromData(List<String> data, String key, int defaultValue) {
    int? result = int.tryParse(data
        .firstWhere((element) => element.split('=').first == key)
        .split('=')
        .last);
    if (result == null) {
      result = defaultValue;
      debugPrint('Using defaultValue for $key -> $defaultValue');
    }
    return result;
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

  @override
  List<Object?> get props => [
        name,
        password,
        httpPort,
        packetHz,
        tcpPort,
        udpPort,
        threads,
        session,
        assists,
        clientsAllowed,
        loopMode,
        pickupLockedEntryList,
        pickupMode,
        realism,
        resultScreenTime,
        showOnLobby,
        votingBanning,
        managerDescription,
        serverFilesPath
      ];

  @override
  bool? get stringify => true;
}
