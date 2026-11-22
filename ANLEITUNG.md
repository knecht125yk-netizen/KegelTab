# KegelTab aufs Handy – kostenlos

KegelTab (die Kegel-App der Umwerfenden) wird als **installierbare Web-App** veröffentlicht. Sie kommt aufs **iPhone, iPad und Android**, ohne App Store und **ohne Kosten**:

- Sie bekommt ein eigenes Symbol auf dem Home-Bildschirm und öffnet sich im Vollbild wie eine normale App.
- Sie läuft **auch ohne Internet**, auf der Kegelbahn inklusive Excel- und PDF-Export.
- **Updates kommen automatisch:** Die App meldet „Neue Version – Jetzt aktualisieren“.
- Gehostet wird kostenlos bei **GitHub Pages**. Du brauchst nur ein kostenloses GitHub-Konto. Installieren musst du nichts.

> Warum kein TestFlight? Apple verlangt dafür immer ein Entwicklerkonto für 99 €/Jahr. Die Web-App ist der einzige dauerhaft kostenlose Weg aufs iPhone. Der TestFlight-Weg liegt weiter unten als Option.

---

## Schritt 1 · Veröffentlichen (einmalig, ca. 15 Minuten, am PC)

1. **GitHub-Konto anlegen:** https://github.com → *Sign up* (kostenlos).
2. **Repository anlegen:** oben rechts **+ → New repository**
   - Name: `KegelTab`
   - **Public** auswählen. GitHub Pages ist im kostenlosen Konto nur für öffentliche Repositories verfügbar.
     Öffentlich ist dabei **nur das Programm** (inkl. Vorlage mit Vornamen und Strafen). **Eure Abende, Strafen und Beträge kommen nie ins Internet**, sie liegen nur auf euren Geräten.
   - **Create repository**
3. **Dateien hochladen:** auf der leeren Seite **„uploading an existing file“** anklicken und den **gesamten Inhalt dieses Ordners** hineinziehen. Wichtig ist auch der Ordner **`.github`**.
   (Im Windows-Explorer werden Ordner mit Punkt manchmal ausgeblendet: *Ansicht → Einblenden → Ausgeblendete Elemente*.)
   Den Ordner `site` brauchst du nicht hochzuladen. → **Commit changes**
4. **Pages einschalten:** im Repository **Settings → Pages** → bei *Source* **„GitHub Actions“** auswählen.
5. **Veröffentlichen:** **Actions** → links **„Web-App veröffentlichen (iPhone + Android, kostenlos)“** → **Run workflow**.
   Nach 1–2 Minuten ist der Lauf grün. In der Zusammenfassung steht die Adresse, etwa
   **`https://DEIN-NAME.github.io/KegelTab/`**

## Schritt 2 · Auf dem Handy installieren

**iPhone / iPad:** Adresse in **Safari** öffnen (nicht Chrome) → unten auf **Teilen** (Quadrat mit Pfeil) → **„Zum Home-Bildschirm“** → *Hinzufügen*.
Die App zeigt dir diesen Hinweis auch selbst an.

**Android:** Adresse in **Chrome** öffnen → **„Installieren“** in der App antippen, oder im Menü **⋮ → „App installieren“** bzw. **„Zum Startbildschirm hinzufügen“**.

Danach immer über das **Kegel-Symbol auf dem Home-Bildschirm** öffnen.

## Schritt 3 · Daten von der claude.ai-Version übernehmen (optional)

1. In der bisherigen Version (claude.ai-Link) **Verwaltung → Sicherung speichern**. Du bekommst eine `.json`-Datei.
2. Die Datei aufs Handy schicken (Mail, WhatsApp, AirDrop, iCloud Drive …).
3. In der installierten App: **Verwaltung → Sicherung laden** → Datei auswählen → **Laden**.

## Updates einspielen

1. Neue `kegeltab.html` bei GitHub hochladen: im Repository **Add file → Upload files** → Datei hineinziehen → **Commit changes**.
2. Die Veröffentlichung startet von selbst und dauert 1–2 Minuten.
3. Beim nächsten Öffnen erscheint in der App **„Eine neue Version ist da – Jetzt aktualisieren“**. Antippen, fertig. **Die Daten bleiben erhalten.**

## Wichtig zu den Daten

- Die Daten liegen **auf dem jeweiligen Gerät**. iPhone und Android-Handy haben also jeweils ihre eigene Liste. Am besten führt **eine Person mit einem Gerät** die Liste.
- **Wenn du das App-Symbol löschst, werden auch die Daten gelöscht.** Deshalb regelmäßig, am besten nach jedem Abend, **Verwaltung → Sicherung speichern**.
- Auf dem iPhone gehört die installierte App nicht zum Safari-Browser. Die Daten im Safari-Tab und in der App sind getrennt. Benutze immer das App-Symbol.

---

## Optional: Android als APK-Datei (ebenfalls kostenlos)

Nur nötig, wenn du statt der Web-App eine „richtige“ Android-App-Datei möchtest.

1. **Actions → „Optional · Android-Schlüssel erzeugen (einmalig)“ → Run workflow.** Danach den Lauf öffnen, unter *Artifacts* die Datei herunterladen und entpacken.
2. **Settings → Secrets and variables → Actions → New repository secret:**
   `ANDROID_KEYSTORE_BASE64` und `ANDROID_KEYSTORE_PASSWORD` mit dem Inhalt der beiden Textdateien. Die Dateien zusätzlich sicher aufheben.
3. **Actions → „Optional · Android-APK bauen“ → Run workflow.** Die APK liegt danach rechts unter **Releases**. Auf dem Gerät herunterladen, öffnen und die Installation erlauben.

## Optional: iPhone/iPad über TestFlight (kostet 99 €/Jahr)

Nur falls ihr später doch eine echte iOS-App wollt. Nötig sind ein Apple-Entwicklerkonto (https://developer.apple.com/programs/), eine App in App Store Connect mit der Bundle-ID `de.umwerfenden.kegeltab` und ein API-Schlüssel (Rolle *Admin*).
Dann bei GitHub die Secrets `APPLE_TEAM_ID`, `ASC_KEY_ID`, `ASC_ISSUER_ID`, `ASC_KEY_P8` anlegen und **Actions → „Optional · iPad/iPhone zu TestFlight“** starten.
