class CreateTarefaHoras < ActiveRecord::Migration
  def change
    create_table :tarefa_horas do |t|
      t.integer :tecnico_id
      t.date :data
      t.time :inicio
      t.time :fim
      t.references :tarefa

      t.timestamps
    end
    add_index :tarefa_horas, :tarefa_id
  end
end
