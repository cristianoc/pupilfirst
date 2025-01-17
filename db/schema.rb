# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_10_30_080004) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_stat_statements"
  enable_extension "pg_trgm"
  enable_extension "plpgsql"

  create_table "active_admin_comments", id: :serial, force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type", null: false
    t.integer "author_id"
    t.string "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "resource_id", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "admin_users", id: :serial, force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "username"
    t.string "fullname"
    t.integer "user_id"
    t.string "email"
    t.index ["user_id"], name: "index_admin_users_on_user_id"
  end

  create_table "ahoy_events", id: :uuid, default: nil, force: :cascade do |t|
    t.uuid "visit_id"
    t.integer "user_id"
    t.string "user_type"
    t.string "name"
    t.jsonb "properties"
    t.datetime "time"
    t.index ["time"], name: "index_ahoy_events_on_time"
    t.index ["user_id", "user_type"], name: "index_ahoy_events_on_user_id_and_user_type"
    t.index ["visit_id"], name: "index_ahoy_events_on_visit_id"
  end

  create_table "answer_likes", force: :cascade do |t|
    t.bigint "answer_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["answer_id", "user_id"], name: "index_answer_likes_on_answer_id_and_user_id", unique: true
    t.index ["user_id"], name: "index_answer_likes_on_user_id"
  end

  create_table "answer_options", force: :cascade do |t|
    t.bigint "quiz_question_id"
    t.text "value"
    t.text "hint"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quiz_question_id"], name: "index_answer_options_on_quiz_question_id"
  end

  create_table "answers", force: :cascade do |t|
    t.text "description"
    t.bigint "question_id"
    t.bigint "creator_id"
    t.bigint "editor_id"
    t.bigint "archiver_id"
    t.boolean "archived", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["archiver_id"], name: "index_answers_on_archiver_id"
    t.index ["creator_id"], name: "index_answers_on_creator_id"
    t.index ["editor_id"], name: "index_answers_on_editor_id"
    t.index ["question_id"], name: "index_answers_on_question_id"
  end

  create_table "applicants", force: :cascade do |t|
    t.string "email"
    t.string "name"
    t.string "login_token"
    t.datetime "login_mail_sent_at"
    t.bigint "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_applicants_on_course_id"
    t.index ["login_token"], name: "index_applicants_on_login_token", unique: true
  end

  create_table "colleges", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "also_known_as"
    t.string "city"
    t.integer "state_id"
    t.string "established_year"
    t.string "website"
    t.string "contact_numbers"
    t.integer "university_id"
    t.index ["state_id"], name: "index_colleges_on_state_id"
    t.index ["university_id"], name: "index_colleges_on_university_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text "value"
    t.string "commentable_type"
    t.bigint "commentable_id"
    t.datetime "archived_at"
    t.bigint "creator_id"
    t.bigint "editor_id"
    t.bigint "archiver_id"
    t.boolean "archived", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["archiver_id"], name: "index_comments_on_archiver_id"
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id"
    t.index ["creator_id"], name: "index_comments_on_creator_id"
    t.index ["editor_id"], name: "index_comments_on_editor_id"
  end

  create_table "communities", force: :cascade do |t|
    t.string "name"
    t.boolean "target_linkable", default: false
    t.bigint "school_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["school_id"], name: "index_communities_on_school_id"
  end

  create_table "community_course_connections", force: :cascade do |t|
    t.bigint "community_id"
    t.bigint "course_id"
    t.index ["community_id"], name: "index_community_course_connections_on_community_id"
    t.index ["course_id", "community_id"], name: "index_community_course_connection_on_course_id_and_community_id", unique: true
  end

  create_table "connect_requests", id: :serial, force: :cascade do |t|
    t.integer "connect_slot_id"
    t.integer "startup_id"
    t.text "questions"
    t.string "status"
    t.string "meeting_link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "confirmed_at"
    t.datetime "feedback_mails_sent_at"
    t.integer "rating_for_faculty"
    t.integer "rating_for_team"
    t.text "comment_for_faculty"
    t.text "comment_for_team"
    t.index ["connect_slot_id"], name: "index_connect_requests_on_connect_slot_id"
    t.index ["startup_id"], name: "index_connect_requests_on_startup_id"
  end

  create_table "connect_slots", id: :serial, force: :cascade do |t|
    t.integer "faculty_id"
    t.datetime "slot_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["faculty_id"], name: "index_connect_slots_on_faculty_id"
  end

  create_table "content_blocks", force: :cascade do |t|
    t.string "block_type"
    t.json "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["block_type"], name: "index_content_blocks_on_block_type"
  end

  create_table "content_versions", force: :cascade do |t|
    t.bigint "target_id"
    t.bigint "content_block_id"
    t.date "version_on"
    t.integer "sort_index"
    t.index ["content_block_id"], name: "index_content_versions_on_content_block_id"
    t.index ["target_id"], name: "index_content_versions_on_target_id"
    t.index ["version_on"], name: "index_content_versions_on_version_on"
  end

  create_table "course_authors", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "course_id"
    t.boolean "exited"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_course_authors_on_course_id"
    t.index ["user_id"], name: "index_course_authors_on_user_id"
  end

  create_table "course_exports", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_course_exports_on_course_id"
    t.index ["user_id"], name: "index_course_exports_on_user_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "school_id"
    t.integer "max_grade"
    t.integer "pass_grade"
    t.json "grade_labels"
    t.datetime "ends_at"
    t.string "description"
    t.boolean "enable_leaderboard", default: false
    t.boolean "public_signup", default: false
    t.text "about"
    t.index ["school_id"], name: "index_courses_on_school_id"
  end

  create_table "data_migrations", id: false, force: :cascade do |t|
    t.string "version", null: false
    t.index ["version"], name: "unique_data_migrations", unique: true
  end

  create_table "delayed_jobs", id: :serial, force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "domains", force: :cascade do |t|
    t.bigint "school_id"
    t.string "fqdn"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "primary", default: false
    t.index ["fqdn"], name: "index_domains_on_fqdn", unique: true
    t.index ["school_id"], name: "index_domains_on_school_id"
  end

  create_table "evaluation_criteria", force: :cascade do |t|
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.bigint "course_id"
    t.index ["course_id"], name: "index_evaluation_criteria_on_course_id"
  end

  create_table "faculty", id: :serial, force: :cascade do |t|
    t.string "category"
    t.integer "sort_index"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "token"
    t.boolean "self_service"
    t.string "current_commitment"
    t.string "commitment"
    t.string "compensation"
    t.string "slack_username"
    t.string "slack_user_id"
    t.bigint "user_id"
    t.bigint "school_id"
    t.boolean "public", default: false
    t.string "connect_link"
    t.boolean "notify_for_submission", default: false
    t.boolean "exited", default: false
    t.index ["category"], name: "index_faculty_on_category"
    t.index ["school_id", "user_id"], name: "index_faculty_on_school_id_and_user_id", unique: true
    t.index ["user_id"], name: "index_faculty_on_user_id"
  end

  create_table "faculty_course_enrollments", force: :cascade do |t|
    t.bigint "faculty_id"
    t.bigint "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id", "faculty_id"], name: "index_faculty_course_enrollments_on_course_id_and_faculty_id", unique: true
    t.index ["faculty_id"], name: "index_faculty_course_enrollments_on_faculty_id"
  end

  create_table "faculty_startup_enrollments", force: :cascade do |t|
    t.bigint "faculty_id"
    t.bigint "startup_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["faculty_id"], name: "index_faculty_startup_enrollments_on_faculty_id"
    t.index ["startup_id", "faculty_id"], name: "index_faculty_startup_enrollments_on_startup_id_and_faculty_id", unique: true
  end

  create_table "features", id: :serial, force: :cascade do |t|
    t.string "key"
    t.string "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "founders", id: :serial, force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "startup_id"
    t.string "auth_token"
    t.string "slack_username"
    t.integer "university_id"
    t.string "roles"
    t.string "slack_user_id"
    t.boolean "exited", default: false
    t.integer "user_id"
    t.integer "college_id"
    t.boolean "dashboard_toured"
    t.string "college_text"
    t.integer "resume_file_id"
    t.string "slack_access_token"
    t.boolean "excluded_from_leaderboard", default: false
    t.index ["college_id"], name: "index_founders_on_college_id"
    t.index ["university_id"], name: "index_founders_on_university_id"
    t.index ["user_id"], name: "index_founders_on_user_id"
  end

  create_table "leaderboard_entries", force: :cascade do |t|
    t.bigint "founder_id"
    t.datetime "period_from", null: false
    t.datetime "period_to", null: false
    t.integer "score", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["founder_id", "period_from", "period_to"], name: "index_leaderboard_entries_on_founder_id_and_period", unique: true
    t.index ["founder_id"], name: "index_leaderboard_entries_on_founder_id"
  end

  create_table "levels", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "unlock_on"
    t.bigint "course_id"
    t.index ["course_id"], name: "index_levels_on_course_id"
    t.index ["number"], name: "index_levels_on_number"
  end

  create_table "markdown_attachments", force: :cascade do |t|
    t.string "token"
    t.datetime "last_accessed_at"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_markdown_attachments_on_user_id"
  end

  create_table "platform_feedback", id: :serial, force: :cascade do |t|
    t.string "feedback_type"
    t.text "description"
    t.integer "promoter_score"
    t.integer "founder_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "notes"
    t.index ["founder_id"], name: "index_platform_feedback_on_founder_id"
  end

  create_table "prospective_applicants", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone"
    t.integer "college_id"
    t.string "college_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["college_id"], name: "index_prospective_applicants_on_college_id"
  end

  create_table "public_slack_messages", id: :serial, force: :cascade do |t|
    t.text "body"
    t.string "slack_username"
    t.integer "founder_id"
    t.string "channel"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "timestamp"
    t.integer "reaction_to_id"
    t.index ["founder_id"], name: "index_public_slack_messages_on_founder_id"
  end

  create_table "questions", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.bigint "community_id"
    t.bigint "creator_id"
    t.bigint "editor_id"
    t.bigint "archiver_id"
    t.boolean "archived", default: false
    t.datetime "last_activity_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["archiver_id"], name: "index_questions_on_archiver_id"
    t.index ["community_id"], name: "index_questions_on_community_id"
    t.index ["creator_id"], name: "index_questions_on_creator_id"
    t.index ["editor_id"], name: "index_questions_on_editor_id"
  end

  create_table "quiz_questions", force: :cascade do |t|
    t.text "question"
    t.text "description"
    t.bigint "quiz_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "correct_answer_id"
    t.index ["correct_answer_id"], name: "index_quiz_questions_on_correct_answer_id"
    t.index ["quiz_id"], name: "index_quiz_questions_on_quiz_id"
  end

  create_table "quizzes", force: :cascade do |t|
    t.string "title"
    t.bigint "target_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["target_id"], name: "index_quizzes_on_target_id"
  end

  create_table "resource_versions", force: :cascade do |t|
    t.jsonb "value"
    t.string "versionable_type"
    t.bigint "versionable_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["versionable_type", "versionable_id"], name: "index_resource_versions_on_versionable_type_and_versionable_id"
  end

  create_table "resources", id: :serial, force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "downloads", default: 0
    t.string "slug"
    t.text "video_embed"
    t.string "link"
    t.boolean "archived", default: false
    t.boolean "public", default: false
    t.bigint "school_id"
    t.index ["archived"], name: "index_resources_on_archived"
    t.index ["school_id"], name: "index_resources_on_school_id"
    t.index ["slug"], name: "index_resources_on_slug"
  end

  create_table "school_admins", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "school_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["school_id"], name: "index_school_admins_on_school_id"
    t.index ["user_id", "school_id"], name: "index_school_admins_on_user_id_and_school_id", unique: true
    t.index ["user_id"], name: "index_school_admins_on_user_id"
  end

  create_table "school_links", force: :cascade do |t|
    t.bigint "school_id"
    t.string "title"
    t.string "url"
    t.string "kind"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["school_id", "kind"], name: "index_school_links_on_school_id_and_kind"
  end

  create_table "school_strings", force: :cascade do |t|
    t.bigint "school_id"
    t.string "key"
    t.text "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["school_id", "key"], name: "index_school_strings_on_school_id_and_key", unique: true
  end

  create_table "schools", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shortened_urls", id: :serial, force: :cascade do |t|
    t.integer "owner_id"
    t.string "owner_type", limit: 20
    t.text "url", null: false
    t.string "unique_key", limit: 100, null: false
    t.integer "use_count", default: 0, null: false
    t.datetime "expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["owner_id", "owner_type"], name: "index_shortened_urls_on_owner_id_and_owner_type"
    t.index ["unique_key"], name: "index_shortened_urls_on_unique_key", unique: true
    t.index ["url"], name: "index_shortened_urls_on_url"
  end

  create_table "startup_feedback", id: :serial, force: :cascade do |t|
    t.text "feedback"
    t.string "reference_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "startup_id"
    t.datetime "sent_at"
    t.integer "faculty_id"
    t.string "activity_type"
    t.string "attachment"
    t.integer "timeline_event_id"
    t.index ["faculty_id"], name: "index_startup_feedback_on_faculty_id"
    t.index ["timeline_event_id"], name: "index_startup_feedback_on_timeline_event_id"
  end

  create_table "startups", id: :serial, force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "name"
    t.string "slug"
    t.integer "level_id"
    t.datetime "access_ends_at"
    t.index ["level_id"], name: "index_startups_on_level_id"
    t.index ["slug"], name: "index_startups_on_slug", unique: true
  end

  create_table "states", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.integer "taggable_id"
    t.string "taggable_type"
    t.integer "tagger_id"
    t.string "tagger_type"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "target_evaluation_criteria", force: :cascade do |t|
    t.bigint "target_id"
    t.bigint "evaluation_criterion_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["evaluation_criterion_id"], name: "index_target_evaluation_criteria_on_evaluation_criterion_id"
    t.index ["target_id"], name: "index_target_evaluation_criteria_on_target_id"
  end

  create_table "target_groups", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sort_index"
    t.boolean "milestone"
    t.integer "level_id"
    t.boolean "archived", default: false
    t.index ["level_id"], name: "index_target_groups_on_level_id"
    t.index ["sort_index"], name: "index_target_groups_on_sort_index"
  end

  create_table "target_prerequisites", id: :serial, force: :cascade do |t|
    t.integer "target_id"
    t.integer "prerequisite_target_id"
    t.index ["prerequisite_target_id"], name: "index_target_prerequisites_on_prerequisite_target_id"
    t.index ["target_id"], name: "index_target_prerequisites_on_target_id"
  end

  create_table "target_questions", force: :cascade do |t|
    t.bigint "question_id"
    t.bigint "target_id"
    t.index ["question_id"], name: "index_target_questions_on_question_id"
    t.index ["target_id", "question_id"], name: "index_target_questions_on_target_id_and_question_id", unique: true
  end

  create_table "target_resources", force: :cascade do |t|
    t.bigint "target_id", null: false
    t.bigint "resource_id", null: false
    t.index ["resource_id"], name: "index_target_resources_on_resource_id"
    t.index ["target_id", "resource_id"], name: "index_target_resources_on_target_id_and_resource_id", unique: true
  end

  create_table "targets", id: :serial, force: :cascade do |t|
    t.string "role"
    t.string "title"
    t.text "description"
    t.string "completion_instructions"
    t.string "resource_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "slideshow_embed"
    t.integer "faculty_id"
    t.integer "days_to_complete"
    t.string "target_action_type"
    t.integer "target_group_id"
    t.integer "sort_index", default: 999
    t.datetime "session_at"
    t.text "video_embed"
    t.datetime "last_session_at"
    t.string "link_to_complete"
    t.boolean "archived", default: false
    t.string "youtube_video_id"
    t.string "google_calendar_event_id"
    t.datetime "feedback_asked_at"
    t.datetime "slack_reminders_sent_at"
    t.string "call_to_action"
    t.text "rubric_description"
    t.boolean "resubmittable", default: true
    t.string "visibility"
    t.jsonb "review_checklist", default: []
    t.index ["archived"], name: "index_targets_on_archived"
    t.index ["faculty_id"], name: "index_targets_on_faculty_id"
    t.index ["session_at"], name: "index_targets_on_session_at"
  end

  create_table "text_versions", force: :cascade do |t|
    t.text "value"
    t.string "versionable_type"
    t.bigint "versionable_id"
    t.bigint "user_id"
    t.datetime "edited_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_text_versions_on_user_id"
    t.index ["versionable_type", "versionable_id"], name: "index_text_versions_on_versionable_type_and_versionable_id"
  end

  create_table "timeline_event_files", id: :serial, force: :cascade do |t|
    t.integer "timeline_event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.index ["timeline_event_id"], name: "index_timeline_event_files_on_timeline_event_id"
  end

  create_table "timeline_event_grades", force: :cascade do |t|
    t.bigint "timeline_event_id"
    t.bigint "evaluation_criterion_id"
    t.integer "grade"
    t.index ["evaluation_criterion_id"], name: "index_timeline_event_grades_on_evaluation_criterion_id"
    t.index ["timeline_event_id", "evaluation_criterion_id"], name: "by_timeline_event_criterion", unique: true
    t.index ["timeline_event_id"], name: "index_timeline_event_grades_on_timeline_event_id"
  end

  create_table "timeline_event_owners", force: :cascade do |t|
    t.bigint "timeline_event_id"
    t.bigint "founder_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["founder_id"], name: "index_timeline_event_owners_on_founder_id"
    t.index ["timeline_event_id"], name: "index_timeline_event_owners_on_timeline_event_id"
  end

  create_table "timeline_events", id: :serial, force: :cascade do |t|
    t.text "description"
    t.string "image"
    t.text "links"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "improved_timeline_event_id"
    t.integer "target_id"
    t.decimal "score", precision: 2, scale: 1
    t.integer "evaluator_id"
    t.datetime "passed_at"
    t.boolean "latest"
    t.string "quiz_score"
    t.datetime "evaluated_at"
  end

  create_table "universities", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "state_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["state_id"], name: "index_universities_on_state_id"
  end

  create_table "user_activities", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "activity_type"
    t.json "metadata"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_activities_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email"
    t.string "login_token"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "encrypted_password", default: "", null: false
    t.string "remember_token"
    t.boolean "sign_out_at_next_request"
    t.datetime "email_bounced_at"
    t.string "email_bounce_type"
    t.datetime "confirmed_at"
    t.datetime "login_mail_sent_at"
    t.string "name"
    t.string "phone"
    t.string "communication_address"
    t.string "title"
    t.string "key_skills"
    t.text "about"
    t.string "resume_url"
    t.string "blog_url"
    t.string "personal_website_url"
    t.string "linkedin_url"
    t.string "twitter_url"
    t.string "facebook_url"
    t.string "angel_co_url"
    t.string "github_url"
    t.string "behance_url"
    t.string "skype_id"
    t.bigint "school_id"
    t.jsonb "preferences", default: {}, null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string "affiliation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["school_id"], name: "index_users_on_school_id"
  end

  create_table "visits", id: :uuid, default: nil, force: :cascade do |t|
    t.uuid "visitor_id"
    t.string "ip"
    t.text "user_agent"
    t.text "referrer"
    t.text "landing_page"
    t.integer "user_id"
    t.string "user_type"
    t.string "referring_domain"
    t.string "search_keyword"
    t.string "browser"
    t.string "os"
    t.string "device_type"
    t.integer "screen_height"
    t.integer "screen_width"
    t.string "country"
    t.string "region"
    t.string "city"
    t.string "postal_code"
    t.decimal "latitude"
    t.decimal "longitude"
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_term"
    t.string "utm_content"
    t.string "utm_campaign"
    t.datetime "started_at"
    t.index ["user_id", "user_type"], name: "index_visits_on_user_id_and_user_type"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "admin_users", "users"
  add_foreign_key "answer_options", "quiz_questions"
  add_foreign_key "applicants", "courses"
  add_foreign_key "communities", "schools"
  add_foreign_key "community_course_connections", "communities"
  add_foreign_key "community_course_connections", "courses"
  add_foreign_key "connect_requests", "connect_slots"
  add_foreign_key "connect_requests", "startups"
  add_foreign_key "connect_slots", "faculty"
  add_foreign_key "content_versions", "content_blocks"
  add_foreign_key "content_versions", "targets"
  add_foreign_key "course_authors", "courses"
  add_foreign_key "course_authors", "users"
  add_foreign_key "course_exports", "courses"
  add_foreign_key "course_exports", "users"
  add_foreign_key "courses", "schools"
  add_foreign_key "domains", "schools"
  add_foreign_key "faculty", "schools"
  add_foreign_key "faculty_course_enrollments", "courses"
  add_foreign_key "faculty_course_enrollments", "faculty"
  add_foreign_key "faculty_startup_enrollments", "faculty"
  add_foreign_key "faculty_startup_enrollments", "startups"
  add_foreign_key "founders", "colleges"
  add_foreign_key "founders", "users"
  add_foreign_key "leaderboard_entries", "founders"
  add_foreign_key "levels", "courses"
  add_foreign_key "markdown_attachments", "users"
  add_foreign_key "quiz_questions", "answer_options", column: "correct_answer_id"
  add_foreign_key "quiz_questions", "quizzes"
  add_foreign_key "quizzes", "targets"
  add_foreign_key "school_admins", "schools"
  add_foreign_key "school_admins", "users"
  add_foreign_key "school_links", "schools"
  add_foreign_key "school_strings", "schools"
  add_foreign_key "startup_feedback", "faculty"
  add_foreign_key "startup_feedback", "timeline_events"
  add_foreign_key "startups", "levels"
  add_foreign_key "target_evaluation_criteria", "evaluation_criteria"
  add_foreign_key "target_evaluation_criteria", "targets"
  add_foreign_key "target_groups", "levels"
  add_foreign_key "target_questions", "questions"
  add_foreign_key "target_questions", "targets"
  add_foreign_key "target_resources", "resources"
  add_foreign_key "target_resources", "targets"
  add_foreign_key "timeline_event_files", "timeline_events"
  add_foreign_key "timeline_events", "faculty", column: "evaluator_id"
  add_foreign_key "user_activities", "users"
  add_foreign_key "users", "schools"
end
