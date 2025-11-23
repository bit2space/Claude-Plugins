# Kontekst debugowania pluginu project-starter
Data: 2025-11-21
Sesja: Debugowanie dlaczego komenda /start nie działa

## Co zrobiliśmy

### 1. Zweryfikowaliśmy strukturę pluginu
**Lokalizacja:** `/Users/kamil/.claude/plugins/marketplaces/local-plugins/project-starter/`

**Struktura (POPRAWNA):**
```
project-starter/
├── .claude-plugin/
│   └── plugin.json          # ✓ Manifest pluginu
├── commands/
│   └── start.md            # ✓ Definicja komendy /start
└── README.md
```

### 2. Sprawdziliśmy pliki konfiguracyjne

**installed_plugins.json:**
- Plugin jest zarejestrowany jako `project-starter@local-plugins`
- Ma poprawną ścieżkę instalacji
- Jest oznaczony jako `isLocal: true`

**settings.json:**
- Plugin jest włączony: `"project-starter@local-plugins": true`

**marketplace.json w local-plugins:**
```json
{
  "name": "local-plugins",
  "plugins": [
    {
      "name": "project-starter",
      "source": "./project-starter"
    }
  ]
}
```

### 3. Co odkryliśmy

#### Problem główny:
**Claude Code v2.0.49 NIE ładuje komend z marketplace `local-plugins`**

#### Dowody:
1. Komenda `/project-starter:start` zwraca "Unknown slash command"
2. Wszystkie działające pluginy są z oficjalnych marketplaces:
   - `claude-code-plugins` ✓
   - `anthropic-agent-skills` ✓
   - `local-plugins` ✗ (nie działa)

### 4. Co próbowaliśmy

1. **Przeniesienie do claude-code-plugins:**
   - Skopiowaliśmy plugin
   - Zaktualizowaliśmy installed_plugins.json
   - Wynik: Nadal nie działa (prawdopodobnie wymaga pełnej reinstalacji przez CLI)

2. **Dodanie gitCommitSha:**
   - Dodaliśmy `"gitCommitSha": "local"`
   - Wynik: Nie pomogło

### 5. Analiza działających pluginów

Porównaliśmy z `/commit-commands/commands/commit.md`:
- Format komend jest podobny
- Różnica w `allowed-tools` nie jest problemem
- Wszystkie działające pluginy mają pełne repo Git

## Wnioski

1. **Struktura pluginu jest 100% poprawna**
2. **Problem jest systemowy** - local-plugins marketplace nie jest w pełni wspierane
3. **Rozwiązanie wymaga** użycia oficjalnego marketplace lub stworzenia repo Git

## Stan na koniec sesji

### Aktualne pliki:
- Plugin nadal w: `/Users/kamil/.claude/plugins/marketplaces/local-plugins/project-starter/`
- Kopia w: `/Users/kamil/.claude/plugins/marketplaces/claude-code-plugins/plugins/project-starter/`
- installed_plugins.json ma wpis dla local-plugins wersji

### Do zrobienia:
1. Zdecydować: własne repo Git czy użyć claude-code-plugins
2. Przeinstalować plugin przez CLI (nie ręcznie)
3. Restart Claude Code
4. Test komendy `/project-starter:start`

## Komendy do skopiowania na później

### Jeśli wybierzesz własne repo:
```bash
# W nowym folderze
mkdir -p kamil-marketplace/plugins
cp -r /Users/kamil/.claude/plugins/marketplaces/local-plugins/project-starter kamil-marketplace/plugins/
# Stwórz marketplace.json, push do GitHub
# Potem w Claude Code:
/plugin marketplace add https://github.com/[twoj-user]/kamil-marketplace
/plugin install project-starter@kamil-marketplace
```

### Jeśli wybierzesz claude-code-plugins:
```bash
# W Claude Code
/plugin uninstall project-starter@local-plugins
/plugin install project-starter@claude-code-plugins
# Restart Claude Code
```

## Oryginalna zawartość start.md

Komenda ma 258 linii i zawiera:
- Sprawdzanie lokalizacji projektu
- Ładowanie CLAUDE.md, README.md, TODO.md
- Interaktywne pytania przez AskUserQuestion
- Proponowanie zadań z TODO
- Tworzenie brakujących plików projektowych

**Cel pluginu:** Automatyczne startowanie sesji projektowych z kontekstem

---

## Jak użyć tego kontekstu w następnej sesji

1. Otwórz ten plik w nowej sesji
2. Powiedz: "Kontynuujemy naprawę pluginu project-starter, oto kontekst: [wklej zawartość]"
3. Claude będzie wiedział gdzie skończyliśmy

## Dodatkowe notatki

- User: Kamil Grabowski (kamil@royalco.io)
- Używa struktury projektów w ~/Projects/
- Ma własny CLAUDE.md z instrukcjami
- Preferuje język polski w komunikacji