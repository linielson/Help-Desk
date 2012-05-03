class CreateServicoEtapas < ActiveRecord::Migration
  def change
    create_table :servico_etapas do |t|
      t.string :nome
      t.text :descricao
      t.references :servico

      t.timestamps
    end
    add_index :servico_etapas, :servico_id
  end
end
