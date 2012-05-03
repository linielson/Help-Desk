class CreateTarefaAnexos < ActiveRecord::Migration
  def change
    create_table :tarefa_anexos do |t|
      t.string :titulo
      t.text :descricao
      t.references :tarefa

      t.timestamps
    end
    add_index :tarefa_anexos, :tarefa_id
  end
end
