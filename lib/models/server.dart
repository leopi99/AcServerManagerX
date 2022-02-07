import 'package:acservermanager/models/assists.dart';
import 'package:acservermanager/models/server_base_settings.dart';
import 'package:acservermanager/models/session.dart';

class Server extends ServerBaseSettings {
  final Session session;
  final Assists assists;
  Server({
    String adminPassword = "admin",
    required String name,
    String? password,
    String httpPort = "80",
    int packetHz = 18,
    String tcpPort = "9600",
    String udpPort = "9600",
    int threads = 2,
    this.assists = const Assists(),
    this.session = const Session(),
  }) : super(
          name: name,
          adminPassword: adminPassword,
          httpPort: httpPort,
          packetHz: packetHz,
          password: password,
          tcpPort: tcpPort,
          threads: threads,
          udpPort: udpPort,
        );

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
      );
}
