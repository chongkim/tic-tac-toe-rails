TicTacToeRails::Application.routes.draw do
  resources :ckims


  resources :games do
    get 'opponent_move', :on => :member
    get 'get_position', :on => :member
  end
  resources :users

  root :to => 'ttt#index'

  match '/sign_in'  => 'users#sign_in',  :as => 'sign_in'
  match '/sign_out' => 'users#sign_out', :as => 'sign_out'
  match '/sign_up'  => 'users#new',  :as => 'sign_up'
  match '/ttt/move', :controller => "ttt", :action => "move"
end
