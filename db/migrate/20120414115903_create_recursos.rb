class CreateRecursos < ActiveRecord::Migration
  def change
    create_table :recursos do |t|
      t.string :nome
      t.text :observacao
      t.references :usuario

      t.timestamps
    end
    add_index :recursos, :usuario_id
  end
end
