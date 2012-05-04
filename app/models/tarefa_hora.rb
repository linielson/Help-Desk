# encoding: UTF-8
class TarefaHora < ActiveRecord::Base
  belongs_to :tarefa
  belongs_to :tecnico, class_name: "Usuario", foreign_key: "tecnico_id"
  belongs_to :etapa, class_name: "TarefaEtapa", foreign_key: "tarefa_etapa_id"

  validates_associated :tarefa, :tecnico, :etapa
  validates :data, :inicio, :fim, :tecnico, :etapa, presence: true

  before_validation :validar_horas

protected

  def validar_horas
    if inicio > fim
      errors.add(:inicio, "deve ser menor que a hora de término!")
    end

    if (inicio + 5.hour) < fim
      errors.add(:fim, ': o intervalo de horas trabalhadas não deve exceder 5 horas!')
    end

    if data < tarefa.emissao
      errors.add(:data, 'deve ser maior ou igual a data de emissão da tarefa!')
    end
  end

end
