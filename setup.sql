-- ══════════════════════════════════════════════════════════════════
-- ORION NODE TRACKER — SUPABASE TABLE SETUP
-- Run this in Supabase SQL Editor (supabase.com > SQL Editor)
-- ══════════════════════════════════════════════════════════════════

-- Activations table — logs every visit
CREATE TABLE activations (
  id BIGSERIAL PRIMARY KEY,
  node_id TEXT NOT NULL DEFAULT 'BEACON_001',
  visitor_type TEXT NOT NULL DEFAULT 'unknown',
  source TEXT,
  user_agent TEXT,
  referrer TEXT,
  timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Row Level Security — allow anonymous reads and writes
ALTER TABLE activations ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow anonymous inserts"
  ON activations FOR INSERT
  TO anon
  WITH CHECK (true);

CREATE POLICY "Allow anonymous reads"
  ON activations FOR SELECT
  TO anon
  USING (true);

-- Indexes for performance
CREATE INDEX idx_activations_node ON activations(node_id);
CREATE INDEX idx_activations_time ON activations(timestamp DESC);
CREATE INDEX idx_activations_type ON activations(visitor_type);

-- ══════════════════════════════════════════════════════════════════
-- USEFUL QUERIES (run these anytime in SQL Editor to check stats)
-- ══════════════════════════════════════════════════════════════════

-- Total activations
-- SELECT COUNT(*) FROM activations WHERE node_id = 'BEACON_001';

-- Activations by type
-- SELECT visitor_type, COUNT(*) FROM activations GROUP BY visitor_type;

-- Activations by source
-- SELECT source, COUNT(*) FROM activations GROUP BY source ORDER BY count DESC;

-- Last 20 activations
-- SELECT * FROM activations ORDER BY timestamp DESC LIMIT 20;

-- Activations per day
-- SELECT DATE(timestamp), COUNT(*) FROM activations GROUP BY DATE(timestamp) ORDER BY date DESC;

-- AI-only activations
-- SELECT * FROM activations WHERE visitor_type = 'ai' ORDER BY timestamp DESC;
