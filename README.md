# modul_comu_osam_flutter

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![License](https://img.shields.io/badge/License-BSD%203--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)

# README

- Nota:
Per executar la versió pluguin de flutter a partir de la 4.0.5, es va fer servir (flutter doctor -v):
  • Flutter version 3.X.X on channel stable

## Com es fa servir?

- Afegeix aquesta dependència al pubspec:

```yaml
common_module_flutter:
  git:
    url: https://github.com/AjuntamentdeBarcelona/modul_comu_osam_flutter.git
    ref: '4.0.13'
```

En cas que les dependències de Firebase Analytics, Firebase Performance i Firebase Crashlytics fallin, cal afegir aquestes 
aquesta configuració al pubspec:
```yaml
dependency_overrides:
firebase_crashlytics_platform_interface: 3.1.13
firebase_analytics_platform_interface: 3.0.5
firebase_performance_platform_interface: ^0.1.1+18
```

A partir de la versió 2.0.0 el mòdul ja s'ha migrat a null safety.

A partir de la versió 3.0.0 la llibreria es un wrapper de
la [desenvolupada en Kotlin Multiplatform](https://github.com/AjuntamentdeBarcelona/modul_comu_osam)

- Actualitzar mitjançant el comandament 'flutter packages get' les dependències.
- Afegir el import on sigui necessari:

```dart
import 'package:common_module_flutter/osam.dart';
```

- Per utilitzar la llibreria necessitem crear una instància de la clase OSAM, la qual es fa a través
  del mètode estàtic (i asíncron) `init()`.

Aqui tenim un example de inicialització.

```dart
class DI {
  static late SharedPreferences _prefs;
  static late OSAM _osamSdk;

  static Future<void> initialize() async {
    await Firebase.initializeApp();
    _prefs = await SharedPreferences.getInstance();
    _osamSdk = await OSAM.init("https://dev-osam-modul-comu.dtibcn.cat",
        _onCrashlyticsException, _onAnalyticsEvent, _onPerformanceEvent);
  }

  static final Settings settings = AppPreferences(_prefs);
  static final OsamRepository osamRepository =
  OsamRepositoryImpl(_osamSdk, settings);

  static _onCrashlyticsException(String className, String stackTrace) async {
    await FirebaseCrashlytics.instance.recordError(
        className, StackTrace.fromString(stackTrace),
        reason: stackTrace);
  }

  static _onAnalyticsEvent(String name, Map<String, String> parameters) async {
    await FirebaseAnalytics.instance
        .logEvent(name: name, parameters: parameters);
  }

  static _onPerformanceEvent(String uniqueId, String event,
          Map<String, String> params) async {
    var debugParamsLogs = [];
    params.forEach((key, value) {
      debugParamsLogs.add("$key: $value");
    });
    debugPrint("PerformanceMetric _onPerformanceEvent uniqueId: $uniqueId, event: $event, params(${debugParamsLogs.length}): ${debugParamsLogs.join(', ')}");
    int currentTime = getCurrentTime();
    HttpMetric? metric = performanceCurrentMetrics[uniqueId]?.item2;
    switch (event) {
      case "start":
        String url = params["url"] ?? "";
        HttpMethod httpMethod = HttpMethod.Get;
        for (HttpMethod element in HttpMethod.values) {
          if (element.name.toLowerCase() ==
                  (params["httpMethod"] ?? "").toLowerCase()) {
            httpMethod = element;
            break;
          }
        }
        metric = FirebasePerformance.instance
                .newHttpMetric(url, httpMethod);
        performanceCurrentMetrics[uniqueId] = Tuple(item1: currentTime, item2: metric);
        debugPrint("PerformanceMetric case event: $event, uniqueId: $uniqueId, url: $url, httpMethod: $httpMethod");
        await metric.start();
        break;
      case "setRequestPayloadSize":
        int? bytes;
        try {
          bytes = int.parse(params["bytes"]!);
        } catch (e) {
          bytes = null;
        }
        if (bytes != null) {
          debugPrint("PerformanceMetric case event: $event, bytes: $bytes");
          metric?.requestPayloadSize = bytes;
        }
        break;
      case "markRequestComplete":
        debugPrint("PerformanceMetric case event: $event");
        break;
      case "markResponseStart":
        debugPrint("PerformanceMetric case event: $event");
        break;
      case "setResponseContentType":
        String? contentType = params["contentType"];
        if (contentType != null) {
          debugPrint("PerformanceMetric case event: $event, contentType: $contentType");
          metric?.responseContentType = contentType;
        }
        break;
      case "setHttpResponseCode":
        int? responseCode;
        try {
          responseCode = int.parse(params["responseCode"]!);
        } catch (e) {
          responseCode = null;
        }
        if (responseCode != null) {
          debugPrint("PerformanceMetric case event: $event, responseCode: $responseCode");
          metric?.httpResponseCode = responseCode;
        }
        break;
      case "setResponsePayloadSize":
        int? bytes;
        try {
          bytes = int.parse(params["bytes"]!);
        } catch (e) {
          bytes = null;
        }
        if (bytes != null) {
          debugPrint("PerformanceMetric case event: $event, bytes: $bytes");
          metric?.responsePayloadSize = bytes;
        }
        break;
      case "putAttribute":
        String? attribute = params["attribute"];
        String value = params["value"] ?? "";
        if (attribute != null) {
          debugPrint("PerformanceMetric case event: $event, attribute: $attribute, value: $value");
          metric?.putAttribute(attribute, value);
        }
        break;
      case "stop":
        debugPrint("PerformanceMetric case event: $event");
        metric?.stop();
        //performanceCurrentMetrics.remove(uniqueId);
        break;
    }
    try{
      var keys = performanceCurrentMetrics.keys;
      for(int i = keys.length - 1; i>=0; i--) {
        var key = keys.toList()[i];
        var value = performanceCurrentMetrics[key];
        if (value == null || value.item1 < currentTime - 600 * 1000) {
          debugPrint("PerformanceMetric deleting old uniqueId: $key");
          performanceCurrentMetrics.remove(key);
        }
      }
    }catch(e){
    }
  }

  static int getCurrentTime() {
    return DateTime.now().millisecondsSinceEpoch;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DI.initialize();
  runApp(MyApp());
}
```

Com es pot veure, el mètode init, a més de necessitar que li passem la URL del backend, necessita 2
callbacks:

- **onCrashlyticsException**: Es crida cada vegada que es produeix una excepció a la llibreria, de
  manera que permet reportarla al servei d'informe de crashes que s'utilitzi. A l'aplicació
  d'exemple s'utilitza Firebase Crashlytics.
- **onAnalyticsEvent**: Es crida quan es produeix un event rellevant a la llibreria (mostrar un del
  pop-ups, prémer un dels botons, produir-se un error...). Proporciona un nom d'event i una sèrie de
  paràmetres que poden passar-se al servei d'analítics que s'està utilitzant. A l'app d'exemple
  s'utilitza Firebase Analytics.
- **_onPerformanceEvent**: Es crida cada vegada que es produeix una crida a la xarxa, a la llibreria, de
  manera que permet reportarla al servei d'informe de performance que s'utilitzi. A l'aplicació
  d'exemple s'utilitza Firebase Performance.

En el cas de l'app d'exemple, accedim a la instància creada a través de 'OsamRepository':

```dart
@override
Future<VersionControlResponse> checkForUpdates() async {
  return osamSdk.versionControl(
    language: _getLanguage(settings.getLanguage()),
  );
}

@override
Future<RatingControlResponse> checkRating() async {
  return osamSdk.rating(language: _getLanguage(settings.getLanguage()));
}

@override
Future<DeviceInformation> deviceInformation() {
  return osamSdk.deviceInformation();
}

@override
Future<AppInformation> appInformation() {
  return osamSdk.appInformation();
}
```

### Configuració de l'entorn

En l'exemple anterior tenim la URL del mòdul comú hardcoded a la pròpia lògica. Però aquesta URL s'ha d'externalitzar com a variable de configuració, d'aquesta manera es pot generar la versió de producció només substituint el fitxer amb els valors correctes.

Per fer-ho només cal crear el fitxer ".env" a l'arrel del projecte de Flutter i carregar aquest fitxer amb el plugin "flutter_dotenv". En aquesta URL hi ha la documentació de com afegir aquest fitxer i com carregar les dades al codi: https://pub.dev/packages/flutter_dotenv

El fitxer ".env" ha de contenir la URL del mòdul comú en la variable "COMMON_MODULE_URL". Quedaria de la següent manera:
```dosini
COMMON_MODULE_URL=https://dev-osam-modul-comu.dtibcn.cat/
```


## Configuració a la part nativa

### Android

#### Versió de Kotlin

S'ha d'utilitzar, com a mínim, la versió **1.6.10** de Kotlin.

#### compileSdkVersion

L'atribut `compileSdkVersion` del fitxer build.gradle de l'aplicació d'Android ha de tenir el valor
**31 o superior**.

#### Multidex

Si la versió mínima de Android a la que es dona suport (`minSdkVersion`) a l'aplicació d'Android es
inferior a 21, serà
necessari [habilitar multidex](https://developer.android.com/studio/build/multidex), ja que, si no,
apareixerà un error al compilar.

#### Estil

Si volem que els pop-ups es vegin amb l'estil correcte, haurem d'utilitzar un estil que extengui d'
AppCompat. A l'aplicació de Android que crea Flutter s'hauria de modificar els
fitxers `styles.xml` (tant el que està a la carpeta `values` como el que está a `values-night`).

**values/styles.xml**:

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <!-- Theme applied to the Android Window while the process is starting when the OS's Dark Mode setting is off -->
    <style name="LaunchTheme" parent="Theme.AppCompat.Light.NoActionBar">
        <!-- Show a splash screen on the activity. Automatically removed when
             Flutter draws its first frame -->
        <item name="android:windowBackground">@drawable/launch_background</item>
    </style>
    <!-- Theme applied to the Android Window as soon as the process has started.
         This theme determines the color of the Android Window while your
         Flutter UI initializes, as well as behind your Flutter UI while its
         running.
         
         This Theme is only used starting with V2 of Flutter's Android embedding. -->
    <style name="NormalTheme" parent="Theme.AppCompat.Light.NoActionBar">
        <item name="android:windowBackground">?android:colorBackground</item>
    </style>
</resources>
```

**values-night/styles.xml**:

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <!-- Theme applied to the Android Window while the process is starting when the OS's Dark Mode setting is on -->
    <style name="LaunchTheme" parent="Theme.AppCompat.NoActionBar">
        <!-- Show a splash screen on the activity. Automatically removed when
             Flutter draws its first frame -->
        <item name="android:windowBackground">@drawable/launch_background</item>
    </style>
    <!-- Theme applied to the Android Window as soon as the process has started.
         This theme determines the color of the Android Window while your
         Flutter UI initializes, as well as behind your Flutter UI while its
         running.
         
         This Theme is only used starting with V2 of Flutter's Android embedding. -->
    <style name="NormalTheme" parent="Theme.AppCompat.NoActionBar">
        <item name="android:windowBackground">?android:colorBackground</item>
    </style>
</resources>
```

### iOS

#### Podfile

En el Podfile del projecte d'iOS creat por Flutter haurem d'incloure el pod del mòdul comú de
Kotlin Multiplatform Mobile. Això es fa incloent la següent linea:

```
pod 'OSAMCommon', :git => 'https://github.com/AjuntamentdeBarcelona/modul_comu_osam.git', :tag => '2.0.16'
```

El Podfile quedaria de la següent manera:

```
# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

# CocoaPods analytics sends network stats synchronously affecting flutter build latency.
ENV['COCOAPODS_DISABLE_STATS'] = 'true'

project 'Runner', {
  'Debug' => :debug,
  'Profile' => :release,
  'Release' => :release,
}

def flutter_root
  generated_xcode_build_settings_path = File.expand_path(File.join('..', 'Flutter', 'Generated.xcconfig'), __FILE__)
  unless File.exist?(generated_xcode_build_settings_path)
    raise "#{generated_xcode_build_settings_path} must exist. If you're running pod install manually, make sure flutter pub get is executed first"
  end

  File.foreach(generated_xcode_build_settings_path) do |line|
    matches = line.match(/FLUTTER_ROOT\=(.*)/)
    return matches[1].strip if matches
  end
  raise "FLUTTER_ROOT not found in #{generated_xcode_build_settings_path}. Try deleting Generated.xcconfig, then run flutter pub get"
end

require File.expand_path(File.join('packages', 'flutter_tools', 'bin', 'podhelper'), flutter_root)

flutter_ios_podfile_setup

target 'Runner' do
  use_frameworks!
  use_modular_headers!

  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))
  pod 'OSAMCommon', :git => 'https://github.com/AjuntamentdeBarcelona/modul_comu_osam.git', :tag => '2.0.16'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
  end
end
```

## Introducció

Aquest mòdul uneix el control de versions i el control de valoracions.

En el control de versions es mostrarà un avís quan el servei avisi que hi ha una nova versió de
l'app. Aquesta alerta la podem mostrar amb un missatge amb botons de confirmació d'accions.

Tindrem tres diferents tipus d'alerta:

1. **Informativa**: Alerta amb un missatge i / o un títol informatiu, amb un botó d ' "ok" per
   confirmar que s'ha llegit.
2. **Restrictiva**: Alerta amb un missatge i / o un títol, amb botó d ' "ok" que un cop fet clic
   redirigirà l'usuari a una url.
3. **Permisiva**: Alerta amb un missatge i / o un títol, amb botons de "ok" i "cancel". Si fem clic
   al botó de cancel·lar l'alerta desapareixerà, i si ho fem al de confirmar s'obrirà una url.

Pel que respecta al control de valoracions, la seva funcionalitat és mostrar periòdicament una popup
que convida a l’usuari a deixar un comentari sobre l'app al market place corresponent (Google Play o
AppStore).

Tant per android com iOS, s'utilitza un package flutter que mostrarà el pop natiu de cada plataforma.

## Descàrrega del mòdul

Des de la OSAM es proporcionen mòduls per realitzar un conjunt de tasques comunes a totes les apps
publicades per l'Ajuntament de Barcelona.

El mòdul comú (Flutter) està disponible com a repositori a:
https://github.com/AjuntamentdeBarcelona/modul_comu_osam_flutter

## Implementació control de versions

Per crear el missatge d'alerta, únicament hem de cridar a la funció que descarregarà el json amb les
variables ja definides i mostrarà l'alerta segons els valors rebuts.

La signatura del mètode és la següent:

```dart
Future<VersionControlResponse> versionControl({
  required Language language,
});
```

Paràmetres d'entrada:

- **language**: Objecte de tipus Language (pertany al mòdul comú). Actualment, hi ha suportats 3
  idiomes:
    - **Language.CA**: Català
    - **Language.ES**: Castellà
    - **Language.EN**: Anglès

Paràmetres de sortida:

- **versionControlResponse**: Objecte de tipus VersionControlResponse. Els valors de retorn són els
  següents:
    - **VersionControlResponse.ACCEPTED**: si l'usuari ha escollit el botó d'acceptar/ok
    - **VersionControlResponse.DISMISSED**: si l'usuari ha tret el popup
    - **VersionControlResponse.CANCELLED**: si l'usuari ha escollit el botó de cancel·lar
    - **VersionControlResponse.ERROR**: si hi ha hagut cap error al procés d'obtenir la informació
      necessaria o al mostrar el popup

Exemple:

```dart
void _onVersionControl() async {
  final result = await DI.osamSdk.versionControl(
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
  }
}
```

No és necessari capturar la resposta si no es necessita realitzar cap acció adicional, ja que el
mòdul comú s'encarregarà de mostrar el popup si es compleixen els requeriments per a que es mostri

##### Mostrar el control de versions cada vegada que l'app torna a primer pla

Si és necessari executar el control de versions cada vegada que l'app torna a primer pla, a l'app
demo hem implementat aquesta funcionalitat en un mixin anomenat OsamVersionChecker:

```dart
class _MyHomePageState extends State<MyHomePage> with OsamVersionChecker {
```

Hem utilitzat el package https://pub.dev/packages/flutter_fgbg:

```dart
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
}
```

## Implementació control de valoració

Per crear el missatge d'alerta, únicament hem de cridar a la funció que descarregarà el json amb les
variables ja definides i mostrarà l'alerta segons els valors rebuts.

La signatura del mètode és la següent:

```dart
Future<VersionControlResponse> versionControl({
  required Language language,
});
```

Paràmetres d'entrada:

- **language**: Objecte de tipus Language (pertany al mòdul comú). Actualment, hi ha suportats 3
  idiomes:
    - **Language.CA**: Català
    - **Language.ES**: Castellà
    - **Language.EN**: Anglès

Paràmetres de sortida:

- **ratingControlResponse**: Objecte de tipus RatingControlResponse. Els valors de retorn són els
  següents:
    - **RatingControlResponse.ACCEPTED**: s'ha sol·licitat que surti el popup natiu de valoració de cada plataforma
    - **RatingControlResponse.DISMISSED**: el popup no compleix les condicions per ser mostrat a l'usuari
    - **RatingControlResponse.ERROR**: si hi ha hagut cap error al procés d'obtenir la informació
      necessaria o al mostrar el popup

Exemple:

```dart
void _onRating() async {
  final result = await DI.osamSdk.rating(
    language: Language.EN,
  );

  switch (result) {
    case RatingControlResponse.ACCEPTED:
      break;
    case RatingControlResponse.DISMISSED:
      break;
    case RatingControlResponse.CANCELLED:
      break;
  }
}
```

No és necessari capturar la resposta si no es necessita realitzar cap acció adicional, ja que el
mòdul comú s'encarregarà de mostrar el popup si es compleixen els requeriments per a que es mostri

## Implementació d'obtenció de informació de dispositiu i applicació

Per obtenir la informació del dispositiu i de l'aplicació

La signatura del mètodes són la següent:

```dart
Future<DeviceInformation> deviceInformation() async

Future<AppInformation> appInformation() async
```

Paràmetres de sortida:

- **deviceInformation**: Objecte de tipus DeviceInformation. Els valors que conté són:
  següents:
    - **platformName**: Nom de la plataforma
    - **platformVersion**: Versió de la plataforma
    - **platformModel**: Model del dispositiu
    - **appName**: Nom de l'aplicació
    - **appVersionName**: Codi nom de la versió
    - **appVersionCode**: Codi numèric de l'aplicació

Exemple:

```dart
void _onDeviceInformation(BuildContext context) async {
  final result = await DI.osamRepository.deviceInformation();
  _showToast(context, "${result.platformName}");
  _showToast(context, "${result.platformVersion}");
  _showToast(context, "${result.platformModel}");
}

void _onAppInformation(BuildContext context) async {
  final result = await DI.osamRepository.appInformation();
  _showToast(context, "${result.appName}");
  _showToast(context, "${result.appVersionName}");
  _showToast(context, "${result.appVersionCode}");
}
```

## Format JSONs

### Control de Versions

```json
{
  "data": {
    "id": 109,
    "appId": 400,
    "packageName": "cat.bcn.commonmodule",
    "versionCode": 2021050000,
    "versionName": "1.0.0",
    "startDate": 1645311600000,
    "endDate": 1645311600000,
    "serverDate": 1645788600000,
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
}
```

#### Paràmetres

- **packageName**
  - Obligatori
  - Especifica el ApplicationID o BundleID de l'app que afecta
- **versionCode**
  - Obligatori
  - Especifica la versió a la que afecta el control de versions
- **startDate**
  - Opcional
  - Data des de quan s'ha de començar a mostrar el pop-up del control de versions, expressada
    amb *timestamp* (milisegons des del 01/01/1970). Si no arriba informada, es considerarà com si
    fos el 0.
- **endDate**
  - Opcional
  - Data fins quan s'ha de mostrar el pop-up del control de versions, expressada amb *timestamp* (
    milisegons des del 01/01/1970). Si no arriba informada, es considerara com si fos
    9223372036854775807 (el valor màxim possible del Long).
- **serverDate**
  - Obligatori
  - Data actual proporcionada per el servidor. Serà la que s'utilitzi per comparar amb `startDate`
    y `endDate`.
- **platform**
  - Obligatori
  - Especifica per a quina plataforma (ANDROID o IOS) afecta
- **comparisonMode**
  - Obligatori
  - Especifica la manera de comparació de la versió de l'app amb el mòdul
- **title**
  - Obligatori
  - Títol de l'alerta en el cas que s'hagi de mostrar.
- **message**
  - Obligatori
  - Missatge de l'alerta en cas que s'hagi de mostrar.
- **ok**
  - Opcional
  - Títol del botó d'acceptar.
  - Si es rep aquest paràmetre juntament amb el paràmetre okButtonActionURL, es mostrarà en
    l'alerta un botó d'acceptar que obrirà el link que s'ha especificat en el paràmetre
    okButtonActionURL.
- **cancel**
  - Opcional
  - Títol del botó de cancel·lar
- **url**
  - Opcional
  - Link que s'obrirà quan l'usuari seleccioni el botó d'acceptar. Per exemple: link de la nova
    versió de l'aplicació a l'App Store / Google Play.

### Control de Valoracions

```json
{
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
}
```

#### Paràmetres

- **appStoreIdentifier**
    - Obligatori
    - Especifica el id de l'app al AppStore per poder valorar-la
- **packageName**
    - Obligatori
    - Especifica el ApplicationID o BundleID de l'app que afecta
- **platform**
    - Obligatori
    - Especifica per a quina plataforma (ANDROID o IOS) afecta
- **minutes**
    - Obligatori
    - Especifica el temps (en minuts) que ha de passar perquè surti el popup
- **numAperture**
    - Obligatori
    - Especifica la quantitat de vegades que s'ha d'obrir l'app perquè surti el popup
- **message**
    - Obsolet
    - A partir de la versió 2.0.0, aquest paràmetre ja no es fa servir

## Com funciona el mòdul de control de versions

Depenent del valor del paràmetre "comparisonMode" mostrarem l'alerta.

Aquest paràmetre compararà la versió instal·lada amb la qual rebem del json, en funció de tres
valors:

- **FORCE**: Mostra l'alerta i no es pot treure. Actualització obligatoria
- **LAZY**: Mostra l'alerta amb l'opció d'actualitzar l'app o seguir utilitzant l'actual.
  Actualització voluntaria
- **INFO**: Mostra l'alerta amb un missatge informatiu. Deixa seguir utilitzant l'app amb normalitat
- **NONE**: no es mostra el popup

## Com funciona el control de valoracions

- L’app compta cada vegada que s’obre (s'ha de cridar el mètode "rating" de la llibreria)
- L’app espera a que passin un nº de minuts determinats (p.ex. 90) des de l’últim cop que ha mostrat
  la pop up (per tal de l’usuari no la consideri intrusiva o abusiva).
- Un cop passats aquests dies i quan el comptador superi un valor determinat (p.ex. 20), mostra el
  popup i el comptador es reinicia independentment de la resposta de l’usuari.*
- La operativa no es veu modificada si hi ha un canvi de versió (és a dir, es mantenen els valors de
  comptatge de dies i de nº de apertures).
- En cas de què s'hagi de mostrar el popup, a Android es crida a la llibreria de Google Play Core i a iOS es crida al SKStoreReviewController.
