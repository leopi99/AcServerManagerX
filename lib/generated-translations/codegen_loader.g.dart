// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>> load(String fullPath, Locale locale ) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> en = {
  "ops_error": "Ops! Something went wrong",
  "app_title": "Assetto Corsa Server Manager X",
  "app_reset": "Reset the app",
  "splash_loading": "Loading...",
  "select_server": "Select server",
  "select_server_edit": "Select the server to edit",
  "ok": "Ok",
  "dark_mode": "Dark Mode",
  "light_mode": "Light Mode",
  "close_dialog_server_change": "Close the dialog when the selected server is changed",
  "server_name": "Server name",
  "password": "Password",
  "admin": "Admin",
  "select_ac_path": "Select the installation path of AC",
  "open_dir_picker": "Open directory picker",
  "set_path": "Set path",
  "app_language": "App language"
};
static const Map<String,dynamic> it = {
  "ops_error": "Ops! Qualcosa e andato storto",
  "app_title": "Assetto Corsa Server Manager X",
  "app_reset": "Reimposta l'app",
  "splash_loading": "Caricamento...",
  "select_server": "Seleziona il server",
  "select_server_edit": "Seleziona il server da modificare",
  "ok": "Ok",
  "dark_mode": "Dark Mode",
  "light_mode": "Light Mode",
  "close_dialog_server_change": "Chiudi il dialog quando il server selezionato cambia",
  "server_name": "Nome server",
  "password": "Password",
  "admin": "Admin",
  "select_ac_path": "Seleziona la cartella di installazione di AC",
  "open_dir_picker": "Apri il selettore della cartella",
  "set_path": "Imposta la cartella",
  "app_language": "Lingua applicazione"
};
static const Map<String, Map<String,dynamic>> mapLocales = {"en": en, "it": it};
}
