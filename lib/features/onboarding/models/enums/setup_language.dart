import '../../../../core/constants/assets_constants.dart';
import '../../../../core/localization/lang_keys.dart';

/// A language the setup questions offer, as a learner's own language or the
/// one to learn: its name and the flag shown beside it.
enum SetupLanguage {
  gujarati(LangKeys.languageGujarati, AssetsConstants.flagIndia),
  marathi(LangKeys.languageMarathi, AssetsConstants.flagIndia),
  hindi(LangKeys.languageHindi, AssetsConstants.flagIndia),
  englishUsa(LangKeys.languageEnglishUsa, AssetsConstants.flagUsa),
  french(LangKeys.languageFrench, AssetsConstants.flagFrance),
  englishUk(LangKeys.languageEnglishUk, AssetsConstants.flagUk),
  tamil(LangKeys.languageTamil, AssetsConstants.flagIndia),
  telugu(LangKeys.languageTelugu, AssetsConstants.flagIndia);

  const SetupLanguage(this.nameKey, this.flag);

  /// LangKeys key of its name.
  final String nameKey;

  /// The flag's SVG (AssetsConstants), multi-colour.
  final String flag;
}
