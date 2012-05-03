require 'test_helper'

class NotificacaoMailerTest < ActionMailer::TestCase
  test "proxima_etapa," do
    mail = NotificacaoMailer.proxima_etapa,
    assert_equal "Proxima etapa,", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "tarefa_atrasada," do
    mail = NotificacaoMailer.tarefa_atrasada,
    assert_equal "Tarefa atrasada,", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "alerta_tarefa" do
    mail = NotificacaoMailer.alerta_tarefa
    assert_equal "Alerta tarefa", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
