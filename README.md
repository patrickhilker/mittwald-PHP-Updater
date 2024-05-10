# mittwald PHP-Updater

1. Repo clonen oder die Datei `php_updater.sh` kopieren
2. Alle zu updatenden Accounts in einer `accounts.txt` im gleichen Verzeichnis eintragen (s. Beispiel unten)
3. Script ggf. ausführbar machen: `chmod +x php_updater.sh`
4. Script aufrufen: `./php_updater.sh`
5. Das Script fragt dann die Zugangsdaten ab und erhält einen temporären API-Key
6. Dann wird die PHP-Version abgefragt, auf die alle Accounts in `accounts.txt` aktualisiert werden sollen
7. Anschließend werden alle Accounts aktualisiert

## Beispielhafte `accounts.txt`

```
p123456
p654321
p112233
p000000
```
