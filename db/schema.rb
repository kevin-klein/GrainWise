# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2025_07_31_074449) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "anthropologies", force: :cascade do |t|
    t.integer "sex_morph"
    t.integer "sex_gen"
    t.integer "sex_consensus"
    t.string "age_as_reported"
    t.integer "age_class"
    t.float "height"
    t.string "pathologies_type"
    t.bigint "skeleton_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "species"
    t.index ["skeleton_id"], name: "index_anthropologies_on_skeleton_id"
  end

  create_table "bones", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "c14_dates", force: :cascade do |t|
    t.integer "c14_type", null: false
    t.string "lab_id"
    t.integer "age_bp"
    t.integer "interval"
    t.integer "material"
    t.float "calbc_1_sigma_max"
    t.float "calbc_1_sigma_min"
    t.float "calbc_2_sigma_max"
    t.float "calbc_2_sigma_min"
    t.string "date_note"
    t.integer "cal_method"
    t.string "ref_14c"
    t.bigint "chronology_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "bone_id"
    t.index ["bone_id"], name: "index_c14_dates_on_bone_id"
    t.index ["chronology_id"], name: "index_c14_dates_on_chronology_id"
  end

  create_table "chronologies", force: :cascade do |t|
    t.integer "context_from"
    t.integer "context_to"
    t.bigint "skeleton_id"
    t.bigint "grave_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "period_id"
    t.index ["grave_id"], name: "index_chronologies_on_grave_id"
    t.index ["period_id"], name: "index_chronologies_on_period_id"
    t.index ["skeleton_id"], name: "index_chronologies_on_skeleton_id"
  end

  create_table "cultures", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "figures", force: :cascade do |t|
    t.bigint "upload_item_id", null: false
    t.integer "x1"
    t.integer "x2"
    t.integer "y1"
    t.integer "y2"
    t.string "type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "area"
    t.float "perimeter"
    t.float "milli_meter_ratio"
    t.integer "parent_id"
    t.string "identifier"
    t.float "width"
    t.float "height"
    t.string "text"
    t.integer "upload_id"
    t.boolean "manual_bounding_box", default: false
    t.float "probability"
    t.float "real_world_area"
    t.float "real_world_width"
    t.float "real_world_height"
    t.float "real_world_perimeter"
    t.integer "strain_id"
    t.integer "control_points", array: true
    t.integer "anchor_points", array: true
    t.integer "view"
    t.jsonb "contour"
    t.index ["upload_item_id"], name: "index_figures_on_upload_item_id"
  end

  create_table "figures_tags", force: :cascade do |t|
    t.bigint "tag_id"
    t.bigint "figure_id"
    t.index ["figure_id"], name: "index_figures_tags_on_figure_id"
    t.index ["tag_id"], name: "index_figures_tags_on_tag_id"
  end

  create_table "genetics", force: :cascade do |t|
    t.integer "data_type"
    t.float "endo_content"
    t.string "ref_gen"
    t.bigint "skeleton_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "mt_haplogroup_id"
    t.bigint "y_haplogroup_id"
    t.bigint "bone_id"
    t.index ["bone_id"], name: "index_genetics_on_bone_id"
    t.index ["mt_haplogroup_id"], name: "index_genetics_on_mt_haplogroup_id"
    t.index ["skeleton_id"], name: "index_genetics_on_skeleton_id"
    t.index ["y_haplogroup_id"], name: "index_genetics_on_y_haplogroup_id"
  end

  create_table "grains", force: :cascade do |t|
    t.bigint "site_id", null: false
    t.bigint "strain_id", null: false
    t.bigint "dorsal_id"
    t.bigint "ventral_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "identifier"
    t.bigint "lateral_id"
    t.bigint "ts_id"
    t.bigint "upload_id"
    t.boolean "complete"
    t.boolean "validated"
    t.index ["dorsal_id"], name: "index_grains_on_dorsal_id"
    t.index ["lateral_id"], name: "index_grains_on_lateral_id"
    t.index ["site_id"], name: "index_grains_on_site_id"
    t.index ["strain_id"], name: "index_grains_on_strain_id"
    t.index ["ts_id"], name: "index_grains_on_ts_id"
    t.index ["upload_id"], name: "index_grains_on_upload_id"
    t.index ["ventral_id"], name: "index_grains_on_ventral_id"
  end

  create_table "images", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "width"
    t.integer "height"
  end

  create_table "kurgans", force: :cascade do |t|
    t.integer "width"
    t.integer "height"
    t.string "name", null: false
    t.bigint "publication_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["publication_id"], name: "index_kurgans_on_publication_id"
  end

  create_table "mt_haplogroups", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "page_texts", force: :cascade do |t|
    t.bigint "page_id", null: false
    t.string "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["page_id"], name: "index_page_texts_on_page_id"
  end

  create_table "periods", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sites", force: :cascade do |t|
    t.float "lat"
    t.float "lon"
    t.string "name"
    t.string "locality"
    t.integer "country_code"
    t.string "site_code"
  end

  create_table "skeletons", force: :cascade do |t|
    t.integer "figure_id", null: false
    t.float "angle"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "skeleton_id"
    t.integer "funerary_practice"
    t.integer "inhumation_type"
    t.integer "anatonimcal_connection"
    t.integer "body_position"
    t.integer "crouching_type"
    t.string "other"
    t.float "head_facing"
    t.integer "ochre"
    t.integer "ochre_position"
    t.bigint "skeleton_figure_id"
    t.bigint "site_id"
    t.index ["figure_id"], name: "index_skeletons_on_figure_id"
    t.index ["site_id"], name: "index_skeletons_on_site_id"
    t.index ["skeleton_figure_id"], name: "index_skeletons_on_skeleton_figure_id"
  end

  create_table "stable_isotopes", force: :cascade do |t|
    t.bigint "skeleton_id", null: false
    t.string "iso_id"
    t.float "iso_value"
    t.string "ref_iso"
    t.integer "isotope"
    t.integer "baseline"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "bone_id"
    t.index ["bone_id"], name: "index_stable_isotopes_on_bone_id"
    t.index ["skeleton_id"], name: "index_stable_isotopes_on_skeleton_id"
  end

  create_table "strains", force: :cascade do |t|
    t.string "name"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "taxonomies", force: :cascade do |t|
    t.bigint "skeleton_id"
    t.string "culture_note"
    t.string "culture_reference"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "culture_id"
    t.index ["culture_id"], name: "index_taxonomies_on_culture_id"
    t.index ["skeleton_id"], name: "index_taxonomies_on_skeleton_id"
  end

  create_table "text_items", force: :cascade do |t|
    t.bigint "page_id", null: false
    t.string "text"
    t.integer "x1"
    t.integer "x2"
    t.integer "y1"
    t.integer "y2"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["page_id"], name: "index_text_items_on_page_id"
  end

  create_table "upload_items", force: :cascade do |t|
    t.bigint "upload_id", null: false
    t.bigint "image_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["image_id"], name: "index_upload_items_on_image_id"
    t.index ["upload_id"], name: "index_upload_items_on_upload_id"
  end

  create_table "uploads", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.boolean "public", default: false, null: false
    t.string "name"
    t.integer "site_id"
    t.integer "strain_id"
    t.integer "view"
    t.string "feature"
    t.string "sample"
    t.index ["user_id"], name: "index_uploads_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "code_hash"
    t.string "name"
    t.integer "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "y_haplogroups", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "figures", "upload_items", on_delete: :cascade
  add_foreign_key "genetics", "skeletons"
  add_foreign_key "grains", "figures", column: "dorsal_id"
  add_foreign_key "grains", "figures", column: "lateral_id"
  add_foreign_key "grains", "figures", column: "ts_id"
  add_foreign_key "grains", "figures", column: "ventral_id"
  add_foreign_key "grains", "sites"
  add_foreign_key "grains", "strains"
  add_foreign_key "page_texts", "upload_items", column: "page_id"
  add_foreign_key "skeletons", "figures"
  add_foreign_key "stable_isotopes", "skeletons"
  add_foreign_key "text_items", "upload_items", column: "page_id"
  add_foreign_key "upload_items", "images", on_delete: :cascade
  add_foreign_key "upload_items", "uploads", on_delete: :cascade
end
