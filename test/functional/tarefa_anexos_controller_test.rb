require 'test_helper'

class TarefaAnexosControllerTest < ActionController::TestCase
  setup do
    @tarefa_anexo = tarefa_anexos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tarefa_anexos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tarefa_anexo" do
    assert_difference('TarefaAnexo.count') do
      post :create, tarefa_anexo: @tarefa_anexo.attributes
    end

    assert_redirected_to tarefa_anexo_path(assigns(:tarefa_anexo))
  end

  test "should show tarefa_anexo" do
    get :show, id: @tarefa_anexo
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tarefa_anexo
    assert_response :success
  end

  test "should update tarefa_anexo" do
    put :update, id: @tarefa_anexo, tarefa_anexo: @tarefa_anexo.attributes
    assert_redirected_to tarefa_anexo_path(assigns(:tarefa_anexo))
  end

  test "should destroy tarefa_anexo" do
    assert_difference('TarefaAnexo.count', -1) do
      delete :destroy, id: @tarefa_anexo
    end

    assert_redirected_to tarefa_anexos_path
  end
end
