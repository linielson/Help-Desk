class AddEtapaTarefaToTarefaHora < ActiveRecord::Migration
  def change
    add_column :tarefa_horas, :tarefa_etapa_id, :integer

  end
end
