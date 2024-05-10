#!/bin/bash

# Frage nach Kundennummer (Benutzername), Passwort und 2FA
read -p "Bitte geben deine Kundennummer ein: " username
read -s -p "Bitte gib dein Passwort ein (Eingabe ist unsichtbar): " password
echo ""
read -p "2FA-Code (falls aktiviert, sonst einfach Enter drücken): " mfa
echo ""

# Authentifizierung bei der API und Extraktion des API-Schlüssels
api_response=$(curl -s -X POST "https://login.mittwald.de/rest/v2/authentication" \
    -H "Content-Type: application/json" \
    -d "{\"user\": \"$username\", \"password\": \"$password\", \"multiFactorCode\": \"$mfa\"}")
api_key=$(echo "$api_response" | jq -r '.accessToken')

# Überprüfung der Authentifizierung
if [ -z "$api_key" ] || [ "$api_key" == "null" ]; then
    echo "Authentifizierung fehlgeschlagen. Bitte überprüf deine Zugangsdaten."
    exit 1
else
    echo "Authentifizierung erfolgreich. API-Schlüssel erhalten."
fi

echo ""

# Frage die gewünschte PHP-Version ab
read -p "Bitte gib die gewünschte PHP-Version ein (7.0, 7.1, 7.2, 7.3, 8.0, 8.1, 8.2, 8.3): " php_version
echo ""

# Überprüfe die Eingabe der PHP-Version
if [[ ! $php_version =~ ^(7\.0|7\.1|7\.2|7\.3|8\.0|8\.1|8\.2|8\.3)$ ]]; then
    echo "Ungültige PHP-Version eingegeben."
    exit 1
fi

# Lese die Account-IDs aus einer Datei namens 'accounts.txt' und aktualisiere die PHP-Version
while read -r account_id; do
    if [[ $account_id =~ ^p[0-9]+$ ]]; then
        response=$(curl -s -L -o /dev/null -w "%{http_code}" -X POST "https://api.mittwald.de/v1/accounts/$account_id/installations/action/update-php" \
        -H "Authorization: Bearer $api_key" \
        -H "Content-Type: application/json" \
        -d "{\"version\": \"$php_version\"}")

        # Prüfe den Statuscode der Antwort
        if [ "$response" -eq 200 ]; then
            echo "Erfolg: PHP-Version für Account $account_id erfolgreich auf $php_version aktualisiert."
        else
            echo "Fehler: Aktualisierung der PHP-Version für Account $account_id fehlgeschlagen. Statuscode: $response"
        fi
    else
        echo "Ungültige Account-ID: $account_id"
    fi
done < "accounts.txt"
