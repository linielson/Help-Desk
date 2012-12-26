# encoding: UTF-8
class Pessoa < ActiveRecord::Base
  belongs_to :usuario
  has_many :tarefas, class_name: 'Tarefa', foreign_key: 'cliente_id', dependent: :restrict
  has_many :projetos, class_name: 'Projeto', foreign_key: 'cliente_id', dependent: :restrict

  validates_associated :usuario
  validates :nome, presence: true
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

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