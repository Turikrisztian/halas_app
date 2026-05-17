# 🎣 Kapásjelző - Halas App

Egy modern, letisztult és könnyen kezelhető cross-platform mobilalkalmazás horgászok számára. Az alkalmazás segítségével a horgászok részletesen vezethetik a fogásaikat, statisztikákat elemezhetnek, és elmenthetik a kedvenc horgászhelyeiket.

---

## 🚀 Technológiai Háttér
* **Keretrendszer:** [Flutter](https://flutter.dev/) (Cross-platform: Android & iOS)
* **Programozási nyelv:** Dart (UI és üzleti logika)
* **Natív modulok:** Kotlin (Android háttérország)
* **Verziókövetés:** Git & GitHub

---

## 🛠️ Tervezett Funkciók és Felépítés

Az alkalmazás egy kényelmes alsó menüsorral (`BottomNavigationBar`) rendelkezik, amely 3 fő modulra osztja a funkcionalitást:

### 1. 📊 Főoldal (Dashboard)
A horgászat megkezdése előtt és közben nyújt azonnali, hasznos információkat.
* **Gyors Statisztika:** Az aktuális évben/hónapban kifogott halak száma és összsúlya.
* **Legutóbbi Fogás:** Kártya alapú kiemelés a legutóbb naplózott sikeres kapásról.
* **Időjárás & Kapásindex (Jövőbeli funkció):** Aktuális légnyomás, szélirány és holdfázisok alapján számolt előrejelzés.

### 2. 📝 Fogási Napló (Catches Log)
A digitális horgászigazolvány szíve, ahol minden fogás részletesen rögzíthető.
* **Dinamikus Lista:** Időrendi sorrendben mutatja a korábbi fogásokat (hal képe, fajtája, súlya, dátum).
* **"Új fogás rögzítése" gomb:** Egy űrlap, amely a következő adatokat menti el:
    * Hal fajtája (Ponty, Amur, Csuka, Harcsa, Süllő, Kárász, egyéb...)
    * Súly (kg) és Hossz (cm)
    * Használt csali és etetőanyag
    * Időpont (automatikus vagy manuális)
    * Fénykép (galériából vagy közvetlenül a kamerából)
    * Érintett horgászhely kiválasztása

### 3. 🗺️ Horgászhelyek (Fishing Spots)
A kedvenc vizek és pontos helyek privát nyilvántartása.
* **Vizek listája:** Tavak, folyók, privát tőzegbányák rendszerezése.
* **Pontos koordináták (GPS):** Lehetőség a pontos "állás" vagy etetett hely elmentésére.
* **Személyes jegyzetek:** Milyen mély a víz, milyen akadó van a környéken, milyen csali működött ott legutóbb.

---

## 📈 Jövőbeli Fejlesztési Útiterv (Roadmap)
- [ ] Helyi adatbázis integrálása (SQLite / Hive) az offline működéshez (hogy térerő nélkül is működjön a vízparton).
- [ ] Fényképkezelés és helyi képtárolás optimalizálása.
- [ ] Térkép (Google Maps) integráció a horgászhelyek vizuális megjelenítéséhez.
- [ ] Automatikus statisztikai grafikonok generálása (melyik hónapban vagy melyik csalival volt a legtöbb fogás).

---

## 💻 Fejlesztői Környezet Beállítása

### Előfeltételek
* Flutter SDK (v3.41.9-stable vagy újabb)
* Android Studio / VS Code
* Git

### Futtatás lépései
1. Repozitórium klónozása: `git clone https://github.com/Turikrisztian/halas_app.git`
2. Csomagok letöltése: `flutter pub get`
3. Alkalmazás indítása: `flutter run`