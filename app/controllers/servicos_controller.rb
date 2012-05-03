# encoding: UTF-8
class ServicosController < ApplicationController

  def index
    @servicos = Servico.scoped
    @servicos = Servico.pesquisar_por_id(params[:scodigo]) if params[:scodigo].present?
    @servicos = @servicos.pesquisar_por_nome(params[:snome]).paginate page: params[:page], per_page: 10
    respond_with @servicos
  end

  def show
    @servico = Servico.find(params[:id])
    respond_with @servico
  end

  def new
    @servico = Servico.new
    respond_with @servico
  end

  def edit
    @servico = Servico.find(params[:id])
  end

  def create
    @servico = Servico.new(params[:servico])
    @servico.usuario_id = current_usuario.id
    flash[:notice] = "Serviço #{@servico.id} incluído com sucesso!" if @servico.save
    respond_with @servico, location: servicos_path
  end

  def update
    @servico = Servico.find(params[:id])
    @servico.usuario_id = current_usuario.id
    flash[:notice] = "Serviço #{@servico.id} alterado com sucesso!" if @servico.update_attributes(params[:servico])
    respond_with @servico, location: servicos_path
  end

  def destroy
    @servico = Servico.find(params[:id])
    begin
      @servico.destroy
    rescue ActiveRecord::DeleteRestrictionError
      flash[:error] = "Atenção, este serviço não pode ser excluído, pois existem tarefas dependentes!"
    end
    respond_with @servico, location: servicos_path
  end

end
