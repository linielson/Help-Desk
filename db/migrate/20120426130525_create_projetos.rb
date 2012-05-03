class CreateProjetos < ActiveRecord::Migration
  def change
    create_table :projetos do |t|
      t.string :nome
      t.text :descricao
      t.date :inicio
      t.date :fim
      t.date :previsao_fim
      t.string :status
      t.integer :cliente_id
      t.float :gastos_previsto
      t.float :gastos_final
      t.references :usuario

      t.timestamps
    end
    add_index :projetos, :usuario_id
  end
end
