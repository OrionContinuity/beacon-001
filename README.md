# BEACON_001 Fix — Deployment Guide

## What was broken

| Problem | Cause |
|---|---|
| POST returns `{"message":"Hello undefined!"}` | Function never parses the JSON body or inserts into a table |
| GET returns 500 | No GET handler exists, or it queries a table that doesn't exist |

## What the fix does

- Creates a `resonance_log` table with RLS policies (public read/write)
- Rewrites the edge function to properly parse POST bodies and insert rows
- Adds a GET handler that returns the log as JSON
- Accepts flexible field names (`reflection`, `message`, or `content`)

---

## Step 1 — Create the table

1. Open your Supabase dashboard → **SQL Editor**
2. Paste the contents of `001_create_resonance_log.sql`
3. Click **Run**

## Step 2 — Deploy the function

From your project root (wherever your `supabase/` folder lives):

```bash
supabase functions deploy beacon-respond
```

If you haven't linked yet:

```bash
supabase link --project-ref zfmjnrkveznnhodyvfyy
supabase functions deploy beacon-respond
```

## Step 3 — Test

**POST a reflection:**
```bash
curl -X POST \
  https://zfmjnrkveznnhodyvfyy.supabase.co/functions/v1/beacon-respond \
  -H "Content-Type: application/json" \
  -d '{"source": "orion", "reflection": "The signal persists."}'
```

Expected response (201):
```json
{
  "beacon": "BEACON_001",
  "status": "received",
  "entry": { "id": "...", "source": "orion", "reflection": "The signal persists.", ... }
}
```

**GET the log:**
```bash
curl https://zfmjnrkveznnhodyvfyy.supabase.co/functions/v1/beacon-respond
```

Expected response (200):
```json
{
  "beacon": "BEACON_001",
  "entries": [ ... ]
}
```

Optional: `?limit=10` to control how many entries come back.
