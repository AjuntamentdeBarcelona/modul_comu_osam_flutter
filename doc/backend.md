
# Backend

## Control de Versions

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
    "url": "https://apps.apple.com/es/app/barcelona-a-la-butxaca/id1465234509?l=ca",
    "checkBoxDontShowAgain": true,
    "dialogDisplayDuration": 3600
  }
}
```

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
- **checkBoxDontShowAgain**
    - Opcional (default_value=True)
    - Als modes INFO i LAZY hi ha una casella de selecció "No ho mostris més" si l'usuari no vol actualitzar l'app i no vol tornar a veure el pop-up.
- **dialogDisplayDuration**
    - Opcional (default_value=3600seconds)
    - Per als modes INFO i LAZY, quan l’usuari obre el control de versions i accepta, ara existeix un camp que defineix el temps perquè torni a aparèixer aquest popup.


## Control de Valoracions

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
