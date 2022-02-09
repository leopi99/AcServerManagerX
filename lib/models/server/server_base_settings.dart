abstract class ServerBaseSettings {
  final String name;
  final String? password;
  final String adminPassword;
  final String udpPort;
  final String tcpPort;
  final String httpPort;
  final int packetHz;
  final int threads;

  const ServerBaseSettings({
    this.adminPassword = "admin",
    required this.name,
    this.password,
    this.httpPort = "80",
    this.packetHz = 18,
    this.tcpPort = "9600",
    this.udpPort = "9600",
    this.threads = 2,
  }) : assert(threads > 1);
}
