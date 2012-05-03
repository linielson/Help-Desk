require 'test_helper'

class TarefaHorasControllerTest < ActionController::TestCase
  setup do
    @tarefa_hora = tarefa_horas(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tarefa_horas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tarefa_hora" do
    assert_difference('TarefaHora.count') do
      post :create, tarefa_hora: @tarefa_hora.attributes
    end

    assert_redirected_to tarefa_hora_path(assigns(:tarefa_hora))
  end

  test "should show tarefa_hora" do
    get :show, id: @tarefa_hora
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tarefa_hora
    assert_response :success
  end

  test "should update tarefa_hora" do
    put :update, id: @tarefa_hora, tarefa_hora: @tarefa_hora.attributes
    assert_redirected_to tarefa_hora_path(assigns(:tarefa_hora))
  end

  test "should destroy tarefa_hora" do
    assert_difference('TarefaHora.count', -1) do
      delete :destroy, id: @tarefa_hora
    end

    assert_redirected_to tarefa_horas_path
  end
end
