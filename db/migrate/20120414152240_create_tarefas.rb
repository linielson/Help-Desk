class CreateTarefas < ActiveRecord::Migration
  def change
    create_table :tarefas do |t|
      t.text :solicitacao
      t.date :emissao
      t.date :fechamento
      t.date :entrega
      t.string :status
      t.integer :cliente_id
      t.integer :tecnico_id
      t.references :servico
      t.references :usuario

      t.timestamps
    end
    add_index :tarefas, :servico_id
    add_index :tarefas, :usuario_id
  end
end
