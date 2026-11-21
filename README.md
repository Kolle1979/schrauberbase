# SchrauberBase

Strukturierte, marken- und modellunabhängige Kfz-Fehlerdatenbank (Startfokus: Audi im DACH-Raum).

## Ziel
Unstrukturierte Forenthreads und Diagnoseinfos vom Rauschen befreien („habe ich auch“, „fahr in die Werkstatt“) und ausschließlich **Problem, Ursache, Lösung, Teilenummern, Quellenlink und echte Praxis-Bestätigungen** strukturiert speichern.

## Architektur (0 € Betriebskosten)
- **Datenbank & Storage:** Supabase (PostgreSQL, Region Central EU / Frankfurt)
- **Extraktion:** Lokales Firecrawl (Docker, Port 3002) + Hermes Agent
- **Anbindung:** Supabase MCP Server (`features=database`)
- **Code & Doku:** Privates GitHub-Repository (`Kolle1979/schrauberbase`)

## Ordnerstruktur
- `schema.sql` – Komplettes PostgreSQL-Datenbankschema inklusive Indizes, Trigger und Row Level Security (RLS)
- `prompts/rausch-filter.md` – Standard-Prompt für Hermes Agent zur Extraktion aus Forenthreads

## Regeln & Qualitätssicherung
- **Keine Erfindungen:** Fehlende Fahrzeugdaten (z. B. Motorkennbuchstabe) werden als `not_reported` gespeichert und in `missing_fields` protokolliert.
- **Prüfung vs. Praxis:** Theoretische Plausibilitätsprüfung (`review_status`) und echte Reparatur-Bestätigungen am Fahrzeug (`fault_confirmations`) sind streng getrennt.
- **Recht & Datenschutz:** Das Projekt läuft privat. Keine kompletten Forentexte, Nutzerdaten, Kennzeichen oder FIN speichern – nur eigene strukturierte Zusammenfassungen mit Quellenlink und Datum.
