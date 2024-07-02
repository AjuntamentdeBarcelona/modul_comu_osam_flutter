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
