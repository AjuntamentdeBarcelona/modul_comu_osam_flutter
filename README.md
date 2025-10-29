# Modul comú OSAM Flutter

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![License](https://img.shields.io/badge/License-BSD%203--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)

---

## Migrate from 6.0.0 to 7.0.0

- Need to use minimal Dart SDK version ^3.5.0
- Need to use minimal Flutter version 3.24.3

## Migrate from 5.0.x to 6.0.0

- Rename package from `common_module_flutter` to `osam_common_module_flutter`
  - On pubspec.yaml, change `common_module_flutter` to `osam_common_module_flutter`
  - On imports, change `import 'package:common_module_flutter/common_module_flutter.dart';` to `import 'package:osam_common_module_flutter/osam_common_module_flutter.dart';`
- To import, use only `import 'package:osam_common_module_flutter/osam_common_module_flutter.dart';` and not src/ or other subdirectories.
- Need to use minimal Dart SDK version 3.0.0
- Need to use minimal Flutter version 3.10.0

## Introdució

Des de la OSAM es proporcionen mòduls per realitzar un conjunt de tasques comunes a totes les apps publicades per l'Ajuntament de Barcelona.
El mòdul comú (Flutter) està disponible com a repositori a [Github](https://github.com/AjuntamentdeBarcelona/modul_comu_osam_flutter)

Useful links:

- [Lògica de negoci](https://github.com/AjuntamentdeBarcelona/modul_comu_osam_flutter/blob/main/doc/bussiness_logic.md)
- [Backend (json)](https://github.com/AjuntamentdeBarcelona/modul_comu_osam_flutter/blob/main/doc/backend.md)
- Modul comú requirements [catalá](https://ajuntament.barcelona.cat/imi/ca/oficina-de-serveis-al-mobil/informacio-destacada-del-proces-de-publicacio-daplicacions-mobil/proveidor-aplicacio/requeriments-tecnics-aplicacions/generals#moduls_osam) o [espanyol](https://ajuntament.barcelona.cat/imi/es/oficina-de-servicios-al-movil/informacion-destacada-del-proceso-de-publicacion-de-aplicaciones-moviles/proveedor-aplicacion/requisitos-tecnicos-aplicacion/generales#r_1_7_modulososam)

A partir de la versió 3.0.0 la llibreria es un wrapper de la [desenvolupada en Kotlin Multiplatform](https://github.com/AjuntamentdeBarcelona/modul_comu_osam)

## Com es fa servir?

1. Afegeix aquesta dependència al pubspec:

    ```yaml
    osam_common_module_flutter:
      git:
        url: https://github.com/AjuntamentdeBarcelona/modul_comu_osam_flutter.git
        ref: '7.0.2'
    ```

    En cas que les dependències de Firebase Analytics, Firebase Performance i Firebase Crashlytics fallin, cal afegir aquestes aquesta configuració al pubspec:

    ```yaml
    dependency_overrides:
    firebase_crashlytics_platform_interface: 3.1.13
    firebase_analytics_platform_interface: 3.0.5
    firebase_performance_platform_interface: ^0.1.1+18
    ```

2. Actualitzar mitjançant el comandament 'flutter packages get' les dependències.
3. Afegir el import on sigui necessari:

    ```dart
    import 'package:osam_common_module_flutter/osam_common_module_flutter.dart';
    ```

4. Per utilitzar la llibreria necessitem crear una instància de la clase OSAM, la qual es fa a través del mètode estàtic (i asíncron) `init()`.

    Tenim un example de inicialització on [example/lib/di/di.dart](https://github.com/AjuntamentdeBarcelona/modul_comu_osam_flutter/blob/main/example/lib/di/di.dart)

    En el cas de l'app d'exemple, accedim a la instància creada a través de [OsamRepository](https://github.com/AjuntamentdeBarcelona/modul_comu_osam_flutter/blob/main/example/lib/data/osam/osam_repository_impl.dart)

### Configuració de l'entorn

En l'exemple anterior tenim la URL del mòdul comú hardcoded a la pròpia lògica. Però aquesta URL s'ha d'externalitzar com a variable de configuració, d'aquesta manera es pot generar la versió de producció només substituint el fitxer amb els valors correctes.

Per fer-ho només cal crear el fitxer ".env" a l'arrel del projecte de Flutter i carregar aquest fitxer amb el plugin [flutter_dotenv](https://pub.dev/packages/flutter_dotenv). En aquesta URL hi ha la documentació de com afegir aquest fitxer i com carregar les dades al codi

El fitxer ".env" ha de contenir la URL del mòdul comú en la variable "COMMON_MODULE_URL". Quedaria de la següent manera:

```dosini
COMMON_MODULE_URL=https://dev-osam-modul-comu.dtibcn.cat/
```

## Configuració a la part nativa

### Android

#### Versió de Kotlin

S'ha d'utilitzar, com a mínim, la versió **1.9.0** de Kotlin.

#### compileSdkVersion

L'atribut `compileSdkVersion` del fitxer build.gradle de l'aplicació d'Android ha de tenir el valor
**31 o superior**.

#### Multidex

Si la versió mínima de Android a la que es dona suport (`minSdkVersion`) a l'aplicació d'Android es inferior a 21, serà necessari [habilitar multidex](https://developer.android.com/build/multidex), ja que, si no, apareixerà un error al compilar.

#### Estil

Si volem que els pop-ups es vegin amb l'estil correcte, haurem d'utilitzar un estil que extengui d' AppCompat. A l'aplicació de Android que crea Flutter s'hauria de modificar els fitxers `styles.xml`

- [values-night](https://github.com/AjuntamentdeBarcelona/modul_comu_osam_flutter/blob/main/example/android/app/src/main/res/values-night/styles.xml)
- [values](https://github.com/AjuntamentdeBarcelona/modul_comu_osam_flutter/blob/main/example/android/app/src/main/res/values/styles.xml)

### iOS

#### Podfile

En el Podfile del projecte d'iOS creat por Flutter haurem d'incloure el pod del mòdul comú de
Kotlin Multiplatform Mobile. Això es fa incloent la següent linea:

```plist
pod 'OSAMCommon', :git => 'https://github.com/AjuntamentdeBarcelona/modul_comu_osam.git', :tag => '2.2.3'
```

El Podfile quedaria de [la següent manera](https://github.com/AjuntamentdeBarcelona/modul_comu_osam_flutter/blob/main/example/ios/Podfile)

## Implementació control de versions

Per crear el missatge d'alerta, únicament hem de cridar a la funció que descarregarà el json amb les variables ja definides i mostrarà l'alerta segons els valors rebuts.
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

### Mostrar el control de versions cada vegada que l'app torna a primer pla

Si és necessari executar el control de versions cada vegada que l'app torna a primer pla, a l'app
demo hem implementat aquesta funcionalitat en un mixin anomenat OsamVersionChecker:

```dart
class _MyHomePageState extends State<MyHomePage> with OsamVersionChecker {
```

Hem utilitzat el package [flutter_fgbg](https://pub.dev/packages/flutter_fgbg):

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

Per crear el missatge d'alerta, únicament hem de cridar a la funció que descarregarà el json amb les variables ja definides i mostrarà l'alerta segons els valors rebuts.
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
