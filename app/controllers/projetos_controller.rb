# encoding: UTF-8
class ProjetosController < ApplicationController

  before_filter :carregar_clientes, only: %w(index painel new create edit update)
 
  def index
    @projetos = Projeto.scoped
    @projetos = Projeto.pesquisar_por_nome(params[:snome])
    @projetos = Projeto.pesquisar_por_cliente(params[:scliente]) if params[:scliente].present?
    @projetos = Projeto.pesquisar_por_status(params[:sstatus]) if params[:sstatus].present?
    @projetos = @projetos.paginate(page: params[:page], per_page: 10).order('id DESC')

    respond_with @projetos
  end

  def show
    @projeto = Projeto.find(params[:id])
    respond_with @projeto
  end

  def new
    @projeto = Projeto.new
    respond_with @projeto
  end

  def edit
    @projeto = Projeto.find(params[:id])
  end

  def create
    @projeto = Projeto.new(params[:projeto])
    @projeto.usuario_id = current_usuario.id
    @projeto.status = "A"
    flash[:notice] = 'Projeto incluído com sucesso!' if @projeto.save
    respond_with @projeto, location: projetos_path
  end

  def update
    @projeto = Projeto.find(params[:id])
    @projeto.usuario_id = current_usuario.id
    flash[:notice] = 'Projeto alterado com sucesso!' if @projeto.update_attributes(params[:projeto])
    respond_with @projeto, location: projetos_path
  end

  def destroy
    @projeto = Projeto.find(params[:id])
    begin
      @projeto.destroy
    rescue ActiveRecord::DeleteRestrictionError
      flash[:error] = "Atenção, este projeto não pode ser excluído pois existem tarefas dependentes!"
    end
    respond_with @projeto, location: projetos_path
  end

  def iniciar
    @projeto = Projeto.find(params[:projeto_id])
    @projeto.inicio = DateTime.now
    @projeto.status = "E"
    @projeto.save!

    redirect_to projetos_path
  end

  def concluir
    @projeto = Projeto.find(params[:projeto_id])

    if possui_tarefas? @projeto
      if todas_as_tarefas_estao_concluidas? @projeto
        @projeto.fim = DateTime.now
        @projeto.status = "C"
        @projeto.save!
      else
        flash[:error] = "Atenção, este projeto possue tarefas abertas ou em andamento!"
      end
    else
      flash[:error] = "Atenção, este projeto não possui tarefas!"
    end

    redirect_to projetos_path
  end

  def painel
    @projetos = Projeto.scoped
    @projetos = Projeto.pesquisar_por_nome(params[:snome])
    @projetos = Projeto.pesquisar_por_cliente(params[:scliente]) if params[:scliente].present?
    @projetos = Projeto.pesquisar_por_status(params[:sstatus]) if params[:sstatus].present?
    @projetos = @projetos.paginate(page: params[:page], per_page: 10).order('id DESC')
  end

protected

  def carregar_clientes
    @clientes = Pessoa.all
  end

  def possui_tarefas? projeto
    projeto.tarefas.size > 0
  end

  def todas_as_tarefas_estao_concluidas? projeto
    numero_de_tarefas_abertas_e_em_andamento(projeto) == 0
  end

  def numero_de_tarefas_abertas_e_em_andamento projeto
    projeto.tarefas.count('id', conditions: "status <> 'C'")
  end

end
