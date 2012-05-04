# encoding: UTF-8
class TarefasController < ApplicationController

  before_filter :carregar_recursos, only: %w(index new create edit update imprimir)

  def index
    @tarefas = Tarefa.scoped
    @tarefas = Tarefa.pesquisar_por_id(params[:scodigo]) if params[:scodigo].present?
    @tarefas = @tarefas.pesquisar_por_tecnico(params[:stecnico]) if params[:stecnico].present?
    @tarefas = @tarefas.pesquisar_por_cliente(params[:scliente]) if params[:scliente].present?
    @tarefas = @tarefas.pesquisar_por_status(params[:sstatus]) if params[:sstatus].present?

    if params[:emissao_inicio].present? and params[:emissao_fim].present? and
       params[:entrega_inicio].present? and params[:entrega_fim].present?
      if periodo_valido? :emissao_inicio, :emissao_fim
        @tarefas = @tarefas.pesquisar_por_emissao(parametro_para_data(:emissao_inicio), parametro_para_data(:emissao_fim))
      end
      if periodo_valido? :entrega_inicio, :entrega_fim
        @tarefas = @tarefas.pesquisar_por_entrega(parametro_para_data(:entrega_inicio), parametro_para_data(:entrega_fim))
      end
    end

    @tarefas = @tarefas.paginate(page: params[:page], per_page: 10).order('id DESC')

    respond_with @tarefas
  end

  def show
    @tarefa = Tarefa.find(params[:id])
    @pixels = numero_pixels_para_completar_workflow @tarefa
    @tamanho_total = tamanho_total_workflow @tarefa
    respond_with @tarefa
  end

  def new
    @tarefa = Tarefa.new
    respond_with @tarefa
  end

  def edit
    @tarefa = Tarefa.find(params[:id])
  end

  def create
    @tarefa = Tarefa.new(params[:tarefa])
    @tarefa.usuario_id = current_usuario.id
    @tarefa.tecnico_id = current_usuario.id
    @tarefa.status = "A"

    copiar_etapas_do_servico @tarefa if @tarefa.save

    configurar_cliente_e_projeto @tarefa
    flash[:notice] = "Tarefa #{@tarefa.id} incluída com sucesso!" if @tarefa.save
    respond_with @tarefa, location: tarefas_path
  end

  def update
    @tarefa = Tarefa.find(params[:id])
    @tarefa.usuario_id = current_usuario.id

    copiar_etapas_do_servico @tarefa if @tarefa.update_attributes(params[:tarefa])

    if @tarefa.update_attributes(params[:tarefa])
      configurar_cliente_e_projeto @tarefa
      @tarefa.save!
      flash[:notice] = "Tarefa #{@tarefa.id} alterada com sucesso!"
    end
    
    respond_with @tarefa, location: tarefas_path
  end

  def destroy
    @tarefa = Tarefa.find(params[:id])
    if @tarefa.tecnico.id == current_usuario.id
      begin
        @tarefa.destroy
      rescue ActiveRecord::DeleteRestrictionError
        flash[:error] = "Atenção, esta etapa não pode ser excluído pois possui etapas!"
      end
    else
      flash[:error] = "Atenção, você só pode excluir as suas tarefas!"
    end
    respond_with @tarefa, location: tarefas_path
  end

  def iniciar
    @tarefa = Tarefa.find(params[:tarefa_id])
    if @tarefa.tarefa_etapas.present?
      if !@tarefa.projeto.present? or @tarefa.projeto.em_andamento?
        redirect_to tarefa_add_tarefa_path
      else
        flash[:error] = "Atenção, antes de iniciar você deve dar inicio ao projeto (#{@tarefa.projeto.codigo_nome}) desta tarefa!"
        redirect_to tarefas_path
      end
    else
      flash[:error] = "Atenção, a tarefa #{@tarefa.id} não possui etapas. Inclua pelo menos uma etapa antes prosseguir!"
      redirect_to tarefas_path
    end
  end

  def impressao
    redirect_to imprimir_path
  end

  def preparar_impressao_html
    @tarefas = Tarefa.scoped
    @tarefas = Tarefa.pesquisar_por_id(params[:scodigo]) if params[:scodigo].present?
    @tarefas = @tarefas.pesquisar_por_tecnico(params[:stecnico]) if params[:stecnico].present?
    @tarefas = @tarefas.pesquisar_por_cliente(params[:scliente]) if params[:scliente].present?
    @tarefas = @tarefas.pesquisar_por_status(params[:sstatus]) if params[:sstatus].present?

    if params[:emissao_inicio].present? and params[:emissao_fim].present? and
       params[:entrega_inicio].present? and params[:entrega_fim].present?
      if periodo_valido? :emissao_inicio, :emissao_fim
        @tarefas = @tarefas.pesquisar_por_emissao(parametro_para_data(:emissao_inicio), parametro_para_data(:emissao_fim))
      end
      if periodo_valido? :entrega_inicio, :entrega_fim
        @tarefas = @tarefas.pesquisar_por_entrega(parametro_para_data(:entrega_inicio), parametro_para_data(:entrega_fim))
      end
    end

    @tarefas = @tarefas.paginate(page: params[:page], per_page: 15).order('id ASC')

    render action: "impressao_html"
  end

protected

  def carregar_recursos
    @clientes = Pessoa.order('id ASC').all
    @tecnicos = Usuario.order('id ASC').all
    @servicos = Servico.order('id ASC').all
    @projetos = Projeto.order('id ASC').find(:all, conditions: "status <> 'C'")
  end

  def copiar_etapas_do_servico tarefa
    tarefa.servico.servico_etapas.order('id ASC').each do |etapa|

      @tarefa_etapa = tarefa.tarefa_etapas.create(
        codigo: tarefa.tarefa_etapas.maximum('codigo').to_i + 1,
        nome: etapa.nome,
        descricao: etapa.descricao,
        status: "A",
        tecnico_id: tarefa.tecnico_id
      )

      etapa.recursos.each do |recurso|
        @tarefa_etapa.recursos << recurso
      end
    end unless tarefa.tarefa_etapas.present?
  end

  def parametro_para_data param
    "#{params[param]['data(1i)']}-#{params[param]['data(2i)']}-#{params[param]['data(3i)']}".to_date
  end

  def periodo_valido? data_inicio, data_fim
    params[data_inicio]['data(1i)'].present? and params[data_inicio]['data(2i)'].present? and
    params[data_inicio]['data(3i)'].present? and params[data_fim]['data(1i)'].present? and
    params[data_fim]['data(2i)'].present? and params[data_fim]['data(3i)'].present?
  end

  def numero_pixels_para_completar_workflow tarefa
    numero_etapas = tarefa.tarefa_etapas.size
    if numero_etapas > 1
      total_pixels = (9 - numero_etapas) * 104
      (total_pixels / (numero_etapas - 1)).to_i
    else
      0
    end
  end

  def tamanho_total_workflow tarefa
    if tarefa.tarefa_etapas.size > 9
      tarefa.tarefa_etapas.size * 104
    else
      1024
    end
  end

  def configurar_cliente_e_projeto tarefa
    if tarefa.projeto.present?
      tarefa.cliente = tarefa.projeto.cliente
    end
  end

end
