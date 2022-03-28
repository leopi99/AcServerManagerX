import 'dart:io';

import 'package:acservermanager/common/logger.dart';
import 'package:acservermanager/models/assists.dart';
import 'package:acservermanager/models/car.dart';
import 'package:acservermanager/models/realism.dart';
import 'package:acservermanager/models/server/server_base_settings.dart';
import 'package:acservermanager/models/server/server_file_names.dart';
import 'package:acservermanager/models/session.dart';
import 'package:acservermanager/models/voting_banning.dart';
import 'package:acservermanager/models/weather.dart';
import 'package:equatable/equatable.dart';

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
  final List<Car> cars;

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
    this.cars = const [],
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
      name: getStringFromData(data, ServerFileNames.serverName),
      adminPassword: getStringFromData(data, ServerFileNames.adminPassword),
      httpPort: getStringFromData(data, ServerFileNames.httpPort),
      udpPort: getStringFromData(data, ServerFileNames.udpPort),
      tcpPort: getStringFromData(data, ServerFileNames.tcpPort),
      packetHz: _getIntFromData(data, ServerFileNames.packetHz, 18),
      loopMode: _getBoolFromData(data, ServerFileNames.loopMode),
      password: getStringFromData(data, ServerFileNames.password),
      pickupMode: _getBoolFromData(data, ServerFileNames.pickupModeEnabled),
      pickupLockedEntryList:
          _getBoolFromData(data, ServerFileNames.lockedEntryList),
      threads: _getIntFromData(data, ServerFileNames.numThreads, 2),
      showOnLobby: _getBoolFromData(data, ServerFileNames.registerToLobby),
      session: Session(weather: Weather.fromServerData(data)),
      serverFilesPath: path,
    );
  }

  ///Returns the [String] value of the [key] in the [data] list.
  static String getStringFromData(List<String> data, String key) {
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
      Logger().log('Using defaultValue for $key -> $defaultValue');
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
    List<Car>? cars,
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
        cars: cars ?? this.cars,
      );

  ///Returns the cars previously saved
  Future<List<Map<String, String>>> getSavedCars() async {
    const int carLineLength = 9;
    List<Map<String, String>> cars = [];
    final file = File(entryListPath);
    final List<String> fileData = await file.readAsLines();
    List<List<String>> subCars = [];
    final int carLength = (await file.readAsLines()).length ~/ carLineLength;
    for (int i = 0; i < carLength; i++) {
      //Note: The +1 for the start of the sublist is to avoid the empty line at the end of each car (not applicable for the first line obv)
      subCars.add(fileData.sublist((i * carLineLength) + (i == 0 ? 0 : 1),
          (i * carLineLength) + carLineLength));
    }
    for (List<String> car in subCars) {
      final carName = getStringFromData(car, "MODEL");
      final skinName = getStringFromData(car, "SKIN");
      if (cars.any((element) => element.keys.contains(carName))) {
        Map<String, String> carMap =
            cars.firstWhere((element) => element.keys.contains(carName));
        carMap[carName] = "${carMap[carName]},$skinName";
      } else {
        cars.add({carName: skinName});
      }
    }
    return cars;
  }

  ///Returns the number of skins added to the server
  int get skinLength {
    int length = 0;
    for (var element in cars) {
      length += element.skins.length;
    }
    return length;
  }

  ///TODO: complete
  ///
  ///Returns the List<String> of this [Server] to be written to a file.
  List<String> toStringList() {
    return [
      '[SERVER]',
      'NAME=$name',
      'CARS=${cars.map((e) => e.path.split("/").last).toList().join(";")}',
      'CONFIG_TRACK=${(session.selectedTrack?.layouts.length ?? 0) > 1 ? session.selectedTrack?.layouts.first.path.split('/').last ?? "" : ""}',
      'TRACK=${session.selectedTrack?.path.split("/").last ?? ""}',
      'SUN_ANGLE=32',
      'PASSWORD=$password',
      'ADMIN_PASSWORD=$adminPassword',
      'UDP_PORT=$udpPort',
      'TCP_PORT=$tcpPort',
      'HTTP_PORT=$httpPort',
      'MAX_BALLAST_KG=0',
      'QUALIFY_MAX_WAIT_PERC=120',
      'RACE_PIT_WINDOW_START=0',
      'RACE_PIT_WINDOW_END=0',
      'REVERSED_GRID_RACE_POSITIONS=0',
      'LOCKED_ENTRY_LIST=0',
      'PICKUP_MODE_ENABLED=${pickupMode ? "1" : "0"}',
      'LOOP_MODE=${loopMode ? "1" : "0"}',
      'SLEEP_TIME=1',
      'CLIENT_SEND_INTERVAL_HZ=18',
      'SEND_BUFFER_SIZE=0',
      'RECV_BUFFER_SIZE=0',
      'RACE_OVER_TIME=180',
      'KICK_QUORUM=${votingBanning.kickQuorum}',
      'VOTING_QUORUM=${votingBanning.sessionQuorum}',
      'VOTE_DURATION=20',
      'BLACKLIST_MODE=1',
      'FUEL_RATE=${realism.fuelRate}',
      'DAMAGE_MULTIPLIER=${realism.damageRate}',
      'TYRE_WEAR_RATE=${realism.tyreWearRate}',
      'ALLOWED_TYRES_OUT=${realism.allowedTyresOut}',
      'ABS_ALLOWED=1',
      'TC_ALLOWED=1',
      'START_RULE=0',
      'RACE_GAS_PENALTY_DISABLED=0',
      'TIME_OF_DAY_MULT=${session.weather.timeOfDayMultiplier}',
      'RESULT_SCREEN_TIME=60',
      'MAX_CONTACTS_PER_KM=0',
      'STABILITY_ALLOWED=0',
      'AUTOCLUTCH_ALLOWED=0',
      'TYRE_BLANKETS_ALLOWED=${assists.tyreBlankets ? "1" : "0"}',
      'FORCE_VIRTUAL_MIRROR=${assists.forceVirtualMirror ? "1" : "0"}',
      'REGISTER_TO_LOBBY=1',
      'MAX_CLIENTS=$clientsAllowed',
      'NUM_THREADS=$threads',
      'UDP_PLUGIN_LOCAL_PORT=0',
      'UDP_PLUGIN_ADDRESS=',
      'AUTH_PLUGIN_ADDRESS=',
      'LEGAL_TYRES=',
      'WELCOME_MESSAGE=',
      '[FTP]',
      'HOST=',
      'LOGIN=',
      'PASSWORD=/jpvSl+rBcFueJ7MXIqDZg==',
      'FOLDER=',
      'LINUX=0',
      '[PRACTICE]',
      ...session.practice.toStringList(),
      '[DYNAMIC_TRACK]',
      'SESSION_START=96',
      'RANDOMNESS=2',
      'SESSION_TRANSFER=100',
      'LAP_GAIN=22',
      '[WEATHER_0]',
      ...session.weather.toStringList(),
      '[DATA]',
      'DESCRIPTION=',
      'EXSERVEREXE=',
      'EXSERVERBAT=',
      'EXSERVERHIDEWIN=0',
      'WEBLINK=',
      'WELCOME_PATH=',
    ];
  }

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
        serverFilesPath,
        cars,
      ];

  @override
  bool? get stringify => true;
}
