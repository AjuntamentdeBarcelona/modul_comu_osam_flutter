# modul_comu_osam_flutter
[![](https://jitpack.io/v/AjuntamentdeBarcelona/modul_comu_osam.svg)](https://jitpack.io/#AjuntamentdeBarcelona/modul_comu_osam_flutter)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![License](https://img.shields.io/badge/License-BSD%203--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)
# README
## Com es fa servir?
- Afegeix aquesta dependència al pubspec:
```
common_module_flutter:
    git:
      url: https://github.com/AjuntamentdeBarcelona/modul_comu_osam_flutter.git
      ref: '1.0.0'
```

- Actualitzar mitjançant el comandament 'flutter packages get' les dependències.

- Afegir el import on sigui necessari:
```
import 'package:common_module_flutter/osam/OSAM.dart';
```

- Per utilitzar la llibreria, necessitem crear una instància de la classe OSAM i cridar al mètode init
abans de fer servir qualsevol dels mètodes.
Aquí tenim un example de inicialització.

```
class DI {
  static SharedPreferences _prefs;

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    await _osamSdk.init();
  }

  static OSAM _osamSdk = OSAM("b3NhbTpvc2Ft");
  static final Settings settings = AppPreferences(_prefs);
  static final OsamRepository osamRepository =
      OsamRepositoryImpl(_osamSdk, settings);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DI.initialize();
  runApp(MyApp());
}
```
En el cas de l'app d'exemple, accedim a la instància creada a través de 'OsamRepository':
```
 Future<VersionControlResponse> checkForUpdates(BuildContext context) async {
    return osamSdk.versionControl(
      context,
      language: _getLanguage(settings.getLanguage()),
    );
  }

  @override
  Future<RatingControlResponse> checkRating(BuildContext context) async {
    return osamSdk.rating(context,
        language: _getLanguage(settings.getLanguage()));
  }
```

## Introducció

Aquest mòdul uneix el control de versions i el control de valoracions.

En el control de versions es mostrarà un avís quan el servei avisi que hi ha una nova versió de l'app.
Aquesta alerta la podem mostrar amb un missatge amb botons de confirmació d'accions.

Tindrem tres diferents tipus d'alerta:

1. Informativa: Alerta amb un missatge i / o un títol informatiu, amb un botó d ' "ok" per confirmar que s'ha llegit.
2. Restrictiva: Alerta amb un missatge i / o un títol, amb botó d ' "ok" que un cop fet clic redirigirà l'usuari a una url.
3. Permisiva: Alerta amb un missatge i / o un títol, amb botons de "ok" i "cancel". Si fem clic al botó de cancel·lar l'alerta desapareixerà, i si ho fem al de confirmar s'obrirà una url.

Pel que respecta al control de valoracions, la seva funcionalitat és mostrar periòdicament una popup que convida a l’usuari a deixar un comentari sobre l'app al market place corresponent (Google Play o AppStore).
Per a Android, el popup té tres botons:

- Positiu (“VALORAR ARA”): El sistema obre la web de l’app client en el market, i l’usuari només haurà de fer ‘new review’ i deixar el seu comentari i valoració sobre l’app.
- Negatiu (“NO, GRÀCIES”).  El popup es tanca i no tornarà a aparèixer.
- Neutre (“MÉS TARD”). El popup es tanca i tornarà a aparèixer en un futur.

En canvi, per a iOS s'utilitza un package de flutter que mostrarà el popup natiu.

## Descàrrega del mòdul
Des de la OSAM es proporcionen mòduls per realitzar un conjunt de tasques comunes a totes les apps publicades per l'Ajuntament de Barcelona.

El mòdul comú (Flutter) està disponible com a repositori a:
https://github.com/AjuntamentdeBarcelona/modul_comu_osam

## Implementació control de versions

Per crear el missatge d'alerta, únicament hem de cridar a la funció que descarregarà el json amb les variables ja definides i mostrarà l'alerta segons els valors rebuts.

La signatura del mètode és la següent:
```
Future<VersionControlResponse> versionControl(
    BuildContext context, {
    @required Language language,
  })
```
Paràmetres d'entrada:
- context: BuildContext del widget des d'on estem cridant al control de versions
- language: Objecte de tipus Language (pertany al mòdul comú). Actualment, hi ha suportats 3 idiomes:
    - Language.CA: Català
    - Language.ES: Castellà
    - Language.EN: Anglès

Paràmetres de sortida:
- versionControlResponse: Objecte de tipus VersionControlResponse. Els valors de retorn són els següents:
    - VersionControlResponse.ACCEPTED: si l'usuari ha escollit el botó d'acceptar/ok
    - VersionControlResponse.DISMISSED: si l'usuari ha tret el popup
    - VersionControlResponse.CANCELLED: si l'usuari ha escollit el botó de cancel·lar
    - VersionControlResponse.ERROR: si hi ha hagut cap error al procés d'obtenir la informació necessaria o al mostrar el popup
    - VersionControlResponse.NOT_NEEDED: si no és necessari mostrar el popup

Exemple:
```
void _onVersionControl() async {
    final result = await DI.osamSdk.versionControl(
      context,
      language: Language.CA,
    );

    switch (result) {
      case VersionControlResponse.ACCEPTED:
        break;
      case VersionControlResponse.DISMISSED:
        break;
      case VersionControlResponse.CANCELLED:
        break;
      case VersionControlResponse.ERROR:
        break;
      case VersionControlResponse.NOT_NEEDED:
        break;
    }
  }
```
No és necessari capturar la resposta si no es necessita realitzar cap acció adicional, ja que el mòdul comú s'encarregarà de mostrar el popup si es compleixen els requeriments per a que es mostri

##### Mostrar el control de versions cada vegada que l'app torna a primer pla
Si és necessari executar el control de versions cada vegada que l'app torna a primer pla, a l'app demo hem impleentat aquesta funcionalitat en un mixin anomenat OsamVersionChecker:
```
class _MyHomePageState extends State<MyHomePage> with OsamVersionChecker {
```
Hem utilitzat el package https://pub.dev/packages/flutter_fgbg:
```
mixin OsamVersionChecker<T extends StatefulWidget> on State<T> implements RouteAware {
  StreamSubscription<FGBGType> subscription;

@override
  void initState() {
    super.initState();
    subscription = FGBGEvents.stream.listen((event) async {
      if (event.toString() == "FGBGType.foreground") {
        await DI.osamRepository.checkForUpdates(context);
      }
    });
  }
```

## Implementació control de valoració`

Per crear el missatge d'alerta, únicament hem de cridar a la funció que descarregarà el json amb les variables ja definides i mostrarà l'alerta segons els valors rebuts.

La signatura del mètode és la següent:
```
Future<RatingControlResponse> rating(
    BuildContext context, {
    @required Language language,
  }) async {
```
Paràmetres d'entrada:
- context: BuildContext del widget des d'on estem cridant al control de versions
- language: Objecte de tipus Language (pertany al mòdul comú). Actualment, hi ha suportats 3 idiomes:
    - Language.CA: Català
    - Language.ES: Castellà
    - Language.EN: Anglès

Paràmetres de sortida:
- ratingControlResponse: Objecte de tipus RatingControlResponse. Els valors de retorn són els següents:
    - RatingControlResponse.ACCEPTED: si l'usuari ha escollit el botó d'acceptar/ok
    - RatingControlResponse.DISMISSED: si l'usuari ha tret el popup
    - RatingControlResponse.CANCELLED: si l'usuari ha escollit el botó de cancel·lar
    - RatingControlResponse.ERROR: si hi ha hagut cap error al procés d'obtenir la informació necessaria o al mostrar el popup
    - RatingControlResponse.NOT_NEEDED: si no és necessari mostrar el popup
    - RatingControlResponse.HANDLED_BY_SYSTEM: valor que es retorna sempre a iOS, ja que a iOS no tenim cap control sobre l'acció de l'usuari

Exemple:
```
void _onRating() async {
    final result = await DI.osamSdk.rating(
      context,
      language: Language.EN,
    );

    switch (result) {
      case RatingControlResponse.ACCEPTED:
        break;
      case RatingControlResponse.DISMISSED:
        break;
      case RatingControlResponse.CANCELLED:
        break;
      case RatingControlResponse.ERROR:
        break;
      case RatingControlResponse.NOT_NEEDED:
        break;
      case RatingControlResponse.HANDLED_BY_SYSTEM:
        break;
    }
  }
```
No és necessari capturar la resposta si no es necessita realitzar cap acció adicional, ja que el mòdul comú s'encarregarà de mostrar el popup si es compleixen els requeriments per a que es mostri

## Format JSONs
### Control de Versions
```
"data": {
        "id": 109,
        "appId": 400,
        "packageName": "cat.bcn.commonmodule",
        "versionCode": 2021050000,
        "versionName": "1.0.0",
        "platform": "IOS",
        "comparisonMode": "NONE",
        "title": {
            "es": "TITLE_ES",
            "en": "TITLE_EN",
            "ca": "TITLE_CA"
        },
        "message": {
            "es": "MESSAGE_ES",
            "en": "MESSAGE_EN",
            "ca": "MESSAGE_CA"
        },
        "ok": {
            "es": "OK",
            "en": "OK",
            "ca": "OK"
        },
        "cancel": {
            "es": "Cancelar",
            "en": "Cancel",
            "ca": "Cancel.lar"
        },
        "url": "https://apps.apple.com/es/app/barcelona-a-la-butxaca/id1465234509?l=ca"
    }
```
#### Paràmetres
- packageName
    - Obligatori
    - Especifica el ApplicationID o BundleID de l'app que afecta
- versionCode
  - Obligatori
  - Especifica la versió a la que afecta el control de versions
- platform
  - Obligatori
  - Especifica per a quina plataforma (ANDROID o IOS) afecta
- comparisonMode
    - Obligatori
    - Especifica la manera de comparació de la versió de l'app amb el mòdul
- title
    - Obligatori
    - Títol de l'alerta en el cas que s'hagi de mostrar.
- message
    - Obligatori
    - Missatge de l'alerta en cas que s'hagi de mostrar.
- ok
    - Opcional
    - Títol del botó d'acceptar.
    - Si es rep aquest paràmetre juntament amb el paràmetre okButtonActionURL, es mostrarà en l'alerta un botó d'acceptar que obrirà el link que s'ha especificat en el paràmetre okButtonActionURL.
- cancel
    - Opcional
    - Títol del botó de cancel·lar
- url
    - Opcional
    - Link que s'obrirà quan l'usuari seleccioni el botó d'acceptar. Per exemple: link de la nova versió de l'aplicació a l'App Store / Google Play.

### Control de Valoracions
```
"data": {
        "id": 74,
        "appId": 401,
        "appStoreIdentifier": "1234567890",
        "packageName": "cat.bcn.commonmodule",
        "platform": "ANDROID",
        "minutes": 2880,
        "numAperture": 5,
        "message": {
            "es": "MESSAGE_ES",
            "en": "MESSAGE_EN",
            "ca": "MESSAGE_CA"
        }
    }
```
#### Paràmetres
- appStoreIdentifier
  - Obligatori
  - Especifica el id de l'app al AppStore per poder valorar-la
- packageName
    - Obligatori
    - Especifica el ApplicationID o BundleID de l'app que afecta
- platform
  - Obligatori
  - Especifica per a quina plataforma (ANDROID o IOS) afecta
- minutes
    - Obligatori
    - Especifica el temps (en minuts) que ha de passar perquè surti el popup
- numAperture
    - Obligatori
    - Especifica la quantitat de vegades que s'ha d'obrir l'app perquè surti el popup
- message
    - Obligatori
    - Missatge de l'alerta en cas que s'hagi de mostrar.


## Com funciona el mòdul de control de versions
Depenent del valor del paràmetre "comparisonMode" mostrarem l'alerta.

Aquest paràmetre compararà la versió instal·lada amb la qual rebem del json, en funció de tres valors:

  -> FORCE: Mostra l'alerta i no es pot treure. Actualització obligatoria
  -> LAZY: Mostra l'alerta amb l'opció d'actualitzar l'app o seguir utilitzant l'actual. Actualització voluntaria
  -> INFO: Mostra l'alerta amb un missatge informatiu. Deixa seguir utilitzant l'app amb normalitat
  -> NONE: no es mostra el popup

## Com funciona el control de valoracions
- L’app compta cada vegada que s’obre (s'ha de cridar el mètode "rating" de la llibreria)
- L’app espera a que passin un nº de minuts determinats (p.ex. 90) des de l’últim cop que ha mostrat la pop up (per tal de l’usuari no la consideri intrusiva o abusiva).
- Un cop passats aquests dies i quan el comptador superi un valor determinat (p.ex. 20), mostra el popup i el comptador es reinicia independentment de la resposta de l’usuari.*
- La operativa no es veu modificada si hi ha un canvi de versió (és a dir, es mantenen els valors de comptatge de dies i de nº de apertures).
- El text que es mostra al popup és configurable des del servei

*En iOS es crida un package de flutter i la mateixa llibreria s'encarrega de quan mostrar o no el popup
