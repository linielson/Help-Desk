require 'test_helper'

class ServicoEtapasControllerTest < ActionController::TestCase
  setup do
    @servico_etapa = servico_etapas(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:servico_etapas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create servico_etapa" do
    assert_difference('ServicoEtapa.count') do
      post :create, servico_etapa: @servico_etapa.attributes
    end

    assert_redirected_to servico_etapa_path(assigns(:servico_etapa))
  end

  test "should show servico_etapa" do
    get :show, id: @servico_etapa
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @servico_etapa
    assert_response :success
  end

  test "should update servico_etapa" do
    put :update, id: @servico_etapa, servico_etapa: @servico_etapa.attributes
    assert_redirected_to servico_etapa_path(assigns(:servico_etapa))
  end

  test "should destroy servico_etapa" do
    assert_difference('ServicoEtapa.count', -1) do
      delete :destroy, id: @servico_etapa
    end

    assert_redirected_to servico_etapas_path
  end
end
