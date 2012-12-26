# encoding: UTF-8
class ServicoEtapasController < ApplicationController

  before_filter :carregar_recursos, only: %w(new create edit update)

  def index
    @servico = Servico.find(params[:servico_id])
    @servico_etapas = @servico.servico_etapas.paginate(page: params[:page], per_page: 10).order('id ASC')

    respond_with @servico_etapas
  end

  def show
    @servico = Servico.find(params[:servico_id])
    @servico_etapa = @servico.servico_etapas.find(params[:id])
    respond_with @servico_etapa
  end

  def new
    @servico = Servico.find(params[:servico_id])
    @servico_etapa = ServicoEtapa.new
    respond_with @servico_etapa
  end

  def edit
    @servico = Servico.find(params[:servico_id])
    @servico_etapa = @servico.servico_etapas.find(params[:id])
  end

  def create
    @servico = Servico.find(params[:servico_id])
    @servico_etapa = @servico.servico_etapas.build(params[:servico_etapa])
    params[:servico_etapa][:recurso_ids] ||= []
    flash[:notice] = 'Etapa incluída com sucesso!' if @servico_etapa.save
    respond_with @servico_etapa, location: servico_servico_etapas_path
  end

  def update
    @servico = Servico.find(params[:servico_id])
    @servico_etapa = @servico.servico_etapas.find(params[:id])
    flash[:notice] = 'Etapa alterada com sucesso!' if @servico_etapa.update_attributes(params[:servico_etapa])
    respond_with @servico_etapa, location: servico_servico_etapas_path
  end

  def destroy
    @servico = Servico.find(params[:servico_id])
    @servico_etapa = @servico.servico_etapas.find(params[:id])
    @servico_etapa.destroy
    respond_with @servico_etapa, location: servico_servico_etapas_path
  end

protected

  def carregar_recursos
    @recursos = Recurso.all
  end

end
