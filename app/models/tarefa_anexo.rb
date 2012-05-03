class TarefaAnexo < ActiveRecord::Base
  belongs_to :tarefa

  validates :titulo, presence: true
  has_attached_file :documento
  validates_attachment_presence :documento
  validates_attachment_size :documento, less_than: 250.megabyte
end
