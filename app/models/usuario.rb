# encoding: UTF-8
class Usuario < ActiveRecord::Base
  has_many :pessoas, dependent: :restrict
  has_many :recursos, dependent: :restrict
  has_many :servicos, dependent: :restrict
  has_many :tarefas, dependent: :restrict
  has_many :tarefa_tecnicos, class_name: 'Tarefa', foreign_key: "tecnico_id", dependent: :restrict
  has_many :tarefa_etapas, class_name: 'TarefaEtapa', foreign_key: "tecnico_id", dependent: :restrict
  has_many :tarefa_horas, class_name: 'TarefaHora', foreign_key: "tecnico_id", dependent: :restrict
  has_many :projetos, dependent: :restrict
  
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, 
    :validatable, :token_authenticatable 

  attr_accessible :email, :password, :password_confirmation, :remember_me,
    :nome_completo, :tipo

  validates :nome_completo, :tipo, presence: true
  validates_inclusion_of :tipo, in: %w(A T G)

  def codigo_nome
    "#{id} - #{nome_completo}"
  end

  def tipo_usuario
    if tipo == 'T'
      "Técnico"
    elsif tipo == "A"
      "Administrador"
    else
      "Gerente"
    end
  end

  def pode_acessar_relatorios_e_projetos?
    administrador? or gerente?
  end

  def pode_acessar_usuarios?
    administrador?
  end

protected

  def administrador?
    tipo == "A"
  end

  def gerente?
    tipo == "G"
  end

end