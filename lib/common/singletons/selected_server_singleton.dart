import 'package:acservermanager/models/server.dart';

class SelectedServerSingleton {
  Server _server;
  Server get server => _server;

  SelectedServerSingleton(this._server);

  void setServer(Server server) {
    _server = server;
  }
}
