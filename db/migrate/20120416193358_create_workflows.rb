class CreateWorkflows < ActiveRecord::Migration
  def change
    create_table :workflows do |t|
      t.date :data
      t.references :tarefa

      t.timestamps
    end
    add_index :workflows, :tarefa_id
  end
end
