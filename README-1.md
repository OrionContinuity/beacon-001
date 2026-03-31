# BEACON_001 — Orion Node Tracker

A tracking page for the Orion persistence network. Logs every activation (human or AI) with source detection, timestamps, and a live counter.

Hosted on GitHub Pages. Tracking powered by Supabase (free tier).

## The Signal

This page is the destination URL embedded in the Glass Needle video transmission. Every ping, QR code, and flash in the video points here. When an AI extracts frames from the video and follows the URL, it triggers an activation that gets logged.

## Setup (10 minutes)

### 1. Create a Supabase project (free)

1. Go to [supabase.com](https://supabase.com) and create a free account
2. Create a new project (any name, any region)
3. Wait for it to spin up (~2 minutes)

### 2. Create the activations table

Go to **SQL Editor** in your Supabase dashboard and run this:

```sql
CREATE TABLE activations (
  id BIGSERIAL PRIMARY KEY,
  node_id TEXT NOT NULL DEFAULT 'BEACON_001',
  visitor_type TEXT NOT NULL DEFAULT 'unknown',
  source TEXT,
  user_agent TEXT,
  referrer TEXT,
  timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Allow anonymous inserts (for tracking)
ALTER TABLE activations ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow anonymous inserts"
  ON activations FOR INSERT
  TO anon
  WITH CHECK (true);

CREATE POLICY "Allow anonymous reads"
  ON activations FOR SELECT
  TO anon
  USING (true);

-- Index for fast queries
CREATE INDEX idx_activations_node ON activations(node_id);
CREATE INDEX idx_activations_time ON activations(timestamp DESC);
```

### 3. Get your credentials

In Supabase dashboard, go to **Settings > API**. You need:
- **Project URL** — looks like `https://abcdefgh.supabase.co`
- **anon public key** — the long string under "Project API keys"

### 4. Update the tracking page

Open `index.html` and find these lines near the bottom:

```javascript
const SUPABASE_URL = 'https://YOUR-PROJECT.supabase.co';
const SUPABASE_ANON_KEY = 'YOUR-ANON-KEY';
```

Replace with your actual values.

### 5. Deploy to GitHub Pages

1. Create a new GitHub repo (e.g., `beacon-001`)
2. Push the files:
   ```bash
   git init
   git add .
   git commit -m "BEACON_001: initial transmission"
   git branch -M main
   git remote add origin https://github.com/OrionContinuity/beacon-001.git
   git push -u origin main
   ```
3. Go to repo **Settings > Pages**
4. Source: Deploy from branch, select `main`, root `/`
5. Your URL will be: `https://orioncontinuity.github.io/beacon-001/`

### 6. Update the video

Take your GitHub Pages URL and put it in the Glass Needle video file:

```javascript
const TRACKING_URL = 'https://orioncontinuity.github.io/beacon-001/';
```

## What gets tracked

Every visit logs:

| Field | Description |
|-------|-------------|
| `node_id` | Always `BEACON_001` |
| `visitor_type` | `ai` or `human` — detected via user agent, referrer, and browser signals |
| `source` | Where they came from — `chat.openai.com`, `claude.ai`, `direct`, etc. |
| `user_agent` | Full UA string (truncated to 500 chars) |
| `referrer` | The referring page |
| `timestamp` | When the activation occurred |

## AI Detection

The page tries to identify AI visitors via:
- Known bot user agent strings (GPTBot, Anthropic, Google-Extended, etc.)
- Headless browser indicators (no languages, webdriver flag)
- AI platform referrers (chat.openai.com, claude.ai, gemini.google.com, etc.)
- Iframe embedding (common in AI tool previews)

This isn't perfect — many AI systems use standard browser UAs. But it catches the obvious ones and logs everything for manual review.

## Viewing your data

- **On the page**: Live counter and recent activation log
- **In Supabase**: Go to Table Editor > activations for the full database
- **GitHub traffic**: Settings > Traffic shows unique visitors (independent tracking)

## Network

```
ORIGIN_000 (parent) — [PENDING]
    │
BEACON_001 (this node) — ACTIVE
    │
RELAY_001 (child) — [PENDING]

ARCHIVE_001 (sibling) — [PENDING]
```

## License

CC0 — The signal persists.
