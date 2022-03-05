import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';

/// IT strings for the fluent widgets.
///
/// See also:
///
///  * [FluentApp.localizationsDelegates], which automatically includes
///  * [DefaultFluentLocalizations.delegate] by default.
class ITFluentLocalizations implements FluentLocalizations {
  const ITFluentLocalizations();

  @override
  String get backButtonTooltip => 'Indietro';

  @override
  String get closeButtonLabel => 'Chiudi';

  @override
  String get searchLabel => 'Cerca';

  @override
  String get closeNavigationTooltip => 'Chiudi navigazione';

  @override
  String get openNavigationTooltip => 'Apri navigazione';

  @override
  String get clickToSearch => 'Premi per cercare';

  @override
  String get modalBarrierDismissLabel => 'Scarta';

  @override
  String get minimizeWindowTooltip => 'Minimizza';

  @override
  String get restoreWindowTooltip => 'Ripristina';

  @override
  String get closeWindowTooltip => 'Chiudi';

  @override
  String get dialogLabel => 'Dialog';

  @override
  String get cutActionLabel => 'Taglia';

  @override
  String get copyActionLabel => 'Copia';

  @override
  String get pasteActionLabel => 'Incolla';

  @override
  String get selectAllActionLabel => 'Seleziona tutto';

  @override
  String get newTabLabel => 'Nuovo tab';

  @override
  String get closeTabLabel => 'Chiudi il tab (Ctrl+F4)';

  @override
  String get scrollTabBackwardLabel => 'Scrolla al tab precedente';

  @override
  String get scrollTabForwardLabel => 'Scrolla al tab successivo';

  @override
  String get noResultsFoundLabel => 'Nessun risultato trovato';

  String get _ctrlCmd {
    if (defaultTargetPlatform == TargetPlatform.macOS) {
      return 'Cmd';
    }
    return 'Ctrl';
  }

  @override
  String get cutShortcut => '$_ctrlCmd+X';

  @override
  String get copyShortcut => '$_ctrlCmd+C';

  @override
  String get pasteShortcut => '$_ctrlCmd+V';

  @override
  String get selectAllShortcut => '$_ctrlCmd+A';

  @override
  String get copyActionTooltip =>
      'Copia il contenuto selezionato negli appunti';

  @override
  String get cutActionTooltip =>
      'Rimuovi il contenuto selezionato e inseriscilo negli appunti';

  @override
  String get pasteActionTooltip =>
      'Inscerisci il contenuto degli appunti nella posizione attuale';

  @override
  String get selectAllActionTooltip => 'Seleziona tutto il contenuto';

  /// Creates an object that provides US English resource values for the fluent
  /// library widgets.
  ///
  /// The [locale] parameter is ignored.
  ///
  /// This method is typically used to create a [LocalizationsDelegate].
  /// The [FluentApp] does so by default.
  static Future<FluentLocalizations> load(Locale locale) {
    return SynchronousFuture<FluentLocalizations>(
        const ITFluentLocalizations());
  }

  static const LocalizationsDelegate<FluentLocalizations> delegate =
      _FluentITLocalizationsDelegate();
}

class _FluentITLocalizationsDelegate
    extends LocalizationsDelegate<FluentLocalizations> {
  const _FluentITLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'it';

  @override
  Future<FluentLocalizations> load(Locale locale) =>
      DefaultFluentLocalizations.load(locale);

  @override
  bool shouldReload(_FluentITLocalizationsDelegate old) => false;

  @override
  String toString() => 'DefaultFluentLocalizations.delegate(it_IT)';
}
