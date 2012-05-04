# encoding: UTF-8
class UsuariosController < ApplicationController
  
  def index
    @usuarios = Usuario.order('id ASC').all

    respond_with @usuarios
  end

  def new
    @usuario = Usuario.new
    respond_with @usuario
  end

  def edit
    @usuario = Usuario.find(params[:id])
  end

  def create
    @usuario = Usuario.new(params[:usuario])
    flash[:notice] = 'Usuário criado com sucesso!' if @usuario.save
    respond_with @usuario, location: :usuarios
  end

  def update
    @usuario = Usuario.find(params[:id])
    flash[:notice] = 'Usuário editado com sucesso!' if @usuario.update_attributes(params[:usuario])
    respond_with @usuario, location: :usuarios
  end

  def destroy
    @usuario = Usuario.find(params[:id])
    begin
      @usuario.destroy
    rescue ActiveRecord::DeleteRestrictionError
      flash[:error] = "Atenção, este usuário não pode ser excluído, pois possui dependentes!"
    end
    respond_with @usuario, location: :usuarios
  end

end
