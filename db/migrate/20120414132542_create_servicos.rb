class CreateServicos < ActiveRecord::Migration
  def change
    create_table :servicos do |t|
      t.string :nome
      t.text :descricao
      t.references :usuario

      t.timestamps
    end
    add_index :servicos, :usuario_id
  end
end
