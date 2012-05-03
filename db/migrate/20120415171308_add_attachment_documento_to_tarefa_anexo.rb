class AddAttachmentDocumentoToTarefaAnexo < ActiveRecord::Migration
  def self.up
    add_column :tarefa_anexos, :documento_file_name, :string
    add_column :tarefa_anexos, :documento_content_type, :string
    add_column :tarefa_anexos, :documento_file_size, :integer
    add_column :tarefa_anexos, :documento_updated_at, :datetime
  end

  def self.down
    remove_column :tarefa_anexos, :documento_file_name
    remove_column :tarefa_anexos, :documento_content_type
    remove_column :tarefa_anexos, :documento_file_size
    remove_column :tarefa_anexos, :documento_updated_at
  end
end
