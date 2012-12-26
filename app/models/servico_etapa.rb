class ServicoEtapa < ActiveRecord::Base
  belongs_to :servico
  has_and_belongs_to_many :recursos

  validates_associated :servico
  validates :nome, :servico, :descricao, presence: true
end
