# encoding: UTF-8
class TarefaEtapa < ActiveRecord::Base
  belongs_to :tarefa
  belongs_to :tecnico, class_name: "Usuario", foreign_key: "tecnico_id"
  has_many   :tarefa_horas,  dependent: :restrict
  has_and_belongs_to_many :recursos

  validates_associated :tarefa, :tecnico
  validates :codigo, :nome, :tarefa, :status, :descricao, :tecnico, presence: true
  validates_inclusion_of :status, in: %w(A E C P)

  def codigo_nome
    "#{codigo} - #{nome}"
  end

  def status_nome
    case status
    when 'A'
      'Aberta'
    when 'E'
      'Em andamento'
    when 'C'
      'Concluída'
    else
      'Pausa'
    end
  end

  def aberta?
    status == 'A'
  end

  def em_andamento?
    status == 'E'
  end

  def concluida?
    status == 'C'
  end

  def em_pausa?
    status == 'P'
  end

  def total_horas
    total = 0
    tarefa_horas.each do |hora|
      total += (hora.fim - hora.inicio)
    end
    Time.at(total).gmtime.strftime("%H:%M")
  end

  def data_hora_inicio
    if tarefa_horas.present?
      ("#{tarefa_horas.first.data.strftime("%d/%m/%Y")} #{tarefa_horas.first.inicio.strftime("%H:%M:%S")}").to_time
    end
  end

  def data_hora_fim
    if tarefa_horas.present?
      ("#{tarefa_horas.last.data.strftime("%d/%m/%Y")} #{tarefa_horas.last.fim.strftime("%H:%M:%S")}").to_time
    end
  end
  
end