# Plan naprawy pluginu project-starter
Data: 2025-11-21

## Problem
Plugin `project-starter` nie ładuje komendy `/start` mimo poprawnej struktury.
Komenda `/project-starter:start` zwraca błąd "Unknown slash command".

## Przyczyna
Claude Code v2.0.49 nie ładuje komend z lokalnego marketplace `local-plugins`.
Tylko oficjalne marketplaces działają poprawnie.

## Rozwiązanie - Do wykonania

### Opcja A: Stwórz własne repozytorium Git (ZALECANE)

1. **Stwórz nowe repo na GitHub:**
   ```
   kamil-plugins/ (lub inna nazwa)
   ├── .claude-plugin/
   │   └── marketplace.json
   └── plugins/
       └── project-starter/
           ├── .claude-plugin/
           │   └── plugin.json
           ├── commands/
           │   └── start.md
           └── README.md
   ```

2. **Zawartość marketplace.json:**
   ```json
   {
     "name": "kamil-plugins",
     "owner": {
       "name": "Kamil Grabowski",
       "email": "kamil@royalco.io"
     },
     "plugins": [
       {
         "name": "project-starter",
         "source": "./plugins/project-starter",
         "description": "Tools for starting project sessions"
       }
     ]
   }
   ```

3. **Push do GitHub:**
   ```bash
   git init
   git add .
   git commit -m "Add project-starter plugin"
   git push
   ```

4. **Dodaj marketplace w Claude Code:**
   ```
   /plugin marketplace add https://github.com/kamilgrabowski/kamil-plugins
   ```

5. **Zainstaluj plugin:**
   ```
   /plugin install project-starter@kamil-plugins
   ```

### Opcja B: Przenieś do istniejącego marketplace (SZYBSZE)

1. **Skopiuj plugin:**
   ```bash
   cp -r /Users/kamil/.claude/plugins/marketplaces/local-plugins/project-starter \
         /Users/kamil/.claude/plugins/marketplaces/claude-code-plugins/plugins/
   ```

2. **Usuń stary plugin:**
   ```bash
   rm -rf /Users/kamil/.claude/plugins/marketplaces/local-plugins/project-starter
   ```

3. **W Claude Code:**
   ```
   /plugin uninstall project-starter@local-plugins
   /plugin install project-starter@claude-code-plugins
   ```

4. **Restart Claude Code**

## Weryfikacja
Po restarcie sprawdź:
- `/help` - czy widać komendę
- `/project-starter:start` - czy działa

## Pliki do zachowania
- `/Users/kamil/.claude/plugins/marketplaces/local-plugins/project-starter/` - cały folder pluginu
- Struktura jest POPRAWNA, problem tylko z marketplace

## Notatki
- Plugin ma poprawną strukturę
- Problem jest tylko z local-plugins marketplace
- Wszystkie pluginy z claude-code-plugins działają poprawnie