# Assetto Corsa Server Manager X <a title="Made with Fluent Design" href="https://github.com/bdlukaa/fluent_ui"><img src="https://img.shields.io/badge/fluent-design-blue?style=flat-square&color=7A7574&labelColor=0078D7"/></a>

This app is rewritten using the Flutter framework.
Since this app uses Windows level apis is locked to the Windows platform.
In the future (since Steam's proton makes assetto corsa work on Linux) will be tested and unlocked for Windows and Linux; for now is in development only the Windows version.

## Why use this app?

The main concept of this app is not to recreate something that works, instead to create an app that "overrides" the stock one, with a much more modern ui and performance improvements.

## What are the implemented features?

- [x] Reads the previously created servers.
- [x] Reads installed tracks (Not completely implemented, some errors in stock tracks with layouts).
- [ ] Reads the installed cars.
- [ ] Saves the changes.
- [ ] Creates new servers.
- [ ] Selects the server that can be started from the .bat file.

## Run the app from the repo's clone

In order to run/compile the app from this repo you need the Flutter framework installed ([Flutter get started](https://docs.flutter.dev/get-started/install)).
After the flutter install, you can run the app in debug mode by entering this command (inside the cloned folder, where the main.dart file is located) `flutter run -d windows`.
To compile the app use this command `flutter build windows`.
For more informations on Flutter Desktop see [Flutter desktop](https://flutter.dev/multi-platform/desktop).

## Localizations

The app supports localizations, currently for the following languages:

- English
- Italian

Want to add your language? Clone the repository, create the file yourCountryCode.json inside the directory assets/translations, copy the content of another file and translate it; then run this command: `flutter pub run easy_localization:generate -S assets/translations -O lib/generated-translations`
