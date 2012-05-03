class CreateTarefaEtapas < ActiveRecord::Migration
  def change
    create_table :tarefa_etapas do |t|
      t.integer :codigo
      t.string :nome
      t.text :descricao
      t.string :status
      t.datetime :inicio
      t.datetime :fim
      t.integer :tecnico_id
      t.references :tarefa

      t.timestamps
    end
    add_index :tarefa_etapas, :tarefa_id
  end
end
