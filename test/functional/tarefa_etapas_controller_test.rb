require 'test_helper'

class TarefaEtapasControllerTest < ActionController::TestCase
  setup do
    @tarefa_etapa = tarefa_etapas(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tarefa_etapas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tarefa_etapa" do
    assert_difference('TarefaEtapa.count') do
      post :create, tarefa_etapa: @tarefa_etapa.attributes
    end

    assert_redirected_to tarefa_etapa_path(assigns(:tarefa_etapa))
  end

  test "should show tarefa_etapa" do
    get :show, id: @tarefa_etapa
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tarefa_etapa
    assert_response :success
  end

  test "should update tarefa_etapa" do
    put :update, id: @tarefa_etapa, tarefa_etapa: @tarefa_etapa.attributes
    assert_redirected_to tarefa_etapa_path(assigns(:tarefa_etapa))
  end

  test "should destroy tarefa_etapa" do
    assert_difference('TarefaEtapa.count', -1) do
      delete :destroy, id: @tarefa_etapa
    end

    assert_redirected_to tarefa_etapas_path
  end
end
