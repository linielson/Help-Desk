class AddProjetoToTarefa < ActiveRecord::Migration
  def change
    add_column :tarefas, :projeto_id, :integer

  end
end
