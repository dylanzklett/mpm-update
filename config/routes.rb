Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'

  root 'dashboards#show'
  resource :dashboard, only: :show

  scope path: '/admin', module: 'admins' do
    resources :users
    resources :settings, only: [:index, :update]
  end
  resources :sales, only: :index
  resource :profile, only: [:edit, :update]

  resources :customers
  resources :searches, only: :index
  resources :projects do
    resource :state, only: :update
    resource :email, only: [:new, :create]
    resources :curtains, except: [:index, :show]
    resources :items, except: [:index, :show, :new, :create]
    scope module: 'projects' do
      resources :versions, only: [:index, :show, :update] do
        resource :restore, only: :create
      end
    end
    scope module: 'tasks' do
      resources :drape_tasks, except: :index
      resources :trough_tasks, except: :index
    end
  end

  resources :manufacturers do
    resources :services, except: [:index, :show]
    resources :inventory_items, except: [:index, :show]
  end
  resources :inventory_items, only: [] do
    resources :inventory_history_items, only: [:index, :new, :create]
  end
  resources :tasks do
    scope module: 'tasks' do
      resource :label, only: :new
      resource :sew_label, only: :new
      resource :task_items, only: :edit
      resource :support_items, only: :edit
      resource :email, only: [:new, :create]
    end
  end
  resources :drape_tasks, only: :update, controller: :tasks
  resources :trough_tasks, only: :update, controller: :tasks

  resources :users, only: [] do
    resource :change_password, only: [:edit, :update], module: :users
  end
end
