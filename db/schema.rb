# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_05_14_145532) do

  create_table "app_child_screen_menus", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "app_parent_category_menu", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "id_app_parent_category_menu"
    t.string "description_category_menu"
    t.integer "activated_category_menu"
  end

  create_table "app_rel_parent_child_menus", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "asociados", primary_key: "id_asociado", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "nombre_asociado", limit: 100
    t.string "apellido_asociado", limit: 100
    t.string "celular_asociado", limit: 15
    t.string "email_asociado", limit: 50
    t.datetime "fecha_registro_asociado", default: -> { "CURRENT_TIMESTAMP" }
  end

  create_table "autoridad", primary_key: "id_autoridad", id: :integer, default: nil, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "descripcion", limit: 20, null: false
  end

  create_table "clientes", primary_key: "id_cliente", id: :integer, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "nomcliente", limit: 30, null: false
    t.string "apecliente", limit: 30, null: false
    t.string "domicilio", limit: 100, null: false
    t.string "email_cliente", limit: 50
    t.string "telefono", limit: 50, null: false
  end

  create_table "diaoperativo", primary_key: "id_diaoperativo", id: :integer, default: nil, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "periodo_semana_dia", limit: 8, default: "", null: false
    t.datetime "fecha_diaoperativo", null: false
  end

  create_table "felicitaciones", primary_key: "id_felicitacion", id: :integer, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "felicitacion", null: false
    t.integer "id_cliente", null: false
    t.timestamp "fecha_felicitacion", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.boolean "id_usuario", default: false
    t.integer "id_diaoperativo", null: false
    t.string "periodo", limit: 3, null: false
  end

  create_table "gerentes", primary_key: "id_gerente", id: :integer, default: nil, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "nomgerente", limit: 80, null: false
    t.integer "id_usuario"
    t.string "email_gerente", limit: 40, null: false
  end

  create_table "importancia", primary_key: "id_importancia", id: :integer, limit: 1, default: nil, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "descripcion_importancia", limit: 30, null: false
  end

  create_table "quejas", primary_key: "id_queja", id: :integer, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "queja", null: false
    t.integer "id_unidad", default: 0
    t.integer "id_supervisor", default: 0
    t.integer "id_cliente", null: false
    t.datetime "fechaqueja"
    t.integer "id_status", default: 1
    t.integer "id_importancia", default: 1
    t.integer "id_zona", null: false
    t.datetime "fechasolucion"
    t.text "comentario_queja"
    t.integer "id_usuario", default: 0
    t.integer "id_diaoperativo"
    t.string "periodo", limit: 3, null: false
    t.integer "id_tipoqueja", null: false
  end

  create_table "rel_unidad_supervisor", primary_key: "id_unidad", id: :integer, default: nil, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "id_supervisor", null: false
    t.integer "id_zona", default: 0
  end

  create_table "solicitudes_asociados", primary_key: ["id_solicitudes_asociados", "id_asociado", "id_status"], options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "id_solicitudes_asociados", null: false, auto_increment: true
    t.integer "id_asociado", default: 0, null: false
    t.integer "id_status", default: 1, null: false
    t.integer "id_unidad", default: 0, null: false
    t.text "descripcion_solicitudes_asociados"
    t.datetime "fecha_registro_solicitudes_asociados", default: -> { "CURRENT_TIMESTAMP" }
    t.datetime "fecha_expiracion_solicitudes_asociados", default: -> { "CURRENT_TIMESTAMP" }
  end

  create_table "status", primary_key: "id_status", id: :boolean, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "descripcion_status", limit: 20, null: false
    t.string "backgroundcolor_status", limit: 10
    t.string "fontcolor_status", limit: 10
  end

  create_table "sugerencias", primary_key: "id_sugerencia", id: :integer, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "sugerencia", null: false
    t.integer "id_cliente", null: false
    t.timestamp "fecha_sugerencia", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.boolean "id_usuario", default: false
    t.integer "id_diaoperativo", null: false
    t.string "periodo", limit: 3, null: false
  end

  create_table "supervisores", primary_key: "id_supervisor", id: :integer, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "nomsupervisor", limit: 80, null: false
    t.integer "vigencia_supervisor", default: 1
    t.integer "id_gerente", null: false
    t.string "email_supervisor", limit: 40, null: false
  end

  create_table "temporal_periodoactual", id: false, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "id_unidad", null: false
    t.string "temporal_periodo", limit: 4, null: false
    t.integer "total_incidencias", null: false
  end

  create_table "temporal_periodopasado", id: false, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "id_unidad", null: false
    t.string "temporal_periodo", limit: 4, null: false
    t.integer "total_incidencias", null: false
  end

  create_table "tipoqueja", primary_key: "id_tipoqueja", id: :integer, default: nil, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "descripcion_tipoqueja", limit: 20, null: false
  end

  create_table "usuarios", primary_key: "id_usuario", id: :integer, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "nomusuario", limit: 20
    t.string "apusuario", limit: 20
    t.string "login", limit: 20
    t.string "email", limit: 100
    t.string "password", limit: 11
    t.boolean "vigencia", default: true
    t.integer "id_autoridad", limit: 1, null: false
    t.string "password_digest", limit: 500
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }
    t.datetime "update_at", default: -> { "CURRENT_TIMESTAMP" }
  end

  create_table "zonas", primary_key: "id_zona", id: :integer, default: nil, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "nomzona", limit: 20, null: false
  end

end
