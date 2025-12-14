-- Fix uploaded_files table to match schema
DROP TABLE IF EXISTS "uploaded_files" CASCADE;--> statement-breakpoint
CREATE TABLE "uploaded_files" (
    "id" serial PRIMARY KEY NOT NULL,
    "course_code" varchar(10) NOT NULL,
    "file_name" text NOT NULL,
    "original_name" text NOT NULL,
    "file_size" integer,
    "mime_type" text,
    "stage" varchar(30) DEFAULT 'uploaded',
    "stage_progress" integer DEFAULT 0,
    "extracted_text" text,
    "extracted_chunks" integer DEFAULT 0,
    "embedded_chunks" integer DEFAULT 0,
    "concepts" text,
    "summary" text,
    "error" text,
    "uploaded_at" text DEFAULT CURRENT_TIMESTAMP,
    "completed_at" text
);--> statement-breakpoint
CREATE INDEX "uploaded_files_course_code_idx" ON "uploaded_files" USING btree ("course_code");--> statement-breakpoint
CREATE INDEX "uploaded_files_stage_idx" ON "uploaded_files" USING btree ("stage");
