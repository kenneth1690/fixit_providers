

/// Country element. This is the element that contains all the information
class CountryCodeCustom {
  /// the name of the country
  String? name;

  /// the flag of the country
  String? flagUri;

  /// the country code (IT,AF..)
  String? code;

  /// the dial code (+39,+93..)
  String? dialCode;

  CountryCodeCustom({this.name, this.flagUri, this.code, this.dialCode});

  @override
  String toString() => "$dialCode";

  String toLongString() => "$dialCode $name";

  String toCountryStringOnly() => '$name';
}
