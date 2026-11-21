-- SchrauberBase Datenbank-Schema (Supabase / PostgreSQL)

-- 1. Haupttabelle für Fehlerfälle (markenunabhängig)
create table faults (
  id uuid primary key default gen_random_uuid(),
  entry_type text not null default 'repair_case' check (entry_type in ('repair_case', 'technical_issue', 'recall')),
  title text not null,
  category text not null,                         -- z.B. Motor, Klima, Elektronik, Fahrwerk
  symptoms text[] not null default '{}',
  dtc_codes text[] not null default '{}',
  root_cause text,
  diagnosis_steps text[] default '{}',
  solution text,
  part_numbers text[] default '{}',
  video_links text[] default '{}',
  image_urls text[] default '{}',
  outcome text default 'probable_fix' check (outcome in ('solved_confirmed', 'probable_fix', 'unsolved', 'unknown')),
  review_status text default 'draft' check (review_status in ('draft', 'plausible', 'rejected')),
  missing_fields text[] default '{}',             -- dokumentiert bewusst fehlende Angaben
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- 2. Fahrzeug-Zuordnung (1 Fehler kann zu mehreren Modellen/Motoren passen)
create table fault_vehicles (
  id uuid primary key default gen_random_uuid(),
  fault_id uuid not null references faults(id) on delete cascade,
  make text not null,                             -- z.B. Audi
  model text not null,                            -- z.B. A6
  generation text,                                -- z.B. C8 (4K)
  year_from int,
  year_to int,
  market text default 'DACH',                     -- DE | AT | CH | DACH | unbekannt
  engine_code text default 'not_reported',
  gearbox_code text default 'not_reported',
  required_equipment text[] default '{}'
);

-- 3. Quellen & Rausch-Filter-Protokoll
create table fault_sources (
  id uuid primary key default gen_random_uuid(),
  fault_id uuid not null references faults(id) on delete cascade,
  source_type text not null,                      -- forum | tsb | recall | eigen
  document_ref text,                              -- z.B. TSB- oder Rückrufnummer
  url text,
  published_date date,
  accessed_date date default current_date,
  ignored_noise_summary text
);

-- 4. Echte Praxis-Bestätigungen (funktioniert / funktioniert nicht)
create table fault_confirmations (
  id uuid primary key default gen_random_uuid(),
  fault_id uuid not null references faults(id) on delete cascade,
  worked boolean not null,
  mileage_km int,
  note text,
  confirmed_at timestamptz default now()
);

-- 5. Indizes für schnelle Filterung & Suche (auch bei 10.000+ Einträgen)
create index idx_fault_vehicles_make_model on fault_vehicles (make, model, year_from, year_to);
create index idx_fault_vehicles_engine on fault_vehicles (engine_code);
create index idx_faults_dtc on faults using gin (dtc_codes);
create index idx_faults_category on faults (category);

-- 6. Automatische Aktualisierung von updated_at
create or replace function update_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

create trigger trg_faults_updated_at
before update on faults
for each row execute function update_updated_at();

-- 7. Row Level Security (Schutz vor unbefugtem Zugriff)
alter table faults enable row level security;
alter table fault_vehicles enable row level security;
alter table fault_sources enable row level security;
alter table fault_confirmations enable row level security;
