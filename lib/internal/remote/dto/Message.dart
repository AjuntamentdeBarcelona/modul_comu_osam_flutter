import 'package:common_module_flutter/osam/src/VersionControlResponse.dart';

class Message {
  String ca;
  String en;
  String es;

  Message({this.ca, this.en, this.es});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      ca: json['ca'],
      en: json['en'],
      es: json['es'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ca'] = this.ca;
    data['en'] = this.en;
    data['es'] = this.es;
    return data;
  }
}

extension Extensions on Message {
  String withLanguage(Language language) {
    switch (language) {
      case Language.CA:
        return this.ca;
      case Language.ES:
        return this.es;
      case Language.EN:
        return this.en;
      default:
        return this.ca;
    }
  }
}
