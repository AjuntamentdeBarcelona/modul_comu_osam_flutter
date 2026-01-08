# Lògica de negoci

## Control de versions

Depenent del valor del paràmetre [comparisonMode](backend.md#control-de-versions) on json mostrarem l'alerta.

Aquest paràmetre compararà la versió instal·lada amb la qual rebem del json, en funció de tres
valors:

- **FORCE**: Mostra l'alerta i no es pot treure. Actualització obligatoria
- **LAZY**: Mostra l'alerta amb l'opció d'actualitzar l'app o seguir utilitzant l'actual.
  Actualització voluntaria
- **INFO**: Mostra l'alerta amb un missatge informatiu. Deixa seguir utilitzant l'app amb normalitat
- **NONE**: no es mostra el popup

Mostrarà un avís quan el servei avisi que hi ha una nova versió de l'app. Aquesta alerta la podem mostrar amb un missatge amb botons de confirmació d'accions.

Tindrem tres diferents tipus d'alerta:

1. **Informativa**: Alerta amb un missatge i / o un títol informatiu, amb un botó d ' "ok" per confirmar que s'ha llegit.
2. **Restrictiva**: Alerta amb un missatge i / o un títol, amb botó d ' "ok" que un cop fet clic redirigirà l'usuari a una url.
3. **Permisiva**: Alerta amb un missatge i / o un títol, amb botons de "ok" i "cancel". Si fem clic al botó de cancel·lar l'alerta desapareixerà, i si ho fem al de confirmar s'obrirà una url.

Tant per android com iOS, s'utilitza un package flutter que mostrarà el pop natiu de cada plataforma.

## Control de valoracions

Mostra periòdicament una popup que convida a l’usuari a deixar un comentari sobre l'app al market place corresponent (Google Play o AppStore).

- L’app compta cada vegada que s’obre (s'ha de cridar el mètode "rating" de la llibreria)
- L’app espera a que passin un nº de minuts determinats (p.ex. 90) des de l’últim cop que ha mostrat la pop up (per tal de l’usuari no la consideri intrusiva o abusiva).
- Un cop passats aquests dies i quan el comptador superi un valor determinat (p.ex. 20), mostra el popup i el comptador es reinicia independentment de la resposta de l’usuari.*
- La operativa no es veu modificada si hi ha un canvi de versió (és a dir, es mantenen els valors de comptatge de dies i de nº de apertures).
- En cas de què s'hagi de mostrar el popup, a Android es crida a la llibreria de Google Play Core i a iOS es crida al SKStoreReviewController.

Tant per android com iOS, s'utilitza un package flutter que mostrarà el pop natiu de cada plataforma.

## Com funciona el event d'anàlisi de l'esdeveniment del canvi d'idioma a l'aplicació

Gestiona tota la lògica associada al canvi d'idioma de l'aplicació. Aquesta funció és el punt d'entrada principal per processar un canvi d'idioma. Orquestra diverses accions clau per assegurar que l'estat de l'aplicació s'actualitzi correctament:

1. Actualitza les preferències locals: Desa a l'emmagatzematge local del dispositiu tant l'idioma nou seleccionat com l'idioma anterior.
2. Envia un esdeveniment d'analítica: Registra un esdeveniment language_change a Firebase Analytics, capturant l'idioma previ, el nou idioma i l'idioma de visualització del dispositiu.
3. Actualitza la subscripció al topic de notificacions: Actualitza de manera asíncrona la subscripció de l'app als topics de Firebase Cloud Messaging. Això garanteix que l'usuari rebi les notificacions push dirigides al seu nou idioma seleccionat.

## Com funciona el event del'esdeveniment d'inici o actualització de l'app

Gestiona la subscripció inicial o l'actualització del topic de notificacions de l'aplicació. Aquesta funció s'ha de cridar un cop l'aplicació s'inicia per assegurar que el dispositiu estigui subscrit al topic correcte de Firebase Cloud Messaging.

Orquestra les següents accions:

1. Recupera la informació del darrer topic al qual l'app estava subscrita (si existeix).
2. Construeix el nom del nou topic basant-se en la versió actual de l'app i l'idioma del dispositiu.
3. Actualitza la subscripció a Firebase, donant de baixa l'antic topic i subscrivint-se al nou.
4. Desa localment la informació de la nova versió per a la propera execució de l'app.

## Com funciona el event de la subscripció a un topic personalitzat

Aquesta funció permet subscriure l'aplicació a un topic de
notificacions de Firebase amb un nom específic i personalitzat.

És útil per a campanyes de màrqueting o per segmentar usuaris en
grups que no depenen de la versió de l'app o de l'idioma.
La funció s'encarrega de gestionar la comunicació amb Firebase
per realitzar la subscripció de manera asíncrona.

## Com funciona el event de la desubscripció a un topic personalitzat

Aquesta funció permet desubscriure l'aplicació d'un topic de
notificacions de Firebase amb un nom específic i personalitzat.

És l'operació inversa a subscribeToCustomTopic i és útil per
aturar la recepció de notificacions d'una campanya concreta o per
netejar subscripcions quan ja no són necessàries.
La funció s'encarrega de gestionar la comunicació amb Firebase per realitzar la desubscripció de manera asíncrona.

## Com funciona el event per obtenir el token de Firebase

Aquesta funció permet obtenir el token de registre de Firebase Cloud Messaging (FCM) del dispositiu.
Aquest token és un identificador únic que s'utilitza per enviar notificacions push directament a un
dispositiu específic. L'operació es realitza de manera asíncrona.
