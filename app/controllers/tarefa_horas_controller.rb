# encoding: UTF-8
class TarefaHorasController < ApplicationController

  before_filter :carregar_tecnicos, only: %w(new create edit update)

  def index
    @tarefa = Tarefa.find(params[:tarefa_id])
    @tarefa_horas = @tarefa.tarefa_horas.paginate page: params[:page], per_page: 10
    respond_with @tarefa_horas
  end

  def new
    @tarefa = Tarefa.find(params[:tarefa_id])
    @tarefa_hora = TarefaHora.new
    respond_with @tarefa_hora
  end

  def edit
    @tarefa = Tarefa.find(params[:tarefa_id])
    @tarefa_hora = @tarefa.tarefa_horas.find(params[:id])
  end

  def create
    @tarefa = Tarefa.find(params[:tarefa_id])
    @tarefa_hora = @tarefa.tarefa_horas.build(params[:tarefa_hora])
    flash[:notice] = 'Hora incluída com sucesso!' if @tarefa_hora.save
    respond_with @tarefa_hora, location: tarefa_tarefa_horas_path
  end

  def update
    @tarefa = Tarefa.find(params[:tarefa_id])
    @tarefa_hora = @tarefa.tarefa_horas.find(params[:id])
    flash[:notice] = 'Hora alterada com sucesso!' if @tarefa_hora.update_attributes(params[:tarefa_hora])
    respond_with @tarefa_hora, location: tarefa_tarefa_horas_path
  end

  def destroy
    @tarefa = Tarefa.find(params[:tarefa_id])
    @tarefa_hora = @tarefa.tarefa_horas.find(params[:id])
    @tarefa_hora.destroy
    respond_with @tarefa_hora, location: tarefa_tarefa_horas_path
  end

protected

  def carregar_tecnicos
    @tecnicos = Usuario.find_all_by_tipo "T"
    @etapas = TarefaEtapa.find_all_by_tarefa_id_and_status(Tarefa.find(params[:tarefa_id]), "C")
  end

end