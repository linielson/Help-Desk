# encoding: UTF-8
class TarefaAnexosController < ApplicationController

  def index
    @tarefa = Tarefa.find(params[:tarefa_id])
    @tarefa_anexos = @tarefa.tarefa_anexos.paginate page: params[:page], per_page: 10
    respond_with @tarefa_anexos
  end

  def new
    @tarefa = Tarefa.find(params[:tarefa_id])
    @tarefa_anexo = TarefaAnexo.new
    respond_with @tarefa_anexo
  end

  def edit
    @tarefa = Tarefa.find(params[:tarefa_id])
    @tarefa_anexo = @tarefa.tarefa_anexos.find(params[:id])
  end

  def create
    @tarefa = Tarefa.find(params[:tarefa_id])
    @tarefa_anexo = @tarefa.tarefa_anexos.build(params[:tarefa_anexo])
    flash[:notice] = 'Anexo incluído com sucesso!' if @tarefa_anexo.save
    respond_with @tarefa_anexo, location: tarefa_tarefa_anexos_path
  end

  def update
    @tarefa = Tarefa.find(params[:tarefa_id])
    @tarefa_anexo = @tarefa.tarefa_anexos.find(params[:id])
    flash[:notice] = 'Anexo alterado com sucesso!' if @tarefa_anexo.update_attributes(params[:tarefa_anexo])
    respond_with @tarefa_anexo, location: tarefa_tarefa_anexos_path
  end

  def destroy
    @tarefa = Tarefa.find(params[:tarefa_id])
    @tarefa_anexo = @tarefa.tarefa_anexos.find(params[:id])
    @tarefa_anexo.destroy
    respond_with @tarefa_anexo, location: tarefa_tarefa_anexos_path
  end

end
