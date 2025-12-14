CREATE TABLE "uploaded_files" (
	"id" serial PRIMARY KEY NOT NULL,
	"course_code" varchar(10) NOT NULL,
	"file_name" text NOT NULL,
	"original_name" text NOT NULL,
	"status" varchar(20) DEFAULT 'pending',
	"extracted_chunks" integer DEFAULT 0,
	"concepts" text,
	"summary" text,
	"error" text,
	"uploaded_at" text DEFAULT CURRENT_TIMESTAMP,
	"extracted_at" text
);
--> statement-breakpoint
CREATE TABLE "users" (
	"id" serial PRIMARY KEY NOT NULL,
	"email" varchar(255) NOT NULL,
	"password" text NOT NULL,
	"name" text NOT NULL,
	"has_created_first_schedule" boolean DEFAULT false,
	"created_at" text DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT "users_email_unique" UNIQUE("email")
);
--> statement-breakpoint
ALTER TABLE "courses" DROP CONSTRAINT "courses_code_unique";--> statement-breakpoint
ALTER TABLE "daily_feedback" DROP CONSTRAINT "daily_feedback_feedback_date_unique";--> statement-breakpoint
ALTER TABLE "daily_schedules" DROP CONSTRAINT "daily_schedules_schedule_date_unique";--> statement-breakpoint
ALTER TABLE "settings" DROP CONSTRAINT "settings_key_unique";--> statement-breakpoint
ALTER TABLE "user_patterns" DROP CONSTRAINT "user_patterns_pattern_type_unique";--> statement-breakpoint
ALTER TABLE "missions" ALTER COLUMN "course_id" SET DATA TYPE integer;--> statement-breakpoint
ALTER TABLE "proofs" ALTER COLUMN "mission_id" SET DATA TYPE integer;--> statement-breakpoint
ALTER TABLE "proofs" ALTER COLUMN "file_size" SET DATA TYPE integer;--> statement-breakpoint
ALTER TABLE "proofs" ALTER COLUMN "file_size" DROP NOT NULL;--> statement-breakpoint
ALTER TABLE "academic_commitments" ADD COLUMN "user_id" integer;--> statement-breakpoint
ALTER TABLE "activity_library" ADD COLUMN "user_id" integer;--> statement-breakpoint
ALTER TABLE "books" ADD COLUMN "user_id" integer;--> statement-breakpoint
ALTER TABLE "concept_tracking" ADD COLUMN "user_id" integer;--> statement-breakpoint
ALTER TABLE "courses" ADD COLUMN "user_id" integer;--> statement-breakpoint
ALTER TABLE "daily_feedback" ADD COLUMN "user_id" integer;--> statement-breakpoint
ALTER TABLE "daily_schedules" ADD COLUMN "user_id" integer;--> statement-breakpoint
ALTER TABLE "deadlines" ADD COLUMN "user_id" integer;--> statement-breakpoint
ALTER TABLE "draft_schedules" ADD COLUMN "user_id" integer;--> statement-breakpoint
ALTER TABLE "missions" ADD COLUMN "user_id" integer;--> statement-breakpoint
ALTER TABLE "notifications" ADD COLUMN "user_id" integer;--> statement-breakpoint
ALTER TABLE "schedule_block_feedback" ADD COLUMN "user_id" integer;--> statement-breakpoint
ALTER TABLE "schedule_drift_events" ADD COLUMN "user_id" integer;--> statement-breakpoint
ALTER TABLE "settings" ADD COLUMN "user_id" integer;--> statement-breakpoint
ALTER TABLE "user_patterns" ADD COLUMN "user_id" integer;--> statement-breakpoint
ALTER TABLE "user_preferences" ADD COLUMN "user_id" integer;--> statement-breakpoint
ALTER TABLE "user_preferences" ADD COLUMN "selected_sound" text DEFAULT 'chime';--> statement-breakpoint
ALTER TABLE "user_preferences" ADD COLUMN "sound_volume" integer DEFAULT 70;--> statement-breakpoint
CREATE INDEX "uploaded_files_course_code_idx" ON "uploaded_files" USING btree ("course_code");--> statement-breakpoint
CREATE INDEX "uploaded_files_status_idx" ON "uploaded_files" USING btree ("status");--> statement-breakpoint
ALTER TABLE "academic_commitments" ADD CONSTRAINT "academic_commitments_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "activity_library" ADD CONSTRAINT "activity_library_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "books" ADD CONSTRAINT "books_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "concept_tracking" ADD CONSTRAINT "concept_tracking_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courses" ADD CONSTRAINT "courses_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "daily_feedback" ADD CONSTRAINT "daily_feedback_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "daily_schedules" ADD CONSTRAINT "daily_schedules_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "deadlines" ADD CONSTRAINT "deadlines_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "draft_schedules" ADD CONSTRAINT "draft_schedules_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "missions" ADD CONSTRAINT "missions_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "notifications" ADD CONSTRAINT "notifications_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "schedule_block_feedback" ADD CONSTRAINT "schedule_block_feedback_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "schedule_drift_events" ADD CONSTRAINT "schedule_drift_events_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "settings" ADD CONSTRAINT "settings_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "user_patterns" ADD CONSTRAINT "user_patterns_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "user_preferences" ADD CONSTRAINT "user_preferences_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE INDEX "commitments_user_id_idx" ON "academic_commitments" USING btree ("user_id");--> statement-breakpoint
CREATE INDEX "activity_library_user_id_idx" ON "activity_library" USING btree ("user_id");--> statement-breakpoint
CREATE INDEX "books_user_id_idx" ON "books" USING btree ("user_id");--> statement-breakpoint
CREATE INDEX "concept_tracking_user_id_idx" ON "concept_tracking" USING btree ("user_id");--> statement-breakpoint
CREATE INDEX "courses_user_id_idx" ON "courses" USING btree ("user_id");--> statement-breakpoint
CREATE INDEX "feedback_user_date_idx" ON "daily_feedback" USING btree ("user_id","feedback_date");--> statement-breakpoint
CREATE INDEX "schedules_user_date_idx" ON "daily_schedules" USING btree ("user_id","schedule_date");--> statement-breakpoint
CREATE INDEX "deadlines_user_id_idx" ON "deadlines" USING btree ("user_id");--> statement-breakpoint
CREATE INDEX "draft_schedules_user_date_idx" ON "draft_schedules" USING btree ("user_id");--> statement-breakpoint
CREATE INDEX "missions_user_id_idx" ON "missions" USING btree ("user_id");--> statement-breakpoint
CREATE INDEX "notifications_user_id_idx" ON "notifications" USING btree ("user_id");--> statement-breakpoint
CREATE INDEX "block_feedback_user_id_idx" ON "schedule_block_feedback" USING btree ("user_id");--> statement-breakpoint
CREATE INDEX "drift_events_user_id_idx" ON "schedule_drift_events" USING btree ("user_id");--> statement-breakpoint
CREATE INDEX "settings_user_key_idx" ON "settings" USING btree ("user_id","key");--> statement-breakpoint
CREATE INDEX "user_patterns_user_pattern_idx" ON "user_patterns" USING btree ("user_id","pattern_type");--> statement-breakpoint
ALTER TABLE "user_preferences" ADD CONSTRAINT "user_preferences_user_id_unique" UNIQUE("user_id");