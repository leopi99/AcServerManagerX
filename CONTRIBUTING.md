# How to contribute

## Contributing to AC Manager X translation

Create the file yourCountryCode.json inside the directory assets/translations, copy the content of another file and translate it; then run this command: `flutter pub run easy_localization:generate -S assets/translations -O lib/generated-translations`, copy the fluent_localizations_delegate_it.dart (inside the lib/common/custom_delegates folder) or the DefaultFluentLocalizations inside the localization.dart file and translate it (remember to change the supported locale).
For the last step you only need to add the localization delegate that you have just created to the localizationsDelegates argument in the FluentApp Widget (main.dart).