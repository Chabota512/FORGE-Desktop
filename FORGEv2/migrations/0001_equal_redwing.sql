CREATE TABLE "books" (
	"id" serial PRIMARY KEY NOT NULL,
	"title" text NOT NULL,
	"author" text,
	"status" text DEFAULT 'to_read',
	"notes" text,
	"time_category" text DEFAULT 'free_time',
	"current_page" integer,
	"total_pages" integer,
	"total_chapters" integer,
	"current_chapter" integer DEFAULT 0,
	"created_at" text DEFAULT CURRENT_TIMESTAMP,
	"completed_at" text
);
--> statement-breakpoint
CREATE TABLE "chapter_completions" (
	"id" serial PRIMARY KEY NOT NULL,
	"book_id" integer NOT NULL,
	"chapter_number" integer NOT NULL,
	"completed_at" date NOT NULL
);
--> statement-breakpoint
CREATE TABLE "concept_tracking" (
	"id" serial PRIMARY KEY NOT NULL,
	"course_id" integer,
	"concept_name" text NOT NULL,
	"first_covered_at" text DEFAULT CURRENT_TIMESTAMP,
	"last_covered_at" text DEFAULT CURRENT_TIMESTAMP,
	"coverage_count" integer DEFAULT 1,
	"mastery_level" integer DEFAULT 1
);
--> statement-breakpoint
CREATE TABLE "mission_feedback" (
	"id" serial PRIMARY KEY NOT NULL,
	"mission_id" integer NOT NULL,
	"difficulty" integer,
	"time_accuracy" integer,
	"notes" text,
	"created_at" text DEFAULT CURRENT_TIMESTAMP
);
--> statement-breakpoint
CREATE TABLE "schedule_drift_events" (
	"id" serial PRIMARY KEY NOT NULL,
	"schedule_date" date NOT NULL,
	"block_start_time" text NOT NULL,
	"block_title" text NOT NULL,
	"planned_duration" integer NOT NULL,
	"actual_duration" integer NOT NULL,
	"drift_minutes" integer NOT NULL,
	"cumulative_drift" integer NOT NULL,
	"affected_blocks_count" integer NOT NULL,
	"user_choice" text,
	"ai_reschedule_suggestion" text,
	"resolved" boolean DEFAULT false,
	"created_at" text DEFAULT CURRENT_TIMESTAMP,
	"resolved_at" text
);
--> statement-breakpoint
ALTER TABLE "activity_library" ADD COLUMN "usage_count" integer DEFAULT 0;--> statement-breakpoint
ALTER TABLE "activity_library" ADD COLUMN "last_used_at" text;--> statement-breakpoint
ALTER TABLE "courses" ADD COLUMN "program_of_study" text;--> statement-breakpoint
ALTER TABLE "courses" ADD COLUMN "icon" text DEFAULT 'Zap';--> statement-breakpoint
ALTER TABLE "daily_schedules" ADD COLUMN "source" text DEFAULT 'manual';--> statement-breakpoint
ALTER TABLE "schedule_block_feedback" ADD COLUMN "topics_covered" text;--> statement-breakpoint
ALTER TABLE "user_preferences" ADD COLUMN "evening_prompt_time" text DEFAULT '18:00';--> statement-breakpoint
ALTER TABLE "user_preferences" ADD COLUMN "activity_notifications" boolean DEFAULT true;--> statement-breakpoint
ALTER TABLE "user_preferences" ADD COLUMN "notification_sound" boolean DEFAULT true;--> statement-breakpoint
ALTER TABLE "chapter_completions" ADD CONSTRAINT "chapter_completions_book_id_books_id_fk" FOREIGN KEY ("book_id") REFERENCES "public"."books"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "concept_tracking" ADD CONSTRAINT "concept_tracking_course_id_courses_id_fk" FOREIGN KEY ("course_id") REFERENCES "public"."courses"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "mission_feedback" ADD CONSTRAINT "mission_feedback_mission_id_missions_id_fk" FOREIGN KEY ("mission_id") REFERENCES "public"."missions"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE INDEX "chapter_completions_book_date_idx" ON "chapter_completions" USING btree ("book_id","completed_at");--> statement-breakpoint
CREATE INDEX "chapter_completions_date_idx" ON "chapter_completions" USING btree ("completed_at");--> statement-breakpoint
CREATE INDEX "concept_tracking_course_concept_idx" ON "concept_tracking" USING btree ("course_id","concept_name");--> statement-breakpoint
CREATE INDEX "mission_feedback_mission_id_idx" ON "mission_feedback" USING btree ("mission_id");--> statement-breakpoint
CREATE INDEX "drift_events_date_idx" ON "schedule_drift_events" USING btree ("schedule_date");--> statement-breakpoint
CREATE INDEX "drift_events_unresolved_idx" ON "schedule_drift_events" USING btree ("schedule_date","resolved");