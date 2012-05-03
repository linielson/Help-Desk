class CreateUsuarios < ActiveRecord::Migration
  def change
    create_table :usuarios do |t|
      t.string :nome_completo
      t.string :tipo

      t.timestamps
    end
  end
end
