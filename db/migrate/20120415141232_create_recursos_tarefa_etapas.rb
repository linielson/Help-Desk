class CreateRecursosTarefaEtapas < ActiveRecord::Migration
  def up
    create_table "recursos_tarefa_etapas", :id => false, :force => true do |t|
      t.integer "recurso_id",      :null => false
      t.integer "tarefa_etapa_id", :null => false
    end
  end

  def down
    drop_table "recursos_tarefa_etapas"
  end
end
