module TarefaEtapasHelper
  
  def numero_pixels_para_completar_workflow tarefa
    numero_etapas = tarefa.tarefa_etapas.size
    if numero_etapas > 1
      total_pixels = (9 - numero_etapas) * 104
      (total_pixels / (numero_etapas - 1)).to_i
    else
      0
    end
  end

  def tamanho_total_workflow tarefa, porcentagem

    if porcentagem or tarefa.tarefa_etapas.size < 9
      "100%"
    else
      "#{tarefa.tarefa_etapas.size * 104}px"
    end
#    if tarefa.tarefa_etapas.size > 9
#      tarefa.tarefa_etapas.size * 104
#    else
#      1024
#    end
  end

end
