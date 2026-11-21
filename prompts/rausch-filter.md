# Hermes Agent – Rausch-Filter-Prompt

Nutze diesen Prompt in Hermes Agent, um einen Forenthread über Firecrawl auszulesen und direkt strukturiert in Supabase (`schrauberbase`) zu speichern:

```text
Lies die folgende Foren-URL über Firecrawl aus und filtere das Rauschen heraus:
<URL_HIER_EINFÜGEN>

Regeln:
1. Ignoriere alle Füllantworten ("habe ich auch", "fahr in die Werkstatt", Preisdiskussionen, reine Vermutungen ohne Ergebnis).
2. Extrahiere NUR belegte Fakten: Fahrzeug (Marke, Modell, Baureihe, Baujahr, Motor/Getriebe falls genannt), Symptome, OBD-Fehlercodes, tatsächliche Ursache, konkrete Lösung, Teilenummern und Quelle.
3. Erfinde NIEMALS Daten. Fehlt eine Angabe (z. B. Motorkennbuchstabe), trage 'not_reported' ein und liste das Feld unter missing_fields.
4. Speichere das Ergebnis über Supabase MCP in den Tabellen faults, fault_vehicles und fault_sources mit review_status = 'draft'.
5. Gib mir danach eine kurze Zusammenfassung, was gespeichert wurde und wie viele Beiträge als Rauschen ignoriert wurden.
```
