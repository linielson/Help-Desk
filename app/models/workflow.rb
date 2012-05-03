class Workflow < ActiveRecord::Base
  belongs_to :tarefa

  validates :tarefa, presence: true
  validates_associated :tarefa
end
