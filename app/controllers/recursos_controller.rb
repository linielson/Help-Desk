# encoding: UTF-8
class RecursosController < ApplicationController

  def index
    @recursos = Recurso.scoped
    @recursos = Recurso.pesquisar(params[:stexto]).paginate page: params[:page], per_page: 10
    respond_with @recursos
  end

  def show
    @recurso = Recurso.find(params[:id])
    respond_with @recurso
  end

  def new
    @recurso = Recurso.new
    respond_with @recurso
  end

  def edit
    @recurso = Recurso.find(params[:id])
  end

  def create
    @recurso = Recurso.new(params[:recurso])
    @recurso.usuario_id = current_usuario.id
    flash[:notice] = 'Recurso incluído com sucesso!' if @recurso.save
    respond_with @recurso, location: recursos_path
  end

  def update
    @recurso = Recurso.find(params[:id])
    @recurso.usuario_id = current_usuario.id
    flash[:notice] = 'Recurso alterado com sucesso!' if @recurso.update_attributes(params[:recurso])
    respond_with @recurso, location: recursos_path
  end

  def destroy
    @recurso = Recurso.find(params[:id])
    @recurso.destroy
    respond_with @recurso, location: recursos_path
  end
  
end