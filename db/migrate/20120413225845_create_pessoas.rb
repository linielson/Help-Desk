class CreatePessoas < ActiveRecord::Migration
  def change
    create_table :pessoas do |t|
      t.string :nome
      t.string :email
      t.string :telefone
      t.references :usuario

      t.timestamps
    end
    add_index :pessoas, :usuario_id
  end
end
