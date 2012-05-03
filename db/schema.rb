# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120428163556) do

  create_table "pessoas", :force => true do |t|
    t.string   "nome"
    t.string   "email"
    t.string   "telefone"
    t.integer  "usuario_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "pessoas", ["usuario_id"], :name => "index_pessoas_on_usuario_id"

  create_table "projetos", :force => true do |t|
    t.string   "nome"
    t.text     "descricao"
    t.date     "inicio"
    t.date     "fim"
    t.date     "previsao_fim"
    t.string   "status"
    t.integer  "cliente_id"
    t.float    "gastos_previsto"
    t.float    "gastos_final"
    t.integer  "usuario_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "projetos", ["usuario_id"], :name => "index_projetos_on_usuario_id"

  create_table "recursos", :force => true do |t|
    t.string   "nome"
    t.text     "observacao"
    t.integer  "usuario_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "recursos", ["usuario_id"], :name => "index_recursos_on_usuario_id"

  create_table "recursos_servico_etapas", :id => false, :force => true do |t|
    t.integer "recurso_id",       :null => false
    t.integer "servico_etapa_id", :null => false
  end

  create_table "recursos_tarefa_etapas", :id => false, :force => true do |t|
    t.integer "recurso_id",      :null => false
    t.integer "tarefa_etapa_id", :null => false
  end

  create_table "servico_etapas", :force => true do |t|
    t.string   "nome"
    t.text     "descricao"
    t.integer  "servico_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "servico_etapas", ["servico_id"], :name => "index_servico_etapas_on_servico_id"

  create_table "servicos", :force => true do |t|
    t.string   "nome"
    t.text     "descricao"
    t.integer  "usuario_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "servicos", ["usuario_id"], :name => "index_servicos_on_usuario_id"

  create_table "tarefa_anexos", :force => true do |t|
    t.string   "titulo"
    t.text     "descricao"
    t.integer  "tarefa_id"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.string   "documento_file_name"
    t.string   "documento_content_type"
    t.integer  "documento_file_size"
    t.datetime "documento_updated_at"
  end

  add_index "tarefa_anexos", ["tarefa_id"], :name => "index_tarefa_anexos_on_tarefa_id"

  create_table "tarefa_etapas", :force => true do |t|
    t.integer  "codigo"
    t.string   "nome"
    t.text     "descricao"
    t.string   "status"
    t.datetime "inicio"
    t.integer  "tecnico_id"
    t.integer  "tarefa_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "tarefa_etapas", ["tarefa_id"], :name => "index_tarefa_etapas_on_tarefa_id"

  create_table "tarefa_horas", :force => true do |t|
    t.integer  "tecnico_id"
    t.date     "data"
    t.time     "inicio"
    t.time     "fim"
    t.integer  "tarefa_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "tarefa_etapa_id"
  end

  add_index "tarefa_horas", ["tarefa_id"], :name => "index_tarefa_horas_on_tarefa_id"

  create_table "tarefas", :force => true do |t|
    t.text     "solicitacao"
    t.date     "emissao"
    t.date     "fechamento"
    t.date     "entrega"
    t.string   "status"
    t.integer  "cliente_id"
    t.integer  "tecnico_id"
    t.integer  "servico_id"
    t.integer  "usuario_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "projeto_id"
  end

  add_index "tarefas", ["servico_id"], :name => "index_tarefas_on_servico_id"
  add_index "tarefas", ["usuario_id"], :name => "index_tarefas_on_usuario_id"

  create_table "usuarios", :force => true do |t|
    t.string   "nome_completo"
    t.string   "tipo"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "usuarios", ["email"], :name => "index_usuarios_on_email", :unique => true
  add_index "usuarios", ["reset_password_token"], :name => "index_usuarios_on_reset_password_token", :unique => true

  create_table "workflows", :force => true do |t|
    t.date     "data"
    t.integer  "tarefa_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "workflows", ["tarefa_id"], :name => "index_workflows_on_tarefa_id"

end
