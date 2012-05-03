# encoding: UTF-8
class PessoasController < ApplicationController

  def index
    @pessoas = Pessoa.scoped
    @pessoas = Pessoa.pesquisar_por_id(params[:scodigo]) if params[:scodigo].present?
    @pessoas = @pessoas.pesquisar_por_nome(params[:snome]).paginate page: params[:page], per_page: 10
    respond_with @pessoas
  end

  def show
    @pessoa = Pessoa.find(params[:id])
    respond_with @pessoa
  end

  def new
    @pessoa = Pessoa.new
    respond_with @pessoa
  end

  def edit
    @pessoa = Pessoa.find(params[:id])
  end

  def create
    @pessoa = Pessoa.new(params[:pessoa])
    @pessoa.usuario_id = current_usuario.id
    flash[:notice] = 'Cliente incluído com sucesso!' if @pessoa.save
    respond_with @pessoa, location: pessoas_path
  end

  def update
    @pessoa = Pessoa.find(params[:id])
    @pessoa.usuario_id = current_usuario.id
    flash[:notice] = 'Cliente alterado com sucesso!' if @pessoa.update_attributes(params[:pessoa])
    respond_with @pessoa, location: pessoas_path
  end

  def destroy
    @pessoa = Pessoa.find(params[:id])
    begin
      @pessoa.destroy
    rescue ActiveRecord::DeleteRestrictionError
      flash[:error] = "Atenção, este cliente não pode ser excluído pois possui depententes!"
    end

    respond_with @pessoa, location: pessoas_path
  end

end
