Helpdesk::Application.routes.draw do

  # Reports
  match '/relatorios/' => "relatorios#index", as: :relatorios
  match '/relatorios/gerar' => "relatorios#gerar", as: :gerar

  # 01
  match '/relatorios/01' => "relatorios#index_01", as: :index_01
  match '/relatorios/01/executar' => "relatorios#executar_01", as: :executar_01
  match '/relatorios/01/saida' => "relatorios#saida_01", as: :saida_01
  #

  #02
  match '/relatorios/02' => "relatorios#index_02", as: :index_02
  match '/relatorios/02/executar' => "relatorios#executar_02", as: :executar_02
  match '/relatorios/02/saida' => "relatorios#saida_02", as: :saida_02
  #

  #03
  match '/relatorios/03' => "relatorios#index_03", as: :index_03
  match '/relatorios/03/executar' => "relatorios#executar_03", as: :executar_03
  match '/relatorios/03/saida' => "relatorios#saida_03", as: :saida_03
  #

  #04
  match '/relatorios/04' => "relatorios#index_04", as: :index_04
  match '/relatorios/04/executar' => "relatorios#executar_04", as: :executar_04
  match '/relatorios/04/saida' => "relatorios#saida_04", as: :saida_04
  #

  #05
  match '/relatorios/05' => "relatorios#index_05", as: :index_05
  match '/relatorios/05/executar' => "relatorios#executar_05", as: :executar_05
  match '/relatorios/05/saida' => "relatorios#saida_05", as: :saida_05
  #

  #06
  match '/relatorios/06' => "relatorios#index_06", as: :index_06
  match '/relatorios/06/executar' => "relatorios#executar_06", as: :executar_06
  match '/relatorios/06/saida' => "relatorios#saida_06", as: :saida_06
  #

  resources :tarefas do
    match 'iniciar/' => "tarefas#iniciar", as: :iniciar
    resources :etapas, as: :tarefa_etapas, controller: :tarefa_etapas do
      match 'iniciar/'  => "tarefa_etapas#iniciar", as: :iniciar
      match 'pausar/' => "tarefa_etapas#pausar", as: :pausar
      match 'concluir/' => "tarefa_etapas#concluir", as: :concluir
    end
    resources :anexos, as: :tarefa_anexos, controller: :tarefa_anexos
    resources :horas, as: :tarefa_horas, controller: :tarefa_horas

    match 'workflow/add_tarefa/' => "workflows#add_tarefa", as: :add_tarefa
    match 'workflow/etapa_concluida/' => "workflows#etapa_concluida", as: :etapa_concluida
  end

  match 'impressao/' => "tarefas#impressao", as: :impressao
  match 'imprimir/' => "tarefas#imprimir", as: :imprimir
  match 'imprimir/html/' => "tarefas#preparar_impressao_html", as: :preparar_impressao_html
  match 'imprimir/impressao/html' => "tarefas#impressao_html", as: :impressao_html

  resources :servicos do
    resources :etapas, as: :servico_etapas, controller: :servico_etapas
  end

  resources :projetos do
    match 'iniciar/' => "projetos#iniciar", as: :iniciar
    match 'concluir/' => "projetos#concluir", as: :concluir
  end
  
  match 'painel_projetos/' => "projetos#painel", as: :painel_projetos

  resources :recursos

  resources :clientes, as: :pessoas, controller: :pessoas

  resources :usuarios, except: [:show]
  
  devise_for :usuarios, path: '', path_names: {sign_in: "login", sign_out: "logout"}

  match 'home/' => "pages#index", as: :index

#  authenticate :usuario do
    root to: "pages#index"
#  end

#  root to: "devise/sessions#new"

  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
