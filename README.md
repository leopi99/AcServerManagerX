# Assetto Corsa Server Manager X <a title="Made with Fluent Design" href="https://github.com/bdlukaa/fluent_ui"><img src="https://img.shields.io/badge/fluent-design-blue?style=flat-square&color=7A7574&labelColor=0078D7"/></a>

This app is written using the Flutter framework.
Since this app uses Windows level apis is currently locked to the Windows platform.
In the future (since Steam's proton makes assetto corsa work on Linux) will be tested and unlocked for Windows and Linux; for now is in development only the Windows version.

This is still a project in the beta state, it can mess with your server configuration

#### **Table of contents**
  - [Why use this app?](#why-use-this-app)
  - [What are the implemented features?](#what-are-the-implemented-features)
  - [What is missing?](#what-is-missing)
  - [Run the app from the repo's clone](#run-the-app-from-the-repos-clone)
  - [Localizations](#localizations)
  - [Known problems](#known-problems)
  - [Info](#info)

## Why use this app?

The main concept of this app is not to recreate something that works, but to create an app that can be used instead of the stock one, with a much more modern ui and performance improvements.
Also, automatically saves the changes.

## What are the implemented features?

- [x] Reads the previously created servers.
- [x] Reads installed tracks.
- [x] Reads the installed cars.
- [x] Saves the changes when something is changed.
- [X] Creates new servers.
- [X] Selects the server that can be started from the .bat file.
- [x] Start the server inside the app.
- [ ] Allows to change all settings. (see What is missing for more info)
- [x] Search the cars with filters.
- [ ] Updates check.

## What is missing?

- Read the configured assists.
- Read the banning settings.
- Set/Read the server description
- Read the max thread for the current pc.

## Run the app from the repo's clone

In order to run/compile the app from this repo you need the Flutter framework installed [Flutter get started](https://docs.flutter.dev/get-started/install).
After the flutter install, you can run the app in debug mode by entering this command (inside the cloned folder, where the main.dart file is located) `flutter run -d windows`.
To compile the app use this command `flutter build windows`.
For more informations on Flutter Desktop see [Flutter desktop](https://flutter.dev/multi-platform/desktop).

## Localizations

The app supports localizations, currently for the following languages:

- English
- Italian

Feel free to ask for new feature that you find interesting and/or contribute to the project.

## Known problems

- Some cars have a bad formatted json file and can not be read. (ex. vrc_1997_ferrari_f310b)
- Some livelries (for the selected cars) are not read at startup.

## Info
If you find any problems while using the application, you can share the log file (server_manager_x.log, located inside the installation path of assetto corsa selected at the first start of the application) with the developer, or inside the issue to help resolve the issue faster.