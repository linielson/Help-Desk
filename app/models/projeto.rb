# encoding: UTF-8
class Projeto < ActiveRecord::Base
  belongs_to :usuario
  belongs_to :cliente, class_name: "Pessoa", foreign_key: "cliente_id"
  has_many :tarefas, dependent: :restrict

  validates :nome, :previsao_fim, :status, :cliente, :descricao, presence: true
  validates_associated :usuario, :cliente
  validates_inclusion_of :status, in: %w(A E C)

  def codigo_nome
    "#{id} - #{nome}"
  end

  def status_nome
    if status == 'A'
      'Aberta'
    elsif status == 'E'
      'Em andamento'
    else
      'Concluída'
    end
  end

  def aberto?
    status == 'A'
  end

  def em_andamento?
    status == 'E'
  end

  def concluido?
    status == 'C'
  end

  def total_horas
    Time.at(total_tempo_trabalhado).gmtime.strftime("%H:%M")
  end

  def total_tempo_trabalhado
    total = 0
    tarefas.each do |tarefa|
      total += tarefa.total_tempo_trabalhado
    end
    total
  end

  scope :pesquisar_por_nome, lambda { |nome|
    where("upper(nome) LIKE upper(:n)", n: "%#{nome}%")
  }

  scope :pesquisar_por_cliente, lambda { |id|
    where("cliente_id = :i", i: id)
  }

  scope :pesquisar_por_status, lambda { |status|
    where("status = :s", s: status)
  }

end
