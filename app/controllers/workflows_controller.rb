class WorkflowsController < ApplicationController
  
  def add_tarefa
    @tarefa = Tarefa.find(params[:tarefa_id])
    @tarefa.status = "E"
    @tarefa.save!

    @tarefa.workflows.create.save!

    gerenciar_tarefa @tarefa
    
    redirect_to tarefas_path
  end

  def etapa_concluida
    @tarefa = Tarefa.find(params[:tarefa_id])
    gerenciar_tarefa @tarefa
    redirect_to tarefa_tarefa_etapas_path
  end

protected

  def gerenciar_tarefa tarefa
    if todas_etapas_estao_concluidas? tarefa
      marca_tarefa_como_concluida tarefa
    else
      enviar_email_para_o_proximo_tecnico tarefa
    end

    verificar_tarefas_atrasadas
  end

  def todas_etapas_estao_concluidas? tarefa
    numero_de_etapas_abertas_e_em_andamento(tarefa) == 0
  end

  def numero_de_etapas_abertas_e_em_andamento tarefa
    tarefa.tarefa_etapas.count('id', conditions: "status <> 'C'")
  end

  def marca_tarefa_como_concluida tarefa
    tarefa.fechamento = DateTime.now
    tarefa.status = "C"
    tarefa.save!

    tarefa.workflows.delete_all
    tarefa.save!
  end

  def enviar_email_para_o_proximo_tecnico tarefa
    tarefa_etapa = tarefa.tarefa_etapas.order('id ASC').first(conditions: "status <> 'C'")
    NotificacaoMailer.proxima_etapa(tarefa_etapa).deliver
  end

  def verificar_tarefas_atrasadas
    workflows = Workflow.all(conditions: ["data < ? OR data is null", (DateTime.now - 1.day).to_date])

    workflows.each do |w|
      if w.tarefa.esta_atrasada?
        tarefa_etapa = w.tarefa.tarefa_etapas.first(conditions: "status <> 'C'")
        NotificacaoMailer.tarefa_atrasada(tarefa_etapa).deliver

        if w.tarefa.entrega.to_date < (DateTime.now - 3.day).to_date
          NotificacaoMailer.alerta_tarefa(w.tarefa).deliver
        end

        w.data = DateTime.now
        w.save!
      end
    end
  end

end
