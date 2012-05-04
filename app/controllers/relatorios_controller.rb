# encoding: UTF-8 
class RelatoriosController < ApplicationController

  before_filter :carregar_recursos, only: %w(index_01 index_02 index_03 index_04 index_05 index_06)
  
  def gerar
    case params[:relatorio]
    when "01"
      redirect_to index_01_path
    when "02"
      redirect_to index_02_path
    when "03"
      redirect_to index_03_path
    when "04"
      redirect_to index_04_path
    when "05"
      redirect_to index_05_path
    when "06"
      redirect_to index_06_path
    end
  end

  def executar_01
    @servico_nome = nome_do_servico params[:servico]
    @cliente_nome = nome_do_cliente params[:cliente]
    @tecnico_nome = nome_do_tecnico params[:tecnico]
    @data_inicio = filtrar_pelo_date :inicio
    @data_fim = @data_inicio + 1.month

    where_servico = filtrar_pelo_servico params[:servico]
    where_cliente = filtrar_pelo_cliente params[:cliente]
    where_tecnico = params[:tecnico] == "" ? "tipo = 'T'" : "id = #{params[:tecnico]}"

    tecnicos = Usuario.all(conditions: ["#{where_tecnico}"])

    @atendimentos = []
    dados = []
    legenda = []
    valor_maximo = 0
    
    tecnicos.each do |tecnico|
      nome_do_tecnico = "#{tecnico.id}-#{Usuario.find(tecnico.id).nome_completo}"

      no_periodo   = numero_de_etapas_num_periodo_por_tecnico(tecnico.id, where_cliente, where_servico, @data_inicio, @data_fim)
      mes_anterior = numero_de_etapas_num_periodo_por_tecnico(tecnico.id, where_cliente, where_servico, @data_inicio-1.month, @data_fim-1.month-1.day)
      ano_anterior = numero_de_etapas_num_periodo_por_tecnico(tecnico.id, where_cliente, where_servico, @data_inicio-1.year, @data_fim-1.year)

      legenda += [remover_acentos(nome_do_tecnico)]

      dados << [no_periodo, mes_anterior, ano_anterior]
      
      @atendimentos << [nome_do_tecnico, no_periodo, mes_anterior, ano_anterior]

      valor_maximo = maior_valor(valor_maximo, no_periodo, mes_anterior, ano_anterior)
    end

    @grafico = relatorio_grafico dados, legenda, valor_maximo
    
    render action: "saida_01"
  end

  def executar_02
    @servico_nome = nome_do_servico params[:servico]
    @cliente_nome = nome_do_cliente params[:cliente]
    @tecnico_nome = nome_do_tecnico params[:tecnico]
    @data_inicio = filtrar_pelo_date :inicio
    @data_fim = @data_inicio + 1.month

    where_cliente = filtrar_pelo_cliente params[:cliente]
    where_tecnico = filtrar_pelo_tecnico params[:tecnico]
    where_servico = params[:servico] == "" ? "" : "id = #{params[:servico]}"

    servicos = Servico.all(conditions: ["#{where_servico}"])

    @tarefas = []
    dados = []
    legenda = []
    valor_maximo = 0
    
    servicos.each do |servico|
      nome_do_servico = "#{servico.id}-#{Servico.find(servico.id).nome}"

      no_periodo   = numero_de_tarefas_num_periodo_por_servico(servico.id, where_cliente, where_tecnico, @data_inicio, @data_fim)
      mes_anterior = numero_de_tarefas_num_periodo_por_servico(servico.id, where_cliente, where_tecnico, @data_inicio-1.month, @data_fim-1.month-1.day)
      ano_anterior = numero_de_tarefas_num_periodo_por_servico(servico.id, where_cliente, where_tecnico, @data_inicio-1.year, @data_fim-1.year)

      legenda += [remover_acentos(nome_do_servico)]
      dados << [no_periodo, mes_anterior, ano_anterior]

      @tarefas << [nome_do_servico, no_periodo, mes_anterior, ano_anterior]

      valor_maximo = maior_valor(valor_maximo, no_periodo, mes_anterior, ano_anterior)
    end

    @grafico = relatorio_grafico dados, legenda, valor_maximo

    render action: "saida_02"
  end

  def executar_03
    @servico_nome = nome_do_servico params[:servico]
    @cliente_nome = nome_do_cliente params[:cliente]
    @tecnico_nome = nome_do_tecnico params[:tecnico]
    @data_inicio = filtrar_pelo_date :inicio
    @data_fim = @data_inicio + 1.month

    where_servico = filtrar_pelo_servico params[:servico]
    where_tecnico = filtrar_pelo_tecnico params[:tecnico]
    where_cliente = params[:cliente] == "" ? "" : "id = #{params[:cliente]}"

    clientes = Pessoa.all(conditions: ["#{where_cliente}"])

    @tarefas = []
    dados = []
    legenda = []
    valor_maximo = 0

    clientes.each do |cliente|
      nome_do_cliente = "#{cliente.id}-#{Pessoa.find(cliente.id).nome}"
      
      no_periodo   = numero_de_tarefas_num_periodo_por_cliente(cliente.id, where_tecnico, where_servico, @data_inicio, @data_fim)
      mes_anterior = numero_de_tarefas_num_periodo_por_cliente(cliente.id, where_tecnico, where_servico, @data_inicio-1.month, @data_fim-1.month-1.day)
      ano_anterior = numero_de_tarefas_num_periodo_por_cliente(cliente.id, where_tecnico, where_servico, @data_inicio-1.year, @data_fim-1.year)

      legenda += [remover_acentos(nome_do_cliente)]
      dados << [no_periodo, mes_anterior, ano_anterior]

      @tarefas << [nome_do_cliente, no_periodo, mes_anterior, ano_anterior]

      valor_maximo = maior_valor(valor_maximo, no_periodo, mes_anterior, ano_anterior)
    end

    @grafico = relatorio_grafico dados, legenda, valor_maximo

    render action: "saida_03"
  end

  def executar_04
    @servico_nome = nome_do_servico params[:servico]
    @cliente_nome = nome_do_cliente params[:cliente]
    @tecnico_nome = nome_do_tecnico params[:tecnico]
    @data_inicio = filtrar_pelo_date :inicio
    @data_fim = filtrar_pelo_date :fim

    where_servico = filtrar_pelo_servico params[:servico]
    where_cliente = filtrar_pelo_cliente params[:cliente]
    where_tecnico = params[:tecnico] == "" ? "AND tecnico_id IN (#{todos_os_tecnicos})" : "AND tecnico_id = #{params[:tecnico]}"

    tarefas = Tarefa.all(
      conditions: ["emissao between ? and ? #{where_servico} #{where_cliente}",
        @data_inicio, @data_fim]
    )

    @etapas = TarefaEtapa.all(
      select: "codigo, tarefa_id, tecnico_id",
      conditions: ["tarefa_id IN (?) #{where_tecnico} AND status <> 'C'", tarefas],
      order: "tecnico_id, tarefa_id, codigo"
    )
    render action: "saida_04"
  end

  def executar_05
    @servico_nome = nome_do_servico params[:servico]
    @cliente_nome = nome_do_cliente params[:cliente]
    @tecnico_nome = nome_do_tecnico params[:tecnico]

    where_servico = filtrar_pelo_servico params[:servico]
    where_cliente = filtrar_pelo_cliente params[:cliente]
    where_tecnico = filtrar_pelo_tecnico params[:tecnico]
    where_status = "AND status <> 'C'"

    tarefas = Tarefa.all(
      conditions: ["entrega <= ? #{where_status} #{where_servico} #{where_cliente}",
        DateTime.now]
    )

    @etapas = TarefaEtapa.all(
      conditions: ["tarefa_id IN (?) #{where_tecnico} #{where_status}", tarefas]
    )

    render action: "saida_05"
  end
  
  def executar_06
    @servico_nome = nome_do_servico params[:servico]
    @cliente_nome = nome_do_cliente params[:cliente]
    @tecnico_nome = nome_do_tecnico params[:tecnico]
    @data_inicio = filtrar_pelo_date :inicio
    @data_fim = filtrar_pelo_date :fim

    where_servico = filtrar_pelo_servico params[:servico]
    where_cliente = filtrar_pelo_cliente params[:cliente]
    where_tecnico = filtrar_pelo_tecnico params[:tecnico]
    where_status = params[:status] == "" ? "" : "AND status = '#{params[:status]}'"

    tarefas = Tarefa.all(
      conditions: ["emissao between ? and ? #{where_servico} #{where_cliente}",
        @data_inicio, @data_fim]
    )

    @etapas = TarefaEtapa.order('tarefa_id, id').all(
      conditions: ["tarefa_id IN (?) #{where_tecnico} #{where_status}", tarefas]
    )
    
    render action: "saida_06"
  end

  protected

  def carregar_recursos
    @clientes = Pessoa.all
    @tecnicos = Usuario.find_all_by_tipo "T"
    @responsaveis = Usuario.all
    @servicos = Servico.all
  end

  def nome_do_servico servico
    servico == "" ? "Todos" : Servico.find(servico).nome
  end

  def nome_do_cliente cliente
    cliente == "" ? "Todos" : Pessoa.find(cliente).nome
  end

  def nome_do_tecnico tecnico
    tecnico == "" ? "Todos" : Usuario.find(tecnico).nome_completo
  end

  def filtrar_pelo_date data
    ("#{params[data]['data(1i)']}-#{params[data]['data(2i)']}-#{params[data]['data(3i)']}").to_date
  end

  def filtrar_pelo_servico servico
    servico == "" ? "" : "AND servico_id = #{servico}"
  end

  def filtrar_pelo_cliente cliente
    cliente == "" ? "" : "AND cliente_id = #{cliente}"
  end

  def filtrar_pelo_tecnico tecnico
    tecnico == "" ? "" : "AND tecnico_id = #{tecnico}"
  end

  def numero_de_etapas_num_periodo_por_tecnico tecnico_id, where_cliente, where_servico, data_inicio, data_fim
    tarefas = Tarefa.all(
      conditions: ["emissao between ? and ? #{where_servico} #{where_cliente}",
        data_inicio, data_fim]
    )

    TarefaEtapa.count(conditions: ["tarefa_id IN (?) AND tecnico_id = #{tecnico_id}", tarefas])
  end

  def numero_de_tarefas_num_periodo_por_servico servico_id, where_cliente, where_tecnico, data_inicio, data_fim
    Tarefa.count(
      conditions: ["emissao between ? and ? AND servico_id = #{servico_id} #{where_tecnico} #{where_cliente}",
        data_inicio, data_fim]
    )
  end

  def numero_de_tarefas_num_periodo_por_cliente cliente_id, where_tecnico, where_servico, data_inicio, data_fim
    Tarefa.count(
      conditions: ["emissao between ? and ? AND cliente_id = #{cliente_id} #{where_servico} #{where_tecnico}",
        data_inicio, data_fim]
    )
  end

  def remover_acentos texto
    return texto if texto.blank?
    texto = texto.gsub(/[á|à|ã|â|ä]/, 'a').gsub(/(é|è|ê|ë)/, 'e').gsub(/(í|ì|î|ï)/, 'i').gsub(/(ó|ò|õ|ô|ö)/, 'o').gsub(/(ú|ù|û|ü)/, 'u')
    texto = texto.gsub(/(Á|À|Ã|Â|Ä)/, 'A').gsub(/(É|È|Ê|Ë)/, 'E').gsub(/(Í|Ì|Î|Ï)/, 'I').gsub(/(Ó|Ò|Õ|Ô|Ö)/, 'O').gsub(/(Ú|Ù|Û|Ü)/, 'U')
    texto = texto.gsub(/ñ/, 'n').gsub(/Ñ/, 'N')
    texto = texto.gsub(/ç/, 'c').gsub(/Ç/, 'C')
    texto
  end

  def relatorio_grafico dados, legenda, valor_maximo
    Gchart.bar(
      data: dados,
      legend: legenda,
      max_value: valor_maximo,
      theme: :thirty7signals,
      bg: {color: 'efefef', type: 'gradient', angle: 90},
      width: 600,
      heigh: 400,
      stacked: false,
      bar_width_and_spacing: {width: 19, group_spacing: 40},
      labels: ['No período', 'Há um mês', "Há um ano"],
      encoding: 'extended',
      axis_with_labels: ['y'],
      axis_range: [[0, valor_maximo]]
    )
  end

  def maior_valor(valor_maximo, no_periodo, mes_anterior, ano_anterior)
    if valor_maximo < no_periodo
      valor_maximo = no_periodo
    end
    if valor_maximo < mes_anterior
      valor_maximo = mes_anterior
    end
    if valor_maximo < ano_anterior
      valor_maximo = ano_anterior
    end
    valor_maximo
  end

  def todos_os_tecnicos
    tecnicos = ""
    Usuario.all(select: "id", conditions: ["tipo = 'T'"]).collect{ |t|
      tecnicos += tecnicos == "" ? t.id.to_s : ", #{t.id.to_s}"
    }
    tecnicos
  end
  
end
