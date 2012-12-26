class Servico < ActiveRecord::Base
  belongs_to :usuario
  has_many :servico_etapas, dependent: :destroy
  has_many :tarefas, dependent: :restrict

  validates_associated :usuario
  validates :nome, presence: true, uniqueness: true

  def codigo_nome
    "#{id} - #{nome}"
  end
  
  scope :pesquisar_por_id, lambda { |id|
    where("id = :i", i: id)
  }

  scope :pesquisar_por_nome, lambda { |nome|
    where("upper(nome) LIKE upper(:n)", n: "%#{nome}%")
  }

end
