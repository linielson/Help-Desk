# encoding: UTF-8
class NotificacaoMailer < ActionMailer::Base
  default from: "noreply@helpdesk.com",
          reply_to: "support@helpdesk.com"

  def proxima_etapa etapa
    @etapa = etapa
    mail to: @etapa.tecnico.email,
         subject: "Novo serviço: Tarefa -> #{@etapa.tarefa_id} / Etapa -> #{@etapa.codigo}-#{@etapa.nome}"
  end

  def tarefa_atrasada etapa
    @etapa = etapa
    mail to: @etapa.tecnico.email,
         subject: "Tarefa em atraso: Tarefa -> #{@etapa.tarefa_id} / Etapa -> #{@etapa.codigo}-#{@etapa.nome}"
  end

  def alerta_tarefa tarefa
    @tarefa = tarefa
    mail to: @tarefa.tecnico.email,
         subject: "Tarefa em atraso: Tarefa -> #{@tarefa.id}"
  end
  
end
