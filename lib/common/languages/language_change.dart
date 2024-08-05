import 'dart:developer';
import 'package:fixit_provider/common/languages/language_helper.dart';
import '../../config.dart';

class LanguageProvider with ChangeNotifier {
  String currentLanguage = appFonts.english;
  String selectLanguage = appFonts.english;
  Locale? locale;
  int selectedIndex = 0;
  final SharedPreferences sharedPreferences;

  LanguageProvider(this.sharedPreferences) {
    var selectedLocale = sharedPreferences.getString("selectedLocale");
    var listenIndex = sharedPreferences.getInt("index");
    if (listenIndex != null) {
      selectedIndex = listenIndex;
    } else {
      selectedIndex = 0;
    }

    if (selectedLocale != null) {
      locale = Locale(selectedLocale);
    } else {
      selectedLocale = "english";
      locale = const Locale("en");
    }
    setVal(selectedLocale);
  }

  LanguageHelper languageHelper = LanguageHelper();

  //on language selection radio tap
  onRadioChange(index, value) {
    selectedIndex = index;
    selectLanguage = value["title"];
    sharedPreferences.setInt("index", selectedIndex);

    notifyListeners();
  }

  //change language in locale
  changeLocale(String newLocale) {
    log("sharedPreferences a1: $selectLanguage");
    Locale convertedLocale;

    currentLanguage = selectLanguage;
    log("CURRENT $currentLanguage");
    convertedLocale = languageHelper.convertLangNameToLocale(selectLanguage);

    log("convertedLocale $convertedLocale");

    locale = convertedLocale;
    log("CURRENT LOCAL ${locale!.languageCode.toString()}");
    sharedPreferences.setString(
        'selectedLocale', locale!.languageCode.toString());
    notifyListeners();
  }


  //change language from onboard
  onBoardLanguageChange(String newLocale) {
    log("sharedPreferences a1: $newLocale");
    Locale convertedLocale;

    currentLanguage = newLocale;
    log("CURRENT $currentLanguage");
    convertedLocale = languageHelper.convertLangNameToLocale(newLocale);

    locale = convertedLocale;
    log("CURRENT LOCAL $locale");
    sharedPreferences.setString(
        'selectedLocale', locale!.languageCode.toString());
    notifyListeners();
  }

  //fetch saved language from shared pref
  getLocal() {
    var selectedLocale = sharedPreferences.getString("selectedLocale");
    return selectedLocale;
  }


  //set language value
  setVal(value) {
    if (value == "en") {
      currentLanguage = "english";
    } else if (value == "fr") {
      currentLanguage = "french";
    } else if (value == "es") {
      currentLanguage = "spanish";
    } else if (value == "ar") {
      currentLanguage = "arabic";
    } else {
      currentLanguage = "english";
    }
    notifyListeners();
    // changeLocale(currentLanguage);
  }
}

