class Recurso < ActiveRecord::Base
  belongs_to :usuario
  has_and_belongs_to_many :servico_etapas
  has_and_belongs_to_many :tarefa_etapas

  validates :nome, presence: true, uniqueness: true
  validates_associated :usuario

  scope :pesquisar, lambda { |texto|
    where("upper(nome) LIKE upper(:t) OR upper(observacao) LIKE upper(:t)", t: "%#{texto}%")
  }
end




