CREATE TABLE "academic_commitments" (
	"id" serial PRIMARY KEY NOT NULL,
	"title" text NOT NULL,
	"type" text NOT NULL,
	"course_id" integer,
	"description" text,
	"venue" text,
	"topic" text,
	"start_time" text NOT NULL,
	"end_time" text NOT NULL,
	"day_of_week" integer,
	"specific_date" date,
	"is_recurring" boolean DEFAULT false,
	"priority" integer DEFAULT 1,
	"created_at" text DEFAULT CURRENT_TIMESTAMP
);
--> statement-breakpoint
CREATE TABLE "activity_library" (
	"id" serial PRIMARY KEY NOT NULL,
	"name" text NOT NULL,
	"category" text NOT NULL,
	"default_duration" integer DEFAULT 30,
	"is_default" boolean DEFAULT false,
	"is_active" boolean DEFAULT true,
	"preferred_time" text,
	"created_at" text DEFAULT CURRENT_TIMESTAMP
);
--> statement-breakpoint
CREATE TABLE "courses" (
	"id" serial PRIMARY KEY NOT NULL,
	"code" varchar(10) NOT NULL,
	"name" text NOT NULL,
	CONSTRAINT "courses_code_unique" UNIQUE("code")
);
--> statement-breakpoint
CREATE TABLE "daily_feedback" (
	"id" serial PRIMARY KEY NOT NULL,
	"feedback_date" date NOT NULL,
	"completion_rating" integer,
	"energy_level" integer,
	"notes" text,
	"created_at" text DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT "daily_feedback_feedback_date_unique" UNIQUE("feedback_date")
);
--> statement-breakpoint
CREATE TABLE "daily_schedules" (
	"id" serial PRIMARY KEY NOT NULL,
	"schedule_date" date NOT NULL,
	"schedule_data" text NOT NULL,
	"generated_at" text DEFAULT CURRENT_TIMESTAMP,
	"ai_reasoning" text,
	CONSTRAINT "daily_schedules_schedule_date_unique" UNIQUE("schedule_date")
);
--> statement-breakpoint
CREATE TABLE "deadlines" (
	"id" serial PRIMARY KEY NOT NULL,
	"title" text NOT NULL,
	"type" text NOT NULL,
	"course_id" integer,
	"due_date" date NOT NULL,
	"due_time" text,
	"priority" integer DEFAULT 2,
	"description" text,
	"created_at" text DEFAULT CURRENT_TIMESTAMP
);
--> statement-breakpoint
CREATE TABLE "draft_schedules" (
	"id" serial PRIMARY KEY NOT NULL,
	"schedule_date" date NOT NULL,
	"schedule_data" text NOT NULL,
	"source" text NOT NULL,
	"chat_prompt" text,
	"ai_reasoning" text,
	"is_finalized" boolean DEFAULT false,
	"created_at" text DEFAULT CURRENT_TIMESTAMP
);
--> statement-breakpoint
CREATE TABLE "missions" (
	"id" serial PRIMARY KEY NOT NULL,
	"course_id" serial NOT NULL,
	"title" text NOT NULL,
	"description" text NOT NULL,
	"proof_requirement" text NOT NULL,
	"mission_date" date NOT NULL,
	"status" text DEFAULT 'pending',
	"created_at" text DEFAULT CURRENT_TIMESTAMP
);
--> statement-breakpoint
CREATE TABLE "notifications" (
	"id" serial PRIMARY KEY NOT NULL,
	"type" text NOT NULL,
	"title" text NOT NULL,
	"message" text NOT NULL,
	"mission_id" integer,
	"created_at" text DEFAULT CURRENT_TIMESTAMP
);
--> statement-breakpoint
CREATE TABLE "proofs" (
	"id" serial PRIMARY KEY NOT NULL,
	"mission_id" serial NOT NULL,
	"file_name" text NOT NULL,
	"file_size" serial NOT NULL,
	"uploaded_at" text DEFAULT CURRENT_TIMESTAMP
);
--> statement-breakpoint
CREATE TABLE "schedule_block_feedback" (
	"id" serial PRIMARY KEY NOT NULL,
	"schedule_date" date NOT NULL,
	"block_start_time" text NOT NULL,
	"completed" boolean DEFAULT false,
	"skipped" boolean DEFAULT false,
	"skip_reason" text,
	"custom_skip_reason" text,
	"energy_level" integer,
	"accuracy" text,
	"difficulty" integer,
	"actual_time_spent" integer,
	"comments" text,
	"created_at" text DEFAULT CURRENT_TIMESTAMP,
	"updated_at" text DEFAULT CURRENT_TIMESTAMP
);
--> statement-breakpoint
CREATE TABLE "settings" (
	"id" serial PRIMARY KEY NOT NULL,
	"key" varchar(50) NOT NULL,
	"value" text NOT NULL,
	"updated_at" text DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT "settings_key_unique" UNIQUE("key")
);
--> statement-breakpoint
CREATE TABLE "user_patterns" (
	"id" serial PRIMARY KEY NOT NULL,
	"pattern_type" varchar(100) NOT NULL,
	"pattern_value" text NOT NULL,
	"confidence" text DEFAULT '0.5',
	"updated_at" text DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT "user_patterns_pattern_type_unique" UNIQUE("pattern_type")
);
--> statement-breakpoint
CREATE TABLE "user_preferences" (
	"id" serial PRIMARY KEY NOT NULL,
	"wake_time" text DEFAULT '06:00',
	"sleep_time" text DEFAULT '22:00',
	"target_work_hours" integer DEFAULT 6,
	"target_free_hours" integer DEFAULT 4,
	"target_other_hours" integer DEFAULT 4,
	"consecutive_study_limit" integer DEFAULT 90,
	"personal_goals" text,
	"schedule_generation_time" text DEFAULT '06:00',
	"updated_at" text DEFAULT CURRENT_TIMESTAMP
);
--> statement-breakpoint
ALTER TABLE "academic_commitments" ADD CONSTRAINT "academic_commitments_course_id_courses_id_fk" FOREIGN KEY ("course_id") REFERENCES "public"."courses"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "deadlines" ADD CONSTRAINT "deadlines_course_id_courses_id_fk" FOREIGN KEY ("course_id") REFERENCES "public"."courses"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "missions" ADD CONSTRAINT "missions_course_id_courses_id_fk" FOREIGN KEY ("course_id") REFERENCES "public"."courses"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "proofs" ADD CONSTRAINT "proofs_mission_id_missions_id_fk" FOREIGN KEY ("mission_id") REFERENCES "public"."missions"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE INDEX "commitments_day_of_week_idx" ON "academic_commitments" USING btree ("day_of_week");--> statement-breakpoint
CREATE INDEX "commitments_specific_date_idx" ON "academic_commitments" USING btree ("specific_date");--> statement-breakpoint
CREATE INDEX "commitments_type_idx" ON "academic_commitments" USING btree ("type");--> statement-breakpoint
CREATE INDEX "feedback_date_idx" ON "daily_feedback" USING btree ("feedback_date");--> statement-breakpoint
CREATE INDEX "schedules_date_idx" ON "daily_schedules" USING btree ("schedule_date");--> statement-breakpoint
CREATE INDEX "deadlines_course_date_idx" ON "deadlines" USING btree ("course_id","due_date");--> statement-breakpoint
CREATE INDEX "deadlines_date_idx" ON "deadlines" USING btree ("due_date");--> statement-breakpoint
CREATE INDEX "draft_schedules_date_idx" ON "draft_schedules" USING btree ("schedule_date");--> statement-breakpoint
CREATE INDEX "missions_course_id_idx" ON "missions" USING btree ("course_id");--> statement-breakpoint
CREATE INDEX "missions_date_idx" ON "missions" USING btree ("mission_date");--> statement-breakpoint
CREATE INDEX "notifications_created_at_idx" ON "notifications" USING btree ("created_at");--> statement-breakpoint
CREATE INDEX "proofs_mission_id_idx" ON "proofs" USING btree ("mission_id");--> statement-breakpoint
CREATE INDEX "block_feedback_date_time_idx" ON "schedule_block_feedback" USING btree ("schedule_date","block_start_time");--> statement-breakpoint
CREATE INDEX "block_feedback_date_idx" ON "schedule_block_feedback" USING btree ("schedule_date");