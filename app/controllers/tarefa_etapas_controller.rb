# encoding: UTF-8
class TarefaEtapasController < ApplicationController

  before_filter :carregar_recursos, only: %w(new create edit update)

  def index
    @tarefa = Tarefa.find(params[:tarefa_id])
    @tarefa_etapas = @tarefa.tarefa_etapas.paginate page: params[:page], per_page: 10
    respond_with @tarefa_etapas
  end

  def show
    @tarefa = Tarefa.find(params[:tarefa_id])
    @tarefa_etapa = @tarefa.tarefa_etapas.find(params[:id])
    respond_with @tarefa_etapa
  end

  def new
    @tarefa = Tarefa.find(params[:tarefa_id])
    @tarefa_etapa = TarefaEtapa.new
    @tarefa_etapa.codigo = @tarefa.tarefa_etapas.maximum('codigo').to_i + 1
    respond_with @tarefa_etapa
  end

  def edit
    @tarefa = Tarefa.find(params[:tarefa_id])
    @tarefa_etapa = @tarefa.tarefa_etapas.find(params[:id])
  end

  def create
    @tarefa = Tarefa.find(params[:tarefa_id])
    @tarefa_etapa = @tarefa.tarefa_etapas.build(params[:tarefa_etapa])
    @tarefa_etapa.status = "A"
    @tarefa_etapa.codigo = @tarefa.tarefa_etapas.maximum('codigo').to_i + 1
    flash[:notice] = 'Etapa incluída com sucesso!' if @tarefa_etapa.save
    respond_with @tarefa_etapa, location: tarefa_tarefa_etapas_path
  end

  def update
    @tarefa = Tarefa.find(params[:tarefa_id])
    @tarefa_etapa = @tarefa.tarefa_etapas.find(params[:id])
    params[:tarefa_etapa][:recurso_ids] ||= []
    flash[:notice] = 'Etapa alterada com sucesso!' if @tarefa_etapa.update_attributes(params[:tarefa_etapa])
    respond_with @tarefa_etapa, location: tarefa_tarefa_etapas_path
  end

  def destroy
    @tarefa = Tarefa.find(params[:tarefa_id])
    @tarefa_etapa = @tarefa.tarefa_etapas.find(params[:id])
    begin
      @tarefa_etapa.destroy
    rescue ActiveRecord::DeleteRestrictionError
      flash[:error] = "Atenção, esta etapa não pode ser excluído pois possui horas trabalhadas!"
    end
    respond_with @tarefa_etapa, location: tarefa_tarefa_etapas_path
  end

  def iniciar
    @tarefa = Tarefa.find(params[:tarefa_id])
    @tarefa_etapa = @tarefa.tarefa_etapas.find(params[:tarefa_etapa_id])
    @tarefa_etapa.inicio = DateTime.now
    @tarefa_etapa.status = "E"
    @tarefa_etapa.save!

    redirect_to tarefa_tarefa_etapas_path
  end

  def pausar
    @tarefa = Tarefa.find(params[:tarefa_id])
    @tarefa_etapa = @tarefa.tarefa_etapas.find(params[:tarefa_etapa_id])

    incluir_as_horas_trabalhadas_na_etapa @tarefa_etapa

    @tarefa_etapa.status = "P"
    @tarefa_etapa.inicio = nil
    @tarefa_etapa.save!

    redirect_to tarefa_tarefa_etapas_path
  end

  def concluir
    @tarefa = Tarefa.find(params[:tarefa_id])
    @tarefa_etapa = @tarefa.tarefa_etapas.find(params[:tarefa_etapa_id])
    if @tarefa_etapa.em_andamento?
      incluir_as_horas_trabalhadas_na_etapa @tarefa_etapa
    end
    @tarefa_etapa.status = "C"
    @tarefa_etapa.save!

    redirect_to tarefa_etapa_concluida_path
  end

protected

  def carregar_recursos
    @tecnicos = Usuario.find_all_by_tipo "T"
    @recursos = Recurso.all
  end

  def incluir_as_horas_trabalhadas_na_etapa tarefa_etapa
    data_fim = DateTime.now
    tarefa_etapa.inicio.to_date.upto(data_fim.to_date) do |data|
      if tarefa_etapa.inicio.strftime("%H:%M:%S") <= formatar_hora("17:00")
        if not (data.saturday? or data.sunday?)
          if tarefa_etapa.inicio.strftime("%d/%m/%Y") == data.strftime("%d/%m/%Y")
            inicio = tarefa_etapa.inicio
          else
            inicio = Time.parse("#{data} 08:00").utc
          end

          if data_fim.strftime("%d/%m/%Y") == data.strftime("%d/%m/%Y")
            fim = data_fim
          else
            fim = Time.parse("#{data} 17:00").utc
          end

          salvar_horas_do_dia data, inicio, fim, tarefa_etapa
        end
      end
    end
  end

  def salvar_horas_do_dia data, inicio, fim, tarefa_etapa
    if inicio.strftime("%H:%M:%S") < formatar_hora("12:00")
      if fim.strftime("%H:%M:%S") <= formatar_hora("13:00")
        salvar_horas data, inicio, fim, tarefa_etapa
      else
        salvar_horas data, inicio, Time.parse("#{data} 12:00").utc, tarefa_etapa
        salvar_horas_do_dia data, Time.parse("#{data} 13:00").utc, fim, tarefa_etapa
      end
    else
      if fim.strftime("%H:%M:%S") > formatar_hora("18:00")
        termino = Time.parse("#{data} 17:00").utc
      else
        termino = fim
      end
      salvar_horas data, inicio, termino, tarefa_etapa
    end
  end

  def salvar_horas data, inicio, fim, tarefa_etapa
    tarefa_etapa.tarefa.tarefa_horas.create(
      data: data,
      inicio: inicio,
      fim: fim,
      tecnico: tarefa_etapa.tecnico,
      etapa: tarefa_etapa
    ).save!
  end

  def formatar_hora hora_string
    Time.parse(hora_string).strftime("%H:%M:%S")
  end

end
