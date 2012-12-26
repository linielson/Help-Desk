# encoding: UTF-8
class Tarefa < ActiveRecord::Base
  belongs_to :servico
  belongs_to :usuario
  belongs_to :cliente, class_name: "Pessoa", foreign_key: "cliente_id"
  belongs_to :tecnico, class_name: "Usuario", foreign_key: "tecnico_id"
  belongs_to :projeto, class_name: "Projeto", foreign_key: "projeto_id"
  has_many   :workflows, dependent: :destroy
  has_many   :tarefa_etapas, dependent: :restrict
  has_many   :tarefa_anexos, dependent: :destroy
  has_many   :tarefa_horas,  dependent: :destroy

  validates :solicitacao, :emissao, :servico, :tecnico, :status, presence: true
  validates_associated :usuario, :servico, :cliente, :tecnico
  validates_inclusion_of :status, in: %w(A E C)

  before_validation :validar_data_emissao, :validar_data_entrega, :validar_cliente_e_projeto

  def status_nome
    if status == 'A'
      'Aberta'
    elsif status == 'E'
      'Em andamento'
    else
      'Concluída'
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

  def possui_etapas?
    tarefa_etapas.count > 0
  end

  def esta_atrasada?
    entrega.present? && (entrega.to_date < DateTime.now.to_date)
  end

  def total_horas
    Time.at(total_tempo_trabalhado).gmtime.strftime("%H:%M")
  end

  def total_tempo_trabalhado
    total = 0
    tarefa_horas.each do |hora|
      total += (hora.fim - hora.inicio)
    end
    total
  end
  
  scope :pesquisar_por_id, lambda { |id|
    where("id = :i", i: id)
  }

  scope :pesquisar_por_tecnico, lambda { |id|
    where("tecnico_id = :i", i: id)
  }

  scope :pesquisar_por_cliente, lambda { |id|
    where("cliente_id = :i", i: id)
  }

  scope :pesquisar_por_status, lambda { |status|
    where("status = :s", s: status)
  }

  scope :pesquisar_por_emissao, lambda { |start, finish|
    where("emissao between ? and ? ", start, finish)
  }

  scope :pesquisar_por_entrega, lambda { |start, finish|
    where("entrega between ? and ? ", start, finish)
  }

protected

  def validar_cliente_e_projeto
    if !projeto.present? && !cliente.present?
      errors.add(:projeto_id, 'deve ser selecionado um projeto ou um cliente!')
      errors.add(:cliente_id, 'deve ser selecionado um cliente ou um projeto!')
    end
  end


  def validar_data_emissao
    if emissao > DateTime.now
      errors.add(:emissao, 'não pode ser maior que a data atual!')
    end
  end

  def validar_data_entrega
    if emissao > entrega
      errors.add(:entrega, 'deve ser maior ou igual a data de emissão!')
    end
  end

end