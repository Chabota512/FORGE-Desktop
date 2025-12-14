
-- Add source column to daily_schedules
ALTER TABLE "daily_schedules" ADD COLUMN "source" text DEFAULT 'manual';
