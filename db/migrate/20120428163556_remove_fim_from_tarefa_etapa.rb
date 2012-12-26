class RemoveFimFromTarefaEtapa < ActiveRecord::Migration
  def up
    remove_column :tarefa_etapas, :fim
  end

  def down
    add_column :tarefa_etapas, :fim, :datetime
  end
end
